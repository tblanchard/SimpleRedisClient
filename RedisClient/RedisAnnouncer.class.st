Class {
	#name : #RedisAnnouncer,
	#superclass : #Announcer,
	#instVars : [
		'client'
	],
	#category : #RedisClient
}

{ #category : #'instance creation' }
RedisAnnouncer class >> on: aRedisPubSubClient [
	^(self new) 
		client: aRedisPubSubClient;
		yourself 
]

{ #category : #accessing }
RedisAnnouncer >> client [
	^ client
]

{ #category : #accessing }
RedisAnnouncer >> client: anObject [
	client := anObject
]
