"
I am a set of geographical positions ( longitude, latitude ) that allows queries of elements based on geographical proximity. My underlying implemtation is the same as a sorted set, but my interface works in terms of positions rather than raw scores.

Redis represents positions of geospatial element by using a variation of Geohash technique where latitude and longitude bits are interleaved in order to form an unique 52 bit integer. The encoding is also different compared to the standard because the initial min and max coordinates used during the encoding and decoding process are different. However, this command returns a standard Geohash string value.

A standard Geohash string has the following properties :-

It consists of 11 characters.
It is possible to use them in geohash.org.
Strings with a similar prefix are nearby, but the contrary is not true, it is possible that strings with different prefixes are nearby too.
They can be shortened removing characters from the right. It will lose precision but will still point to the same area.
An array of nil is returned when key does not exist and error is returned when key exist but value stored at the key is not of sorted set datatype which is populated using GEOADD command.
"
Class {
	#name : #RedisGeoSet,
	#superclass : #RedisObject,
	#traits : 'TRedisGEO',
	#classTraits : 'TRedisGEO classTrait',
	#instVars : [
		'units'
	],
	#category : #'Redis-Collections'
}

{ #category : #accessing }
RedisGeoSet >> contents [
	^ self values
]

{ #category : #accessing }
RedisGeoSet >> name [
	^ name
]

{ #category : #accessing }
RedisGeoSet >> units [ 
	^units ifNil: [ units := #m ]
]

{ #category : #accessing }
RedisGeoSet >> units: aSymbol [
	(#(m km ft mi) anySatisfy: [ :ea | ea = aSymbol ]) 
		ifTrue: [ units := aSymbol ] 
		ifFalse: [ self error: 'Invalid unit specifier - must be one of m km ft mi' ]
]
