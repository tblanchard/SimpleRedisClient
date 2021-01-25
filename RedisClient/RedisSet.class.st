"
I am a handle to a redis hash or dictionary.

My protocol is intended to make me a drop in replacement for Set.

Redis Sets are an unordered collection of Strings. It is possible to add, remove, and test for existence of members in O(1) (constant time regardless of the number of elements contained inside the Set).
Redis Sets have the desirable property of not allowing repeated members. Adding the same element multiple times will result in a set having a single copy of this element. Practically speaking this means that adding a member does not require a check if exists then add operation.
A very interesting thing about Redis Sets is that they support a number of server side commands to compute sets starting from existing sets, so you can do unions, intersections, differences of sets in very short time.

The max number of members in a set is 232 - 1 (4294967295, more than 4 billion of members per set).
"
Class {
	#name : #RedisSet,
	#superclass : #RedisObject,
	#traits : 'TRedisSet',
	#classTraits : 'TRedisSet classTrait',
	#category : #RedisClient
}

{ #category : #accessing }
RedisSet >> contents [
	^ self values
]

{ #category : #accessing }
RedisSet >> name [
	^ name
]
