"
I am SimpleRedisClient, a minimal client to Redis, a networked, in-memory key-value store with optional durability supporting different kinds of abstract data structures.

Example

  SimpleRedisClient new in: [ :client |
    [ client open; execute: { #ECHO. 'This is Pharo' } ] ensure: [ client close ] ].

About Redis

 https://redis.io
 https://en.wikipedia.org/wiki/Redis
 https://redis.io/topics/protocol

Source code repository

 https://github.com/svenvc/SimpleRedisClient

Article

 https://medium.com/concerning-pharo/quick-write-me-a-redis-client-5fbe4ddfb13d

"
Class {
	#name : #RedisAbstractClient,
	#superclass : #Object,
	#traits : 'TRedisClient',
	#classTraits : 'TRedisClient classTrait',
	#instVars : [
		'host',
		'port',
		'connection',
		'in',
		'out',
		'handlers',
		'attributes'
	],
	#classVars : [
		'AlwaysRestart',
		'ManagedServers'
	],
	#category : #RedisClient
}

{ #category : #'class initialization' }
RedisAbstractClient class >> alwaysRestart [
	^ AlwaysRestart ifNil: [ AlwaysRestart := true ]
]

{ #category : #'class initialization' }
RedisAbstractClient class >> alwaysRestart: boolean [
	"Set if managed servers should always restart on image save, as opposed to only when quiting."

	^ AlwaysRestart := boolean
]

{ #category : #'class initialization' }
RedisAbstractClient class >> initialize [
	ManagedServers := IdentitySet new.
	AlwaysRestart := true.
	self environment 
		at: #SessionManager 
		ifPresent: [ :manager | manager default registerNetworkClassNamed: self name ]
		ifAbsent: [ Smalltalk addToStartUpList: self; addToShutDownList: self ]
	
]

{ #category : #'system startup' }
RedisAbstractClient class >> managedServers [
	^ ManagedServers ifNil: [ ManagedServers := IdentitySet new ]
]

{ #category : #'system startup' }
RedisAbstractClient class >> register: server [
	"Arrange for server to be sent start/stop on system startUp/shutDown"
	
	self managedServers add: server
]

{ #category : #'system startup' }
RedisAbstractClient class >> shutDown: quiting [
	"Our system shutDown hook: stop all servers we manage"
	
	(quiting or: [ self alwaysRestart ])
		ifTrue: [
			self managedServers do: [ :each | each stop: false ] ]
]

{ #category : #'system startup' }
RedisAbstractClient class >> startUp: resuming [
	"Our system startUp hook: start all servers we manage.
	We do this using deferred startup actions to allow normal error handling."

	(resuming or: [ self alwaysRestart ])
		ifTrue: [
			self environment 
				at: #SessionManager 
				ifPresent: [ :manager | 
					manager default currentSession addDeferredStartupAction: [ 
						self managedServers do: [ :each | each start ] ] ]
				ifAbsent: [ 
					Smalltalk addDeferredStartupAction: [ 
						self managedServers do: [ :each | each start ] ] ] ]
]

{ #category : #'system startup' }
RedisAbstractClient class >> unregister: server [
	"No longer send server start/stop on system startUp/shutDown"
	
	self managedServers remove: server ifAbsent: [ ]
]

{ #category : #accessing }
RedisAbstractClient >> attributes [
	^attributes
]

{ #category : #'initialize-release' }
RedisAbstractClient >> close [
	connection
		ifNotNil: [ 
			[ connection close ] on: Error do: [ #ignore ].
			in := out := connection := nil ]
]

{ #category : #accessing }
RedisAbstractClient >> handlers [ 
	^ handlers
]

{ #category : #accessing }
RedisAbstractClient >> host [
	^ host ifNil: [ host := 'localhost' ]
]

{ #category : #accessing }
RedisAbstractClient >> host: string [
	host := string
]

{ #category : #accessing }
RedisAbstractClient >> in [ 	
	^in
]

{ #category : #'initialize-release' }
RedisAbstractClient >> initialize [ 
	super initialize.
	handlers := self buildReadHandlers
]

{ #category : #'initialize-release' }
RedisAbstractClient >> open [
	self close.
	connection := ZdcSocketStream openConnectionToHostNamed: self host port: self port.
	in := ZnCharacterReadStream on: connection.
	out := ZnCharacterWriteStream on: connection.
	self hello: 3.
]

{ #category : #accessing }
RedisAbstractClient >> port [
	^ port ifNil: [ port := 6379 ]
]

{ #category : #accessing }
RedisAbstractClient >> port: integer [
	port := integer
]

{ #category : #accessing }
RedisAbstractClient >> postPushNotification: notification [ 
	Transcript show: notification printString; cr.
]

{ #category : #accessing }
RedisAbstractClient >> reportAttribute: anObject [
	attributes := Array streamContents: [ :s | 
		attributes ifNotNil: [ s nextPutAll: attributes ]. 
		s nextPut: anObject
		]
]

{ #category : #writing }
RedisAbstractClient >> writeCommand: args [
	out nextPut: $*; print: args size; crlf.
	args do: [ :each |
		| string byteCount |
		string := each asString.
		byteCount := out encoder encodedByteCountForString: string.
		out 
			nextPut: $$; print: byteCount; crlf; 
			nextPutAll: string; crlf ].
	out flush
]

{ #category : #writing }
RedisAbstractClient >> writeInlineCommand: string [
	out nextPutAll: string; crlf; flush
]
