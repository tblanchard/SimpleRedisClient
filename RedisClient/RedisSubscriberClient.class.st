"
I am a Redis client that can be used to receive pub/sub messages from a redis instance.

The only commands that are allowed in the context of a subscribed client are SUBSCRIBE, PSUBSCRIBE, UNSUBSCRIBE, PUNSUBSCRIBE, PING and QUIT.

See https://redis.io/topics/pubsub

I deliver subscriptions using my local announcer to listeners of type RedisAnnouncement.

RedisAnnouncements are created automatically when the announcer message when:do:, 
when:do:for: and when:send:to: are sent to the Redis client rather than its announcer.
"
Class {
	#name : #RedisSubscriberClient,
	#superclass : #RedisAbstractClient,
	#traits : 'TRedisSubscriber',
	#classTraits : 'TRedisSubscriber classTrait',
	#category : #RedisClient
}

{ #category : #'initialize-release' }
RedisSubscriberClient >> open [ 
	super open.
	self refreshSubscriptions
]

{ #category : #running }
RedisSubscriberClient >> refreshSubscriptions [
	self announcer ifNotNil: [ :ann |
		self subscribe: self subscribedChannels ]
]
