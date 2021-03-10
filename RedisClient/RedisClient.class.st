"
I am a basic Redis synchronous client.

I support all of the key operations for get/set/expire.  I can publish messages.

I cannot be used to subscribe to published messages.  To subscribe to messages, use the RedisSubscriberClient.  Once a Redis client begins to listing to published messages, it cannot be used to send synchronous messages apart from ping and info.


"
Class {
	#name : #RedisClient,
	#superclass : #RedisAbstractClient,
	#traits : 'TRedisKeys',
	#classTraits : 'TRedisKeys classTrait',
	#category : #'RedisClient-Client'
}
