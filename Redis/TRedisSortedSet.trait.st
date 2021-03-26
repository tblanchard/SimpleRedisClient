Trait {
	#name : #TRedisSortedSet,
	#category : #'Redis-Traits'
}

{ #category : #'adding/removing' }
TRedisSortedSet >> add: aValue score: aScore [
	^self execute: { #ZADD. self name. aScore. aValue }
]

{ #category : #accessing }
TRedisSortedSet >> associations [
	^(self execute: { #ZRANGE. self name. 0. -1. #WITHSCORES }) collect: [ :ea | ea first -> ea second ]
]

{ #category : #enumerating }
TRedisSortedSet >> associationsDo: aBlock [
	"Evaluate aBlock for each of the receiver's elements (key/value 
	associations).  If any non-association is within, the error is not caught now,
	but later, when a key or value message is sent to it."

	self associations do: aBlock
]

{ #category : #accessing }
TRedisSortedSet >> countFrom:start [ 
	^self execute: { #ZCOUNT. self name. start. '+inf' }
]

{ #category : #accessing }
TRedisSortedSet >> countFrom:start to: finish [ 
	^self execute: { #ZCOUNT. self name.  start. finish }
]

{ #category : #accessing }
TRedisSortedSet >> countFrom:start toLessThan: finish [ 
	^self execute: { #ZCOUNT. self name. start. ('(',finish asString) }
]

{ #category : #accessing }
TRedisSortedSet >> countFromGreaterThan:start [ 
	^self execute: { #ZCOUNT. self name. ('(',start asString). '+inf' }
]

{ #category : #accessing }
TRedisSortedSet >> countFromGreaterThan:start to: finish [ 
	^self execute: { #ZCOUNT. self name. ('(', start asString). finish }
]

{ #category : #accessing }
TRedisSortedSet >> countFromGreaterThan:start toLessThan: finish [ 
	^self execute: { #ZCOUNT. self name. ('(', start asString). ('(',finish asString) }
]

{ #category : #accessing }
TRedisSortedSet >> countScoresFrom:start [ 
	^self execute: { #ZCOUNT. self name. start. '+inf' }
]

{ #category : #accessing }
TRedisSortedSet >> countScoresFrom:start to: finish [ 
	^self execute: { #ZCOUNT. self name.  start. finish }
]

{ #category : #accessing }
TRedisSortedSet >> countScoresFrom:start toLessThan: finish [ 
	^self execute: { #ZCOUNT. self name. start. ('(',finish asString) }
]

{ #category : #accessing }
TRedisSortedSet >> countScoresFromGreaterThan:start [ 
	^self execute: { #ZCOUNT. self name. ('(',start asString). '+inf' }
]

{ #category : #accessing }
TRedisSortedSet >> countScoresFromGreaterThan:start to: finish [ 
	^self execute: { #ZCOUNT. self name. ('(', start asString). finish }
]

{ #category : #accessing }
TRedisSortedSet >> countScoresFromGreaterThan:start toLessThan: finish [ 
	^self execute: { #ZCOUNT. self name. ('(', start asString). ('(',finish asString) }
]

{ #category : #accessing }
TRedisSortedSet >> countScoresTo:end [
	^self execute: { #ZCOUNT. self name. '-inf'. end. }
]

{ #category : #accessing }
TRedisSortedSet >> countScoresToLessThan:end [
	^self execute: { #ZCOUNT. self name. '-inf'. ('(',end asString). }
]

{ #category : #accessing }
TRedisSortedSet >> countTo:end [
	^self execute: { #ZCOUNT. self name. '-inf'. end. }
]

{ #category : #accessing }
TRedisSortedSet >> countToLessThan:end [
	^self execute: { #ZCOUNT. self name. '-inf'. ('(',end asString). }
]

{ #category : #accessing }
TRedisSortedSet >> countValuesFrom:start [ 
	^self execute: { #ZLEXCOUNT. self name. start. '+' }
]

{ #category : #accessing }
TRedisSortedSet >> countValuesFrom:start to: finish [ 
	^self execute: { #ZLEXCOUNT. self name.  start. finish }
]

{ #category : #accessing }
TRedisSortedSet >> countValuesFrom:start toLessThan: finish [ 
	^self execute: { #ZLEXCOUNT. self name. start. ('[',finish asString) }
]

{ #category : #accessing }
TRedisSortedSet >> countValuesFromGreaterThan:start [ 
	^self execute: { #ZLEXCOUNT. self name. ('[',start asString). '+' }
]

{ #category : #accessing }
TRedisSortedSet >> countValuesFromGreaterThan:start to: finish [ 
	^self execute: { #ZLEXCOUNT. self name. ('[', start asString). finish }
]

{ #category : #accessing }
TRedisSortedSet >> countValuesFromGreaterThan:start toLessThan: finish [ 
	^self execute: { #ZLEXCOUNT. self name. ('[', start asString). ('[',finish asString) }
]

{ #category : #accessing }
TRedisSortedSet >> countValuesTo:end [
	^self execute: { #ZLEXCOUNT. self name. '-'. end. }
]

{ #category : #accessing }
TRedisSortedSet >> countValuesToLessThan:end [
	^self execute: { #ZLEXCOUNT. self name. '-'. ('[',end asString). }
]

{ #category : #accessing }
TRedisSortedSet >> decrement: aMember by: aValue [
	^self execute: { #ZINCRBY. self name. aValue negated. aMember } 
]

{ #category : #accessing }
TRedisSortedSet >> decrementAt: aMember by: aValue [
	^self execute: { #ZINCRBY. self name. aValue negated. aMember } 
]

{ #category : #accessing }
TRedisSortedSet >> increment: aMember by: aValue [
	^self execute: { #ZINCRBY. self name. aValue. aMember } 
]

{ #category : #accessing }
TRedisSortedSet >> incrementAt: aMember by: aValue [
	^self execute: { #ZINCRBY. self name. aValue. aMember } 
]

{ #category : #enumerating }
TRedisSortedSet >> keysAndValuesDo: aBlock [
	^self associationsDo:[:assoc|
		aBlock value: assoc key value: assoc value].
]

{ #category : #accessing }
TRedisSortedSet >> rankAt: aValue [
	^self execute: { #ZRANK. self name. aValue } 
]

{ #category : #'adding/removing' }
TRedisSortedSet >> remove: oldObject [ 
	"Remove oldObject from the receiver's elements. Answer oldObject 
	unless no element is equal to oldObject, in which case, raise an error.
	ArrayedCollections cannot respond to this message."

	^ self remove: oldObject ifAbsent: [self errorNotFound: oldObject]
]

{ #category : #'adding/removing' }
TRedisSortedSet >> remove: oldObject ifAbsent: aBlock [
	^(self execute: { #ZREM. self name. oldObject }) = 0 ifTrue: aBlock
]

{ #category : #'adding/removing' }
TRedisSortedSet >> removeAll: oldObjects [
	"Remove oldObject from the receiver's elements. Answer oldObject 
	unless no element is equal to oldObject, in which case, raise an error.
	ArrayedCollections cannot respond to this message."

	^self execute: ({ #ZREM. self name }, oldObjects)
]

{ #category : #'adding/removing' }
TRedisSortedSet >> removeFirst [
	^self execute: { #ZPOPMAX. self name. }
]

{ #category : #'adding/removing' }
TRedisSortedSet >> removeFirst: count [
	^self execute: { #ZPOPMAX. self name. count}
]

{ #category : #'adding/removing' }
TRedisSortedSet >> removeLast [
	^self execute: { #ZPOPMIN. self name. }
]

{ #category : #'adding/removing' }
TRedisSortedSet >> removeLast: count [
	^self execute: { #ZPOPMIN. self name. count}
]

{ #category : #accessing }
TRedisSortedSet >> reverseRankAt: aValue [
	^self execute: { #ZREVRANK. self name. aValue } 
]

{ #category : #accessing }
TRedisSortedSet >> scoreAt: aKey [
	^self execute: { #ZSCORE. self name. aKey }
]

{ #category : #accessing }
TRedisSortedSet >> size [ 
	^self execute: { #ZCARD. self name }
]

{ #category : #accessing }
TRedisSortedSet >> values [ 
	^self execute: { #ZRANGE. self name. 0. -1 }
]

{ #category : #accessing }
TRedisSortedSet >> valuesAndScores [
	^self execute: { #ZRANGE. self name. 0. -1. #WITHSCORES }
]

{ #category : #enumerating }
TRedisSortedSet >> valuesAndScoresCollect: aBlock [ 
	self valuesAndScores pairsCollect: aBlock
]

{ #category : #enumerating }
TRedisSortedSet >> valuesAndScoresDo: aBlock [ 
	self valuesAndScores pairsDo: aBlock
]
