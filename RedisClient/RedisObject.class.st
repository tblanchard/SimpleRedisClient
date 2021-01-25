"
I am an abstract redis data structure handle.

I have a connection to a server and a key.

Each redis datastructure type has a set of operations for manipulating it. 
These operations are defined as traits and adopted in subclasses.
"
Class {
	#name : #RedisObject,
	#superclass : #Object,
	#instVars : [
		'client',
		'name'
	],
	#category : #RedisClient
}

{ #category : #accessing }
RedisObject >> client [
	^ client
]

{ #category : #accessing }
RedisObject >> client: anObject [
	client := anObject
]

{ #category : #running }
RedisObject >> execute: commandArgs [
	^client execute: commandArgs
]

{ #category : #accessing }
RedisObject >> name [
	^ name
]

{ #category : #accessing }
RedisObject >> name: anObject [
	name := anObject
]
