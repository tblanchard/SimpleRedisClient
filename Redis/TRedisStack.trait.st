Trait {
	#name : #TRedisStack,
	#traits : 'TRedisExpiration',
	#classTraits : 'TRedisExpiration classTrait',
	#category : #'Redis-Traits'
}

{ #category : #'adding/removing' }
TRedisStack >> pop [
	^self execute: { #LPOP. self name }
]

{ #category : #'adding/removing' }
TRedisStack >> push: newObject [ 
	"Add newObject to the beginning of the receiver. Answer newObject."

	^self execute: ({ #LPUSH. self name. }, (newObject isString 
		ifTrue: [ { newObject } ] 
		ifFalse: [ newObject ]))
]

{ #category : #accessing }
TRedisStack >> size [
	"Answer my element at index anInteger. at: is used by a knowledgeable
	client to access an existing element"

	^(self execute: { #LLEN. self name }) 
]

{ #category : #accessing }
TRedisStack >> top [ 
	^self execute: { #LRANGE. self name. 0. 0 }
]
