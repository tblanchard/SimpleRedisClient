Class {
	#name : #RedisPubSubClient,
	#superclass : #RedisAbstractClient,
	#traits : 'TRedisReader + TRedisPubSub',
	#classTraits : 'TRedisReader classTrait + TRedisPubSub classTrait',
	#instVars : [
		'queue',
		'announcer',
		'monitor'
	],
	#category : #RedisClient
}

{ #category : #publishing }
RedisPubSubClient >> announce: aMessage [
	| class ann | 
	class := Smalltalk at: aMessage second asSymbol ifAbsent: [  ].
	class ifNotNil: [ 
		ann := class new message: aMessage third.
		self announcer ifNotNil: [:a | a announce: ann ] ].
]

{ #category : #accessing }
RedisPubSubClient >> announcer [
	^announcer first
]

{ #category : #accessing }
RedisPubSubClient >> announcer: aRedisAnnouncer [
	announcer := WeakArray with: aRedisAnnouncer.
	self refreshSubscriptions
	
]

{ #category : #running }
RedisPubSubClient >> execute: commandArgs [
	^monitor critical: [  
	attributes := nil.
	[self writeCommand: commandArgs.
	self readReply] on: Error do:[ self open ] ] 
]

{ #category : #accessing }
RedisPubSubClient >> handlers [ 
	^ handlers
]

{ #category : #accessing }
RedisPubSubClient >> in [ 
	^in
]

{ #category : #'initialize-release' }
RedisPubSubClient >> initialize [ 
	super initialize.
	queue := SharedQueue new.
	monitor := Mutex new.
	RedisAnnouncer on: self
]

{ #category : #accessing }
RedisPubSubClient >> monitor [ 
	^ monitor
]

{ #category : #'initialize-release' }
RedisPubSubClient >> open [ 
	super open.
	self refreshSubscriptions
]

{ #category : #reading }
RedisPubSubClient >> postPushNotification: aMessage [ 
	^ self announce: aMessage
]

{ #category : #running }
RedisPubSubClient >> refreshSubscriptions [
	self announcer ifNotNil: [ :ann |
		self subscribe: (ann subscriptions collect: [ :sub | sub announcementClass name ]) ]
]
