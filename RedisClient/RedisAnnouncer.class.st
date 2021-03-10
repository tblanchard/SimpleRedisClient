"
I am a custom announcer that works with Redis Pub/Sub messages.


"
Class {
	#name : #RedisAnnouncer,
	#superclass : #Announcer,
	#instVars : [
		'client'
	],
	#category : #'RedisClient-PubSub'
}

{ #category : #'instance creation' }
RedisAnnouncer class >> on: aRedisPubSubClient [
	^(self new) 
		client: aRedisPubSubClient;
		yourself 
]

{ #category : #accessing }
RedisAnnouncer >> client [
	^ client
]

{ #category : #accessing }
RedisAnnouncer >> client: anObject [
	client := anObject
]

{ #category : #'registration api' }
RedisAnnouncer >> when: anAnnouncementClass do: aValuable [
	"Declare that when anAnnouncementClass is raised, aValuable is executed.  Pay attention that such method as well as #when:do: should not be used on weak announcer since the block holds the receiver and more strongly."
	
	anAnnouncementClass isString 
		ifTrue: [ ^super 
			when: (RedisAnnouncement new channel: anAnnouncementClass asSymbol; yourself) 
			do: aValuable ].
	anAnnouncementClass class = RedisAnnouncement  
		ifTrue: [ ^super when: anAnnouncementClass do: aValuable ]
	
]
