Trait {
	#name : #TRedis,
	#category : #'Redis-Traits'
}

{ #category : #running }
TRedis >> execute: commandArgs [
	^ self explicitRequirement
]
