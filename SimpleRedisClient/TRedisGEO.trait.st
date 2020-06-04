Trait {
	#name : #TRedisGEO,
	#traits : 'TRedis + TRedisEnumeration + TRedisExpiration',
	#classTraits : 'TRedis classTrait + TRedisEnumeration classTrait + TRedisExpiration classTrait',
	#category : #SimpleRedisClient
}

{ #category : #'adding/removing' }
TRedisGEO >> add: anIdentifier latitude: lat longitude: lon [ 
	^self execute: { #GEOADD. self name. lon. lat. anIdentifier }
]

{ #category : #calculating }
TRedisGEO >> distanceInFeetFrom: firstLocation to: secondLocation [
	^self execute: { #GEODIST. self name. firstLocation. secondLocation. 'ft' }	
]

{ #category : #calculating }
TRedisGEO >> distanceInKilometersFrom: firstLocation to: secondLocation [
	^self execute: { #GEODIST. self name. firstLocation. secondLocation. 'km' }	
]

{ #category : #calculating }
TRedisGEO >> distanceInMetersFrom: firstLocation to: secondLocation [
	^self execute: { #GEODIST. self name. firstLocation. secondLocation. 'm' }	
]

{ #category : #calculating }
TRedisGEO >> distanceInMilesFrom: firstLocation to: secondLocation [
	^self execute: { #GEODIST. self name. firstLocation. secondLocation. 'mi' }	
]

{ #category : #calculating }
TRedisGEO >> distancefrom: firstLocation to: secondLocation [
	^self execute: { #GEODIST. self name. firstLocation. secondLocation. self units }	
]

{ #category : #calculating }
TRedisGEO >> geoCode: aLocationOrArray [ 
	^self execute: ({ #GEOPOS. self name }, aLocationOrArray isString 
		ifFalse: [ aLocationOrArray asArray ] 
		ifTrue: [ { aLocationOrArray } ])
]

{ #category : #calculating }
TRedisGEO >> geoCodeAll: anArray [ 
	^self execute: ({ #GEOPOS. self name }, anArray)
]

{ #category : #calculating }
TRedisGEO >> geoHash: aLocationOrArray [ 
	^self execute: ({ #GEOHASH. self name }, aLocationOrArray isString 
		ifFalse: [ aLocationOrArray asArray ] 
		ifTrue: [ { aLocationOrArray } ])
]

{ #category : #calculating }
TRedisGEO >> geoHashAll: anArray [ 
	^self execute: ({ #GEOHASH. self name }, anArray asArray)
]

{ #category : #calculating }
TRedisGEO >> locationsWithin: aDistance latitude: lat longitude: lon [ 
	^self locationsWithin: aDistance latitude: lat longitude: lon limit: 10
]

{ #category : #calculating }
TRedisGEO >> locationsWithin: aDistance latitude: lat longitude: lon limit: maxResults [
	^self execute: { #GEORADIUS_RO. self key. lon. lat. aDistance. self units. #WITHDIST. #WITHCOORD. #COUNT. maxResults }
]

{ #category : #calculating }
TRedisGEO >> locationsWithin: aDistance ofLocation: aLocationName [
	^self locationsWithin: aDistance ofLocation: aLocationName limit: 10
]

{ #category : #calculating }
TRedisGEO >> locationsWithin: aDistance ofLocation: aLocationName limit: maxResults [
	^self execute: { #GEORADIUSBYMEMBER_RO. self key. aLocationName. aDistance. self units. #WITHDIST. #WITHCOORD. #COUNT. maxResults }
]

{ #category : #'adding/removing' }
TRedisGEO >> remove: aLocationName [
	^self execute: ({ #ZDEL. self name }, aLocationName isString 
		ifTrue: [ { aLocationName } ] 
		ifFalse: [ aLocationName ])
]

{ #category : #'adding/removing' }
TRedisGEO >> removeAll: anArray [
	^self execute: ({ #ZDEL. self name }, anArray)
]

{ #category : #accessing }
TRedisGEO >> units [
	^ self explicitRequirement
]

{ #category : #accessing }
TRedisGEO >> units: aValue [
	^ self explicitRequirement
]

{ #category : #calculating }
TRedisGEO >> useFeet [
	self units: #ft
]

{ #category : #calculating }
TRedisGEO >> useKilometers [
	self units: #km
]

{ #category : #calculating }
TRedisGEO >> useMeters [
	self units: #m
]

{ #category : #calculating }
TRedisGEO >> useMiles [
	self units: #mi
]

{ #category : #accessing }
TRedisGEO >> values [ 
	^self execute: { #ZRANGE. self name. 0. -1 }
]
