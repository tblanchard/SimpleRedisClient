"
I am a handle to a redis hash or dictionary.

My protocol is intended to make me a drop in replacement for Dictionary.

Redis Hashes are maps between string fields and string values, so they are the perfect data type to represent objects (e.g. A User with a number of fields like name, surname, age, and so forth):

A hash with a few fields (where few means up to one hundred or so) is stored in a way that takes very little space, so you can store millions of objects in a small Redis instance.
While Hashes are used mainly to represent objects, they are capable of storing many elements, so you can use Hashes for many other tasks as well.
Every hash can store up to 232 - 1 field-value pairs (more than 4 billion).
"
Class {
	#name : #RedisDictionary,
	#superclass : #RedisObject,
	#traits : 'TRedisHash',
	#classTraits : 'TRedisHash classTrait',
	#category : #'Redis-Collections'
}

{ #category : #ambiguous }
RedisDictionary >> associationsDo: aBlock [ 
	self associations do: aBlock
]

{ #category : #accessing }
RedisDictionary >> client [
	^ client
]

{ #category : #accessing }
RedisDictionary >> client: anObject [
	client := anObject
]

{ #category : #accessing }
RedisDictionary >> contents [
	^ self associations
]

{ #category : #accessing }
RedisDictionary >> name [ 
	^name
]

{ #category : #accessing }
RedisDictionary >> name: anObject [
	name := anObject
]
