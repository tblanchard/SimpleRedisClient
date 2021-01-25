"
I translate the Pharo List message protocol into Redis commands.  

I am implemented as a Trait to provide flexibility in implementing immediate or batched 
command processing. Any object adopting this protocol will be expected to implement 

#execute: commandArgs

where commandArgs is an array of values making up a Redis command.  As a Redis server itself
provides for addressing data structures using string keys, the accessor #name must also be required
as the name of the hash is typically the first argument to any command involving a hash.

"
Trait {
	#name : #TRedisList,
	#traits : 'TRedisEnumeration + TRedisExpiration',
	#classTraits : 'TRedisEnumeration classTrait + TRedisExpiration classTrait',
	#category : #RedisClient
}

{ #category : #'adding/removing' }
TRedisList >> add: newObject [

	^self addLast: newObject
]

{ #category : #'adding/removing' }
TRedisList >> add: newObject after: oldObject [ 
	"Add the argument, newObject, as an element of the receiver. Put it in 
	the sequence just succeeding oldObject. Answer newObject."
	^self execute: { #LINSERT. self name. #AFTER. oldObject. newObject }
]

{ #category : #'adding/removing' }
TRedisList >> add: newObject before: oldObject [ 
	"Add the argument, newObject, as an element of the receiver. Put it in 
	the sequence just succeeding oldObject. Answer newObject."
	^self execute: { #LINSERT. self name. #BEFORE. oldObject. newObject }
]

{ #category : #'adding/removing' }
TRedisList >> addAll: aCollection [ 
	"Add each element of aCollection at my end. Answer	aCollection."

	^ self addAllLast: aCollection
]

{ #category : #'adding/removing' }
TRedisList >> addAllFirst: anOrderedCollection [ 
	"Add each element of anOrderedCollection at the beginning of the 
	receiver. Answer anOrderedCollection."

	^self execute: ({ #LPUSH. self name. }, anOrderedCollection)
]

{ #category : #'adding/removing' }
TRedisList >> addAllLast: newObject [ 
	"Add newObject to the end of the receiver. Answer newObject."

	^self addLast: newObject
	
]

{ #category : #'adding/removing' }
TRedisList >> addFirst: newObject [ 
	"Add newObject to the beginning of the receiver. Answer newObject."

	^self execute: ({ #LPUSH. self name. }, (newObject isString 
		ifTrue: [ { newObject } ] 
		ifFalse: [ newObject ]))
	
]

{ #category : #'adding/removing' }
TRedisList >> addFirstIfExists: newObject [ 
	"Add newObject to the beginning of the receiver. Answer newObject."

	^self execute: ({ #LPUSHX. self name. }, (newObject isString 
		ifTrue: [ { newObject } ] 
		ifFalse: [ newObject ]))
	
]

{ #category : #'adding/removing' }
TRedisList >> addLast: newObject [ 
	"Add newObject to the beginning of the receiver. Answer newObject."

	^self execute: ({ #RPUSH. self name. }, (newObject isString 
		ifTrue: [ { newObject } ] 
		ifFalse: [ newObject ]))
	
]

{ #category : #'adding/removing' }
TRedisList >> addLastIfExists: newObject [ 
	"Add newObject to the beginning of the receiver. Answer newObject."

	^self execute: ({ #RPUSHX. self name. }, (newObject isString 
		ifTrue: [ { newObject } ] 
		ifFalse: [ newObject ]))
	
]

{ #category : #'adding/removing' }
TRedisList >> at: anInteger [
	"Answer my element at index anInteger. at: is used by a knowledgeable
	client to access an existing element"

	^(self execute: { #LINDEX. self name. anInteger-1 }) 
]

{ #category : #'adding/removing' }
TRedisList >> at: anInteger put: aValue [
	"Answer my element at index anInteger. at: is used by a knowledgeable
	client to access an existing element"

	^(self execute: { #LSET. self name. anInteger-1. aValue }) 
]

{ #category : #'adding/removing' }
TRedisList >> first [ 
	^self execute: { #LRANGE. self name. 0. 0 }
]

{ #category : #'adding/removing' }
TRedisList >> first: n [ 
	^self execute: { #LRANGE. self name. 0. n-1 }
]

{ #category : #'adding/removing' }
TRedisList >> last [ 
	^self execute: { #LRANGE. self name. -1. -1 }
]

{ #category : #'adding/removing' }
TRedisList >> last: n [ 
	^self execute: { #LRANGE. self name. n negated. -1 }
]

{ #category : #accessing }
TRedisList >> name [
	^ self explicitRequirement
]

{ #category : #'adding/removing' }
TRedisList >> removeAllOccurrencesOf: aValue [
	^self execute: { #LREM. self name. 0. aValue }
]

{ #category : #'adding/removing' }
TRedisList >> removeFirst [
	^self execute: { #LPOP. self name }
]

{ #category : #'adding/removing' }
TRedisList >> removeFirst: n occurrencesOf: aValue [
	^self execute: { #LREM. self name. n. aValue }
]

{ #category : #'adding/removing' }
TRedisList >> removeLast [
	^self execute: { #RPOP. self name }
]

{ #category : #'adding/removing' }
TRedisList >> removeLast: n occurrencesOf: aValue [
	^self execute: { #LREM. self name. n negated. aValue }
]

{ #category : #'adding/removing' }
TRedisList >> removeLastAddFirstTo: aListOrKey [
	| key |
	key := aListOrKey isString 
		ifTrue: [ aListOrKey ]
		ifFalse: [ (aListOrKey respondsTo: #name) 
			ifTrue: [ aListOrKey name ]
			ifFalse: [ self error: 'Expected string or RedisList here' ] ].
	^self execute: { #RPOPLPUSH. self name. key }
]

{ #category : #'adding/removing' }
TRedisList >> rotate [
	^self execute: { #RPOPLPUSH. self name. self name. }
]

{ #category : #accessing }
TRedisList >> size [
	"Answer my element at index anInteger. at: is used by a knowledgeable
	client to access an existing element"

	^(self execute: { #LLEN. self name }) 
]

{ #category : #'adding/removing' }
TRedisList >> trimToRangeFrom: start to: end [ 
	^self execute: { #LTRIM. self name. start-1. end-1. }
]

{ #category : #'adding/removing' }
TRedisList >> values [ 
	^self execute: { #LRANGE. self name. 0. -1 }
]
