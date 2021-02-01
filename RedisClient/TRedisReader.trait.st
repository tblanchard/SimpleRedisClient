Trait {
	#name : #TRedisReader,
	#category : #RedisClient
}

{ #category : #reading }
TRedisReader >> buildReadHandlers [
	^{ 
	"RESP2"
		$+ -> [ self readString ].
		$: -> [ self readInteger ].
		$- -> [ self readError ].
		$* -> [ self readArray ].
		$$ -> [ self readBulkString ].
	"RESP3"
		$_ -> [ self readNil ].
		$, -> [ self readFloat ].
		$# -> [ self readBoolean ].
		$! -> [ self readBlobError ].
		$= -> [ self readVerbatimString ].
		$( -> [ self readNumber ].
		$~ -> [ self readSet ].
		$% -> [ self readDictionary ].
		$| -> [ self readAttribute ].
		$> -> [ self readPushNotification ].
	 } asDictionary
]

{ #category : #accessing }
TRedisReader >> handlers [ 
	^ self explicitRequirement
]

{ #category : #accessing }
TRedisReader >> in [ 
	^ self explicitRequirement
]

{ #category : #parsing }
TRedisReader >> parseClientList: aString [
	^(self parseList: aString) collect: [ :ea | self parseDictionary: ea ]
]

{ #category : #parsing }
TRedisReader >> parseDictionary: aString [
	^(aString substrings collect: [ :ea || pair key value |
		pair := ea substrings: '='. 
		key := pair first.
		value := pair last.
		(value allSatisfy: [ :ch | ch isDigit or: [ ch = $- or: [ ch = $. ] ] ])
			ifTrue: [ value := value asNumber ].
		key -> value ]) asDictionary
]

{ #category : #parsing }
TRedisReader >> parseList: aString [
	^aString lines
]

{ #category : #reading }
TRedisReader >> postPushNotification: aMessage [ 
	(aMessage first endsWith: 'message') 
		ifTrue: [ ^self announce: aMessage ] 
		ifFalse: [ self queue add: aMessage ]
]

{ #category : #accessing }
TRedisReader >> queue [ 
	^ self explicitRequirement
]

{ #category : #reading }
TRedisReader >> readAllPushNotifications [ 
	"Only call this if you are after a message that is not a push notification"
	"Push notifications are retrieved with waitReply: aMessageType"
	| input first message |
	input := self in.
	[ [ input peek = $> ] on: ConnectionTimedOut do: [ false ] ] whileTrue: [
			first := input next.
			message := (self handlers at: first ifAbsent: [ self error: 'Unknown reply type' ]) value. 
			self postPushNotification: message ].	


]

{ #category : #reading }
TRedisReader >> readArray [
	| length array |
	length := self in nextLine.
	length = '?' ifTrue: [ ^self readStreamedArray ] ifFalse: [ length := length asInteger ].
	length = -1 ifTrue: [ ^ nil ].
	array := Array new: length streamContents: [ :elements |
		length timesRepeat: [ elements nextPut: self readReply ] ].
	^ array
]

{ #category : #reading }
TRedisReader >> readAttribute [
	| attr |
	attr := self readDictionary.
	self reportAttribute: attr.
	^self readReply
]

{ #category : #reading }
TRedisReader >> readBlobError [
	^self error: self readBulkString
]

{ #category : #reading }
TRedisReader >> readBoolean [
	^self readString = 't'
]

{ #category : #reading }
TRedisReader >> readBulkString [
	| byteCount bytes |
	byteCount := self in nextLine.
	byteCount = '?' ifTrue: [ ^self readStreamedString ] ifFalse: [ byteCount := byteCount asInteger ].
	byteCount = -1 ifTrue: [ ^ nil ].
	bytes := self in wrappedStream next: byteCount.
	self in nextLine.
	^ self in encoder decodeBytes: bytes
]

{ #category : #reading }
TRedisReader >> readDictionary [
	| length array |
	length := self in nextLine.
	length = '?' ifTrue: [ self readStreamedDictionary ] ifFalse: [ length := length asInteger ].
	length = -1 ifTrue: [ ^ nil ].
	array := Array streamContents: [ :elements |
		length timesRepeat: [ | key value | 
			key := self readReply.
			value := self readReply.
			elements nextPut: (key -> value) ] ].
	^ array asDictionary
]

{ #category : #reading }
TRedisReader >> readError [
	^self error: self readString
]

{ #category : #reading }
TRedisReader >> readFloat [
	| value |
	value := self in nextLine.
	value = 'inf' ifTrue: [ ^Float infinity ].
	value = '-inf' ifTrue: [ ^Float negativeInfinity ].
	^value asNumber.
]

{ #category : #reading }
TRedisReader >> readInteger [ 
	^self readString asInteger
]

{ #category : #reading }
TRedisReader >> readNil [
	self readString.
	^nil
]

{ #category : #reading }
TRedisReader >> readNumber [
	^self readString asNumber
]

{ #category : #reading }
TRedisReader >> readPushNotification [
	^self readArray
]

{ #category : #reading }
TRedisReader >> readReply [
	"Only call this if you are after a message that is not a push notification"
	"Push notifications are retrieved with waitReply: aMessageType"
	
	| first |
	self readAllPushNotifications.
	first := self in next.
	^(self handlers at: first ifAbsent: [ self error: 'Unknown reply type' ]) value
	
]

{ #category : #reading }
TRedisReader >> readSet [
	^ self readArray asSet
]

{ #category : #reading }
TRedisReader >> readStreamedArray [
	^Array streamContents: [ :s |
		[self in peek = $.] whileFalse: [ s nextPut: self readReply ].
		self in nextLine ]
]

{ #category : #reading }
TRedisReader >> readStreamedDictionary [
	^Array streamContents: [ :s || key value |
		[ self in peek = $. ] whileFalse: [ 
		key := self readReply.
		value := self readReply.
		s nextPut: (key -> value).
		 ].
		self in nextLine.
		 ] asDictionary
]

{ #category : #reading }
TRedisReader >> readStreamedString [
	
	^String streamContents: [ :s || length |
		self in next = $; ifFalse: [ self error: 'Error reading streamed string.  Expected semicolon.' ].
		[(length := self in nextLine asInteger) > 0] whileTrue: [
			(self in next: length into: s).
			self in nextLine
		]
	]
]

{ #category : #reading }
TRedisReader >> readString [ 
	^self in nextLine
]

{ #category : #reading }
TRedisReader >> readVerbatimString [
	| byteCount prefix suffix string |
	byteCount := self in nextLine asInteger.
	string := self in encoder decodeBytes: (self in wrappedStream next: byteCount).
	self in nextLine.
	prefix := string first: 3.
	suffix := string last: (string size - 4).

	"Valid prefixes are txt and mkd - we will assume just text for now"
	"but mkd should perhaps make use of Pillar"
	^ prefix, String cr, suffix
]

{ #category : #reading }
TRedisReader >> waitReply: aMessageType [
	"Only call this if you are after a message that is not a push notification"
	"Push notifications are retrieved with waitReply: aMessageType"
	| index |
	[	self readAllPushNotifications.	
		index := self queue detectIndex: [ :ea | ea first = aMessageType] ifNone: [ 0 ]. 
			index > 0 
				ifTrue: [ ^self queue removeAt: index ]
				ifFalse: [ Processor yield ] ] repeat

]
