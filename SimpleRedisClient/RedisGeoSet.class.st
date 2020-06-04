Class {
	#name : #RedisGeoSet,
	#superclass : #RedisObject,
	#traits : 'TRedisGEO',
	#classTraits : 'TRedisGEO classTrait',
	#instVars : [
		'units'
	],
	#category : #SimpleRedisClient
}

{ #category : #accessing }
RedisGeoSet >> contents [
	^ self values
]

{ #category : #running }
RedisGeoSet >> execute: commandArgs [
	^ client execute: commandArgs
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
