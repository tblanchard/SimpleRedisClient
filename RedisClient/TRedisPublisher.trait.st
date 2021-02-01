Trait {
	#name : #TRedisPublisher,
	#traits : 'TRedis',
	#classTraits : 'TRedis classTrait',
	#category : #RedisClient
}

{ #category : #publishing }
TRedisPublisher >> publish: aChannel message: aMessage [
	self execute: { #PUBLISH. aChannel. aMessage }
]
