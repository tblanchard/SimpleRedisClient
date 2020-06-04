Trait {
	#name : #TRedisSortedSet,
	#traits : 'TRedis + TRedisEnumeration + TRedisExpiration',
	#classTraits : 'TRedis classTrait + TRedisEnumeration classTrait + TRedisExpiration classTrait',
	#category : #SimpleRedisClient
}

{ #category : #'adding/removing' }
TRedisSortedSet >> add: aValue score: aScore [
	^self execute: { #ZADD. self name. aScore. aValue }
]

{ #category : #accessing }
TRedisSortedSet >> countFrom: min to: max [ 
	^self execute: { #ZCOUNT. self name. min. max }
]

{ #category : #accessing }
TRedisSortedSet >> decrementAt: aMember by: aValue [
	^self execute: { #ZINCRBY. self name. aValue negated. aMember } 
]

{ #category : #accessing }
TRedisSortedSet >> incrementAt: aMember by: aValue [
	^self execute: { #ZINCRBY. self name. aValue. aMember } 
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
