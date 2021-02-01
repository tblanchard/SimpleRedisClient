"
I am a base class for a redis publish event with is basically a channel name and message string pair.
"
Class {
	#name : #RedisAnnouncement,
	#superclass : #Announcement,
	#instVars : [
		'channel',
		'message'
	],
	#category : #RedisClient
}

{ #category : #creation }
RedisAnnouncement class >> channel: aName [
	^self new channel: aName asSymbol; yourself
]

{ #category : #creation }
RedisAnnouncement class >> channel: aName message: aMessage [
	^self new channel: aName asSymbol; message: aMessage; yourself
]

{ #category : #testing }
RedisAnnouncement class >> handlesAnnouncement: anAnnouncement [
	"The receiver acts as a filter to determine whether subscribers who used the receiver as signaling tag (event identifier class or symbol) should receive incoming announcement. In particular, registering to a superclass will receive the announcements from all subclasses."
	

	^ self = anAnnouncement class and: [ self channel = anAnnouncement channel ]
]

{ #category : #accessing }
RedisAnnouncement >> channel [
	^ channel
]

{ #category : #accessing }
RedisAnnouncement >> channel: aChannel [
	^ channel := aChannel asSymbol
]

{ #category : #accessing }
RedisAnnouncement >> handlesAnnouncement: anAnnouncement [
	"The receiver acts as a filter to determine whether subscribers who used the receiver as signaling tag (event identifier class or symbol) should receive incoming announcement. In particular, registering to a superclass will receive the announcements from all subclasses."
	

	^ self class = anAnnouncement class and: [ self channel = anAnnouncement channel ]
]

{ #category : #accessing }
RedisAnnouncement >> message [
	^ message
]

{ #category : #accessing }
RedisAnnouncement >> message: aMessage [
	message := aMessage
]
