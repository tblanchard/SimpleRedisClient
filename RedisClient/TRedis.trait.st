Trait {
	#name : #TRedis,
	#category : #RedisClient
}

{ #category : #running }
TRedis >> execute: commandArgs [
	^ self explicitRequirement
]
