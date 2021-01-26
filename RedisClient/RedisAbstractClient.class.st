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
	#traits : 'TRedisClient + TRedisReader',
	#classTraits : 'TRedisClient classTrait + TRedisReader classTrait',
	#instVars : [
		'servers',
		'connection',
		'in',
		'out',
		'handlers',
		'attributes',
		'monitor',
		'queue',
		'process',
		'announcer',
		'logCommands',
		'logPushes',
		'server'
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

{ #category : #publishing }
RedisAbstractClient >> announce: aMessage [
	| class ann | 
	class := Smalltalk at: aMessage second asSymbol ifAbsent: [  ].
	class ifNotNil: [ 
		ann := class new message: aMessage third.
		self announcer ifNotNil: [:a | a announce: ann ] ].
]

{ #category : #accessing }
RedisAbstractClient >> announcer [
	^announcer first
]

{ #category : #accessing }
RedisAbstractClient >> announcer: aRedisAnnouncer [
	announcer := WeakArray with: aRedisAnnouncer.
	self refreshSubscriptions
	
]

{ #category : #accessing }
RedisAbstractClient >> attributes [
	^ attributes
]

{ #category : #accessing }
RedisAbstractClient >> attributes: anObject [
	attributes := anObject
]

{ #category : #'connection open/close' }
RedisAbstractClient >> close [
	connection
		ifNotNil: [ 
			[ connection close ] on: Error do: [ #ignore ].
			in := out := connection := nil ]
]

{ #category : #accessing }
RedisAbstractClient >> connection [
	^ connection
]

{ #category : #accessing }
RedisAbstractClient >> connection: anObject [
	^ connection := anObject
]

{ #category : #accessing }
RedisAbstractClient >> db [
	^ self server db
]

{ #category : #running }
RedisAbstractClient >> execute: commandArgs [
	^monitor critical: [ | reply |
	Transcript show: ('Redis execute: ', commandArgs asString); cr.
	self writeCommand: commandArgs.
	reply := self readReply. 
	Transcript show: ('Redis leave execute: ', commandArgs asString); cr.
	reply ] 
]

{ #category : #running }
RedisAbstractClient >> execute: commandArgs await: aMessageType [
	"lazy launch listener - it isn't required until this is called"
	self startListening.
	^ monitor critical: [ | reply |
		logCommands 
			ifTrue: [Transcript show: ('Redis execute: ', commandArgs asString, 'await: ', aMessageType); cr].
		self writeCommand: commandArgs.
		reply := self waitReply: aMessageType.
		logCommands 
			ifTrue: [Transcript show: ('Redis leave execute: ', commandArgs asString, 'await: ', aMessageType); cr].
		reply
		 ]
]

{ #category : #running }
RedisAbstractClient >> executeInline: command [
	^monitor critical: [ | reply |
	Transcript show: ('Redis executeInline: ', command asString); cr.
	self writeInlineCommand: command.
	reply := self readReply.
	Transcript show: ('Redis leave executeInline: ', command asString); cr.
	reply
	 ]
]

{ #category : #accessing }
RedisAbstractClient >> handlers [ 
	^ handlers
]

{ #category : #accessing }
RedisAbstractClient >> handlers: anObject [
	handlers := anObject
]

{ #category : #accessing }
RedisAbstractClient >> host [
	^ self server host
]

{ #category : #accessing }
RedisAbstractClient >> in [ 	
	^in
]

{ #category : #initialization }
RedisAbstractClient >> initialize [ 
	super initialize.
	logPushes := false.
	logCommands := true.
	servers := { RedisServerSpec new }.
	handlers := self buildReadHandlers.
	monitor := Semaphore forMutualExclusion.
	queue := OrderedCollection new.
	announcer := RedisAnnouncer on: self
]

{ #category : #testing }
RedisAbstractClient >> isListening [
	^process notNil
]

{ #category : #testing }
RedisAbstractClient >> isOpen [
	^connection notNil
]

{ #category : #accessing }
RedisAbstractClient >> logCommands [
	^ logCommands
]

{ #category : #accessing }
RedisAbstractClient >> logCommands: anObject [
	logCommands := anObject
]

{ #category : #accessing }
RedisAbstractClient >> logPushes [
	^ logPushes
]

{ #category : #accessing }
RedisAbstractClient >> logPushes: anObject [
	logPushes := anObject
]

{ #category : #accessing }
RedisAbstractClient >> monitor [ 
	^monitor
]

{ #category : #'connection open/close' }
RedisAbstractClient >> open [
	self close.
	connection := ZdcSocketStream openConnectionToHostNamed: self host port: self port.
	in := ZnCharacterReadStream on: connection.
	out := ZnCharacterWriteStream on: connection.
	self hello: 3.
]

{ #category : #accessing }
RedisAbstractClient >> out [
	^ out
]

{ #category : #accessing }
RedisAbstractClient >> out: anObject [
	^ out := anObject
]

{ #category : #accessing }
RedisAbstractClient >> port [
	^ self server port
]

{ #category : #accessing }
RedisAbstractClient >> postPushNotification: notification [ 
	Transcript show: notification printString; cr.
]

{ #category : #accessing }
RedisAbstractClient >> queue [ 
	^ queue
]

{ #category : #accessing }
RedisAbstractClient >> randomServer [
	^self servers at: (SharedRandom globalGenerator nextInt: self servers size)
]

{ #category : #accessing }
RedisAbstractClient >> reportAttribute: anObject [
	attributes := Array streamContents: [ :s | 
		attributes ifNotNil: [ s nextPutAll: attributes ]. 
		s nextPut: anObject
		]
]

{ #category : #accessing }
RedisAbstractClient >> server [
	^ server ifNil: [ server := self randomServer ]
]

{ #category : #accessing }
RedisAbstractClient >> server: anObject [
	server := anObject
]

{ #category : #accessing }
RedisAbstractClient >> servers [
	^servers ifNil: [ servers := { RedisServerSpec new } ]
]

{ #category : #accessing }
RedisAbstractClient >> servers: aStringOrArray [
	
	aStringOrArray isString 
		ifTrue: [ 
			servers := (aStringOrArray splitOn: '|') 
				collect: [ :ea | RedisServerSpec on: ea asUrl ] ]
		ifFalse: [ 
			aStringOrArray isArray 
				ifTrue: [servers := aStringOrArray 
					collect: [:ea | RedisServerSpec on: ea asUrl] ] ].
	servers isEmpty ifTrue: [ servers := { RedisServerSpec new } ].
	server := self randomServer
]

{ #category : #running }
RedisAbstractClient >> startListening [
	process ifNotNil: [ ^self ].
	process := [
		[ 	| timeout |
			monitor critical: [ [  
				logPushes ifTrue: [Transcript show: 'Redis poll...'; cr].
				timeout := in wrappedStream timeout.
				in wrappedStream timeout: 0.
				self readAllPushNotifications ] ensure: [in wrappedStream timeout: timeout]]. 
			logPushes ifTrue: [Transcript show: 'Redis end poll...'; cr].
			Processor yield ] 
		repeat ] forkNamed: 'RedisClient Polling'.
]

{ #category : #running }
RedisAbstractClient >> stopListening [
	process ifNotNil: [ 
		process terminate.
		process := nil ]
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
