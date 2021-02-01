"
I am a handle to a redis sorted set.  There is no equivalent collection in Pharo I know of.

Redis Sorted Sets are, similarly to Redis Sets, non repeating collections of Strings. The difference is that every member of a Sorted Set is associated with score, that is used in order to take the sorted set ordered, from the smallest to the greatest score. While members are unique, scores may be repeated.
With sorted sets you can add, remove, or update elements in a very fast way (in a time proportional to the logarithm of the number of elements). Since elements are taken in order and not ordered afterwards, you can also get ranges by score or by rank (position) in a very fast way. Accessing the middle of a sorted set is also very fast, so you can use Sorted Sets as a smart list of non repeating elements where you can quickly access everything you need: elements in order, fast existence test, fast access to elements in the middle!

In short with sorted sets you can do a lot of tasks with great performance that are really hard to model in other kind of databases.
"
Class {
	#name : #RedisSortedSet,
	#superclass : #RedisObject,
	#traits : 'TRedisSortedSet',
	#classTraits : 'TRedisSortedSet classTrait',
	#category : #RedisClient
}

{ #category : #accessing }
RedisSortedSet >> contents [
	^ self values
]

{ #category : #accessing }
RedisSortedSet >> name [
	^ name
]
