Class {
	#name : #RedisList,
	#superclass : #RedisObject,
	#traits : 'TRedisList',
	#classTraits : 'TRedisList classTrait',
	#category : #SimpleRedisClient
}

{ #category : #accessing }
RedisList >> contents [
	^ self values
]

{ #category : #running }
RedisList >> execute: commandArgs [
	^client execute: commandArgs
]

{ #category : #accessing }
RedisList >> name [
	^ name
]
