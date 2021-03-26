"
I implement the redis subscriber protocol for Pub/Sub which is detailed at https://redis.io/topics/pubsub

 The commands that are allowed in the context of a subscribed client are SUBSCRIBE, PSUBSCRIBE, UNSUBSCRIBE, PUNSUBSCRIBE, PING and QUIT.

I also implement the Announcer listener registration methods when:do and friends.

My version converts subscriptions to use RedisAnnouncement which captures the Redis concept of
a subscriptions as channel/message.
"
Trait {
	#name : #TRedisSubscriber,
	#category : #'Redis-Traits'
}

{ #category : #announcer }
TRedisSubscriber >> announcer [ 
	^ self explicitRequirement
]

{ #category : #subscription }
TRedisSubscriber >> psubscribe: aTopicOrListOfTopics [

	^self execute: #(PSUBSCRIBE), (aTopicOrListOfTopics isString 
			ifTrue: [ { aTopicOrListOfTopics } ]
			ifFalse: [ aTopicOrListOfTopics ] ) await: 'psubscribe'
]

{ #category : #subscription }
TRedisSubscriber >> punsubscribe: aTopicOrListOfTopics [
	^self execute: #(PUNSUBSCRIBE), (aTopicOrListOfTopics isString 
			ifTrue: [ { aTopicOrListOfTopics } ]
			ifFalse: [ aTopicOrListOfTopics ] ) await: 'punsubscribe'
]

{ #category : #running }
TRedisSubscriber >> quit [ 
	self execute: { #QUIT }
]

{ #category : #subscription }
TRedisSubscriber >> subscribe: aTopicOrListOfTopics [

	^self execute: #(SUBSCRIBE), (aTopicOrListOfTopics isString 
			ifTrue: [ { aTopicOrListOfTopics } ]
			ifFalse: [ aTopicOrListOfTopics ] ) await: 'subscribe'
]

{ #category : #subscription }
TRedisSubscriber >> subscribedChannels [
	^(self announcer subscriptions subscriptions asArray select: [ :ea | ea announcementClass class = RedisAnnouncement ]) collect: [:ea | ea announcementClass channel ]
]

{ #category : #subscription }
TRedisSubscriber >> unsubscribe: aTopicOrListOfTopics [
	^self execute: #(UNSUBSCRIBE), (aTopicOrListOfTopics isString 
			ifTrue: [ { aTopicOrListOfTopics } ]
			ifFalse: [ aTopicOrListOfTopics ] ) await: 'unsubscribe'
]

{ #category : #announcer }
TRedisSubscriber >> when:aChannel do: aValuable [ 
	self announcer 
		when: (RedisAnnouncement channel: aChannel) 
		do: [ :announcement :announcer | 
			aValuable 
				cull: announcement message 
				cull: announcement channel 
				cull: announcer ].
	self isOpen ifTrue: [ self subscribe: aChannel ]
]

{ #category : #announcer }
TRedisSubscriber >> when: anAnnouncementClass do: aValuable for: aSubscriber [
	"Declare that when anAnnouncementClass is raised, aValuable is executed and define the subscriber."
	
    ^ (self when: anAnnouncementClass do: aValuable) subscriber: aSubscriber; yourself
]

{ #category : #announcer }
TRedisSubscriber >> when: anAnnouncementClass send: aSelector to: anObject [
	"Declare that when anAnnouncementClass is raised, anObject should receive the message aSelector.
    When the message expects one argument (eg #fooAnnouncement:) the announcement is passed as argument.
    When the message expects two arguments (eg #fooAnnouncement:announcer:) both the announcement and 
    the announcer are passed as argument"

	^ self 
		when: anAnnouncementClass
		do: (MessageSend receiver: anObject selector: aSelector)
]
