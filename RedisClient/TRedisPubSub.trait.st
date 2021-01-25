Trait {
	#name : #TRedisPubSub,
	#traits : 'TRedis',
	#classTraits : 'TRedis classTrait',
	#category : #RedisClient
}

{ #category : #publishing }
TRedisPubSub >> announce: aMessage [
	^ self explicitRequirement
]

{ #category : #publishing }
TRedisPubSub >> publish: aChannel message: aMessage [
	self execute: { #PUBLISH. aChannel. aMessage }
]

{ #category : #subscription }
TRedisPubSub >> subscribe: aTopicOrListOfTopics [

	^self execute: #(SUBSCRIBE), (aTopicOrListOfTopics isString 
			ifTrue: [ { aTopicOrListOfTopics } ]
			ifFalse: [ aTopicOrListOfTopics ] ) await: 'subscribe'
]

{ #category : #subscription }
TRedisPubSub >> unsubscribe: aTopicOrListOfTopics [
	^self execute: #(UNSUBSCRIBE), (aTopicOrListOfTopics isString 
			ifTrue: [ { aTopicOrListOfTopics } ]
			ifFalse: [ aTopicOrListOfTopics ] ) await: 'subscribe'
]
