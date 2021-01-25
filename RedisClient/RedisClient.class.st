Class {
	#name : #RedisClient,
	#superclass : #RedisAbstractClient,
	#traits : 'TRedisKeys + TRedisReader',
	#classTraits : 'TRedisKeys classTrait + TRedisReader classTrait',
	#instVars : [
		'monitor',
		'queue',
		'process',
		'announcer'
	],
	#category : #RedisClient
}

{ #category : #accessing }
RedisClient >> announcer [
	^ announcer
]

{ #category : #accessing }
RedisClient >> announcer: anObject [
	announcer := anObject
]

{ #category : #'initialize-release' }
RedisClient >> close [ 
	process ifNotNil: [ 
		process terminate.
		process := nil ].
	super close
]

{ #category : #running }
RedisClient >> execute: commandArgs [
	^monitor critical: [ | reply |
	Transcript show: ('Redis execute: ', commandArgs asString); cr.
	self writeCommand: commandArgs.
	reply := self readReply. 
	Transcript show: ('Redis leave execute: ', commandArgs asString); cr.
	reply ] 
]

{ #category : #running }
RedisClient >> execute: commandArgs await: aMessageType [
	^ monitor critical: [ | reply |
		Transcript show: ('Redis execute: ', commandArgs asString, 'await: ', aMessageType); cr.
		self writeCommand: commandArgs.
		reply := self waitReply: aMessageType.
		Transcript show: ('Redis leave execute: ', commandArgs asString, 'await: ', aMessageType); cr.
		reply
		 ]
]

{ #category : #running }
RedisClient >> executeInline: command [
	^monitor critical: [ | reply |
	Transcript show: ('Redis executeInline: ', command asString); cr.
	self writeInlineCommand: command.
	reply := self readReply.
	Transcript show: ('Redis leave executeInline: ', command asString); cr.
	reply
	 ]
]

{ #category : #accessing }
RedisClient >> handlers [ 
	^ handlers
]

{ #category : #accessing }
RedisClient >> in [ 
	^in
]

{ #category : #'initialize-release' }
RedisClient >> initialize [ 
	super initialize.
	monitor := Semaphore forMutualExclusion.
	queue := OrderedCollection new.
	announcer := RedisAnnouncer on: self.

]

{ #category : #accessing }
RedisClient >> monitor: anObject [
	monitor := anObject
]

{ #category : #'initialize-release' }
RedisClient >> open [ 
	super open.
	process := [
		[ 	| timeout |
			monitor critical: [ [  
				Transcript show: 'Redis poll...'; cr.
				timeout := in wrappedStream timeout.
				in wrappedStream timeout: 0.
				self readAllPushNotifications ] ensure: [in wrappedStream timeout: timeout]]. 
			Transcript show: 'Redis end poll...'; cr.
			Processor yield ] 
		repeat ] forkNamed: 'RedisClient Polling'.
]

{ #category : #accessing }
RedisClient >> process [
	^ process
]

{ #category : #accessing }
RedisClient >> process: anObject [
	^ process := anObject
]

{ #category : #accessing }
RedisClient >> queue [ 
	^ monitor
]

{ #category : #accessing }
RedisClient >> queue: anObject [
	queue := anObject
]
