"
I translate the Pharo Set message protocol into Redis commands.  

I am implemented as a Trait to provide flexibility in implementing immediate or batched 
command processing. Any object adopting this protocol will be expected to implement 

#execute: commandArgs

where commandArgs is an array of values making up a Redis command.  As a Redis server itself
provides for addressing data structures using string keys, the accessor #name must also be required
as the name of the hash is typically the first argument to any command involving a hash.

"
Trait {
	#name : #TRedisSet,
	#traits : 'TRedis + TRedisEnumeration + TRedisExpiration',
	#classTraits : 'TRedis classTrait + TRedisEnumeration classTrait + TRedisExpiration classTrait',
	#category : #SimpleRedisClient
}

{ #category : #'adding/removing' }
TRedisSet >> add: aValue [
	^self execute: { #SADD. self name. aValue } 
]

{ #category : #'adding/removing' }
TRedisSet >> addAll: aValue [
	^self execute: ({ #SADD. self name }, aValue asArray) 
]

{ #category : #'adding/removing' }
TRedisSet >> any: n [
	^self execute: { #SRANDMEMBER. self name. n }
]

{ #category : #'adding/removing' }
TRedisSet >> anyOne [
	^self execute: { #SRANDMEMBER. self name }
]

{ #category : #enumerating }
TRedisSet >> difference: aKeyOrSet [
	| key |
	key := aKeyOrSet isString 
		ifTrue: [ { aKeyOrSet } ]
		ifFalse: [ (aKeyOrSet respondsTo: #name) 
			ifTrue: [ { aKeyOrSet name }] 
			ifFalse: [ (aKeyOrSet isCollection and: [aKeyOrSet first isString])
				ifTrue: [ aKeyOrSet ]
				ifFalse: [ self error: 'Expected RedisSet or key(s) here' ] ] ].
		^self execute: ({ #SDIFF. self name }, key)
]

{ #category : #enumerating }
TRedisSet >> difference: aKeyOrSet into: aKey [
	| key destKey |
	key := aKeyOrSet isString 
		ifTrue: [ { aKeyOrSet } ]
		ifFalse: [ (aKeyOrSet respondsTo: #name) 
			ifTrue: [ { aKeyOrSet name }] 
			ifFalse: [ (aKeyOrSet isCollection and: [aKeyOrSet first isString])
				ifTrue: [ aKeyOrSet ]
				ifFalse: [ self error: 'Expected RedisSet or key(s) here' ] ] ].
	destKey := aKey isString ifTrue: [ aKey ] ifFalse: [ aKey name ].
		^self execute: ({ #SDIFFSTORE. destKey. self name }, key)
]

{ #category : #'adding/removing' }
TRedisSet >> includes: aValue [
	^self execute: { #SISMEMBER. self name. aValue }
]

{ #category : #enumerating }
TRedisSet >> intersection: aKeyOrSet [
	| key |
	key := aKeyOrSet isString 
		ifTrue: [ { aKeyOrSet } ]
		ifFalse: [ (aKeyOrSet respondsTo: #name) 
			ifTrue: [ { aKeyOrSet name }] 
			ifFalse: [ (aKeyOrSet isCollection and: [aKeyOrSet first isString])
				ifTrue: [ aKeyOrSet ]
				ifFalse: [ self error: 'Expected RedisSet or key(s) here' ] ] ].
		^self execute: ({ #SINTER. self name }, key)
]

{ #category : #enumerating }
TRedisSet >> intersection: aKeyOrSet into: aKey [
	| key destKey |
	key := aKeyOrSet isString 
		ifTrue: [ { aKeyOrSet } ]
		ifFalse: [ (aKeyOrSet respondsTo: #name) 
			ifTrue: [ { aKeyOrSet name }] 
			ifFalse: [ (aKeyOrSet isCollection and: [aKeyOrSet first isString])
				ifTrue: [ aKeyOrSet ]
				ifFalse: [ self error: 'Expected RedisSet or key(s) here' ] ] ].
	destKey := aKey isString ifTrue: [ aKey ] ifFalse: [ aKey name ].
		^self execute: ({ #SINTERSTORE. destKey. self name }, key)
]

{ #category : #'adding/removing' }
TRedisSet >> move: aValue toSetNamed: aKey [ 
	^self execute: { #SMOVE. self name. aKey. aValue }
]

{ #category : #accessing }
TRedisSet >> name [
	^ self explicitRequirement
]

{ #category : #'adding/removing' }
TRedisSet >> remove: oldObject [ 
	"Remove oldObject from the receiver's elements. Answer oldObject 
	unless no element is equal to oldObject, in which case, raise an error.
	ArrayedCollections cannot respond to this message."

	^ self remove: oldObject ifAbsent: [self errorNotFound: oldObject]
]

{ #category : #'adding/removing' }
TRedisSet >> remove: oldObject ifAbsent: aBlock [
	^(self execute: { #SREM. self name. oldObject }) = 0 ifTrue: aBlock
]

{ #category : #'adding/removing' }
TRedisSet >> removeAll: oldObjectArray [
	^self execute: ({ #SREM. self name. }, oldObjectArray asArray)
]

{ #category : #'adding/removing' }
TRedisSet >> removeAny: n [
	^self execute: { #SPOP. self name. n }
]

{ #category : #'adding/removing' }
TRedisSet >> removeAnyOne [
	^self execute: { #SPOP. self name }
]

{ #category : #accessing }
TRedisSet >> size [ 
	^self execute: { #SCARD. self name }
]

{ #category : #enumerating }
TRedisSet >> union: aKeyOrSet [
	| key |
	key := aKeyOrSet isString 
		ifTrue: [ { aKeyOrSet } ]
		ifFalse: [ (aKeyOrSet respondsTo: #name) 
			ifTrue: [ { aKeyOrSet name }] 
			ifFalse: [ (aKeyOrSet isCollection and: [aKeyOrSet first isString])
				ifTrue: [ aKeyOrSet ]
				ifFalse: [ self error: 'Expected RedisSet or key(s) here' ] ] ].
		^self execute: ({ #SUNION. self name }, key)
]

{ #category : #enumerating }
TRedisSet >> union: aKeyOrSet into: aKey [
	| key destKey |
	key := aKeyOrSet isString 
		ifTrue: [ { aKeyOrSet } ]
		ifFalse: [ (aKeyOrSet respondsTo: #name) 
			ifTrue: [ { aKeyOrSet name }] 
			ifFalse: [ (aKeyOrSet isCollection and: [aKeyOrSet first isString])
				ifTrue: [ aKeyOrSet ]
				ifFalse: [ self error: 'Expected RedisSet or key(s) here' ] ] ].
	destKey := aKey isString ifTrue: [ aKey ] ifFalse: [ aKey name ].
		^self execute: ({ #SUNIONSTORE. destKey. self name }, key)
]

{ #category : #accessing }
TRedisSet >> values [
	^self execute: { #SMEMBERS. self name }
]
