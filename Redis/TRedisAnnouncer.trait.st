Trait {
	#name : #TRedisAnnouncer,
	#category : #'Redis-Traits'
}

{ #category : #accessing }
TRedisAnnouncer >> announcer [
	^ self explicitRequirement
]
