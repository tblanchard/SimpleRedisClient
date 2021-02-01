"
I represent a connection to a Redis server.
"
Class {
	#name : #RedisServerSpec,
	#superclass : #Object,
	#instVars : [
		'url'
	],
	#category : #RedisClient
}

{ #category : #'instance creation' }
RedisServerSpec class >> on: aUrl [
	^self new url: aUrl
]

{ #category : #converting }
RedisServerSpec >> asUrl [
	^self url
]

{ #category : #accessing }
RedisServerSpec >> db [ 
	^(url queryAt: 'db' ifAbsent: [ 0 ]) asInteger
]

{ #category : #accessing }
RedisServerSpec >> host [ 
	^self url host ifNil: [ 'localhost' ]
]

{ #category : #accessing }
RedisServerSpec >> password [ 
	^url password ifNil: [ url queryAt: 'password' ifAbsent: [  ] ]
]

{ #category : #accessing }
RedisServerSpec >> port [ 
	^(url port ifNil: [ 6379 ]) asInteger
]

{ #category : #accessing }
RedisServerSpec >> url [
	^url ifNil: [ url := 'redis:///' asUrl ]
]

{ #category : #accessing }
RedisServerSpec >> url: aUrl [
	url := aUrl asUrl
]

{ #category : #accessing }
RedisServerSpec >> username [ 
	^url username ifNil: [ url queryAt: 'username' ifAbsent: [  ] ]
]
