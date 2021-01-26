Class {
	#name : #RedisPubSubClient,
	#superclass : #RedisAbstractClient,
	#traits : 'TRedisPubSub',
	#classTraits : 'TRedisPubSub classTrait',
	#category : #RedisClient
}

{ #category : #'initialize-release' }
RedisPubSubClient >> open [ 
	super open.
	self refreshSubscriptions
]

{ #category : #reading }
RedisPubSubClient >> postPushNotification: aMessage [ 
	^ self announce: aMessage
]

{ #category : #running }
RedisPubSubClient >> refreshSubscriptions [
	self announcer ifNotNil: [ :ann |
		self subscribe: (ann subscriptions collect: [ :sub | sub announcementClass name ]) ]
]
