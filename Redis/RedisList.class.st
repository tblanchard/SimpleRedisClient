"
I am a handle to a redis hash or dictionary.

My protocol is intended to make me a drop in replacement for OrderedCollection.

Redis Lists are simply lists of strings, sorted by insertion order. It is possible to add elements to a Redis List pushing new elements on the head (on the left) or on the tail (on the right) of the list.

The max length of a list is 232 - 1 elements (4294967295, more than 4 billion of elements per list).
The main features of Redis Lists from the point of view of time complexity are the support for constant time insertion and deletion of elements near the head and tail, even with many millions of inserted items. Accessing elements is very fast near the extremes of the list but is slow if you try accessing the middle of a very big list, as it is an O(N) operation.
"
Class {
	#name : #RedisList,
	#superclass : #RedisObject,
	#traits : 'TRedisList',
	#classTraits : 'TRedisList classTrait',
	#category : #'Redis-Collections'
}

{ #category : #accessing }
RedisList >> contents [
	^ self values
]

{ #category : #accessing }
RedisList >> name [
	^ name
]
