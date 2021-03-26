Trait {
	#name : #TRedisQueue,
	#traits : 'TRedisExpiration',
	#classTraits : 'TRedisExpiration classTrait',
	#category : #'Redis-Traits'
}

{ #category : #'adding/removing' }
TRedisQueue >> peek [ 
	^self execute: { #LRANGE. self name. -1. -1 }
]

{ #category : #'adding/removing' }
TRedisQueue >> pop [
	^self execute: { #RPOP. self name }
]

{ #category : #'adding/removing' }
TRedisQueue >> push: newObject [
	"Add newObject to the beginning of the receiver. Answer newObject."

	^self execute: ({ #LPUSH. self name. }, (newObject isString 
		ifTrue: [ { newObject } ] 
		ifFalse: [ newObject ]))
]

{ #category : #accessing }
TRedisQueue >> size [
	"Answer my element at index anInteger. at: is used by a knowledgeable
	client to access an existing element"

	^(self execute: { #LLEN. self name }) 
]
