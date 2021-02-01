Trait {
	#name : #TRedisAnnouncer,
	#category : #RedisClient
}

{ #category : #accessing }
TRedisAnnouncer >> announcer [
	^ self explicitRequirement
]
