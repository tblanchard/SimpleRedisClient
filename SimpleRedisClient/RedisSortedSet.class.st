Class {
	#name : #RedisSortedSet,
	#superclass : #RedisObject,
	#traits : 'TRedisSortedSet',
	#classTraits : 'TRedisSortedSet classTrait',
	#category : #SimpleRedisClient
}

{ #category : #running }
RedisSortedSet >> execute: commandArgs [
	^ client execute: commandArgs
]
