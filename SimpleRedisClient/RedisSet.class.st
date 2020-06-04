Class {
	#name : #RedisSet,
	#superclass : #RedisObject,
	#traits : 'TRedisSet',
	#classTraits : 'TRedisSet classTrait',
	#category : #SimpleRedisClient
}

{ #category : #accessing }
RedisSet >> contents [
	^ self values
]

{ #category : #running }
RedisSet >> execute: commandArgs [
	^client execute: commandArgs
]

{ #category : #accessing }
RedisSet >> name [
	^ name
]
