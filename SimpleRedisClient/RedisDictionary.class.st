Class {
	#name : #RedisDictionary,
	#superclass : #RedisObject,
	#traits : 'TRedisHash',
	#classTraits : 'TRedisHash classTrait',
	#category : #SimpleRedisClient
}

{ #category : #ambiguous }
RedisDictionary >> associationsDo: aBlock [ 
	self associations do: aBlock
]

{ #category : #accessing }
RedisDictionary >> client [
	^ client
]

{ #category : #accessing }
RedisDictionary >> client: anObject [
	client := anObject
]

{ #category : #accessing }
RedisDictionary >> contents [
	^ self associations
]

{ #category : #running }
RedisDictionary >> execute: commandArgs [
	^ client execute: commandArgs
]

{ #category : #accessing }
RedisDictionary >> name [ 
	^name
]

{ #category : #accessing }
RedisDictionary >> name: anObject [
	name := anObject
]
