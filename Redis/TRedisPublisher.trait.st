Trait {
	#name : #TRedisPublisher,
	#traits : 'TRedis',
	#classTraits : 'TRedis classTrait',
	#category : #'Redis-Traits'
}

{ #category : #publishing }
TRedisPublisher >> publish: aChannel message: aMessage [
	self execute: { #PUBLISH. aChannel. aMessage }
]
