Class {
	#name : #RedisObject,
	#superclass : #Object,
	#instVars : [
		'client',
		'name'
	],
	#category : #SimpleRedisClient
}

{ #category : #accessing }
RedisObject >> client [
	^ client
]

{ #category : #accessing }
RedisObject >> client: anObject [
	client := anObject
]

{ #category : #accessing }
RedisObject >> name [
	^ name
]

{ #category : #accessing }
RedisObject >> name: anObject [
	name := anObject
]
