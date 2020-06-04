"
I translate Smalltalk methods to Redis commands for key expiration, and time to live functions.
"
Trait {
	#name : #TRedisExpiration,
	#traits : 'TRedis',
	#classTraits : 'TRedis classTrait',
	#category : #SimpleRedisClient
}

{ #category : #expiration }
TRedisExpiration >> expireAt: aDateAndTime [
	^(self execute: { #EXPIRE. self name. aDateAndTime asUnixTime }) = 1
]

{ #category : #expiration }
TRedisExpiration >> expireIn: aDuration [
	(aDuration class includesBehavior: Duration) 
		ifTrue: [ 
			aDuration milliseconds > 0 
			ifTrue: [ ^self at: self name expireInMilliseconds: aDuration asMilliseconds ]
			ifFalse: [ ^self at: self name expireInSeconds: aDuration asSeconds ] ]
		ifFalse: [ self error: 'Expected duration.  Please use pass a Duration or use at:expireInMilliseconds: or at:expireInSeconds:' ]
]

{ #category : #expiration }
TRedisExpiration >> expireInMilliseconds: millisecs [
	^(self execute: { #PEXPIRE. self name. millisecs }) = 1
]

{ #category : #expiration }
TRedisExpiration >> expireInSeconds: seconds [
	^(self execute: { #EXPIRE. self name. seconds }) = 1
]

{ #category : #expiration }
TRedisExpiration >> milliSecondsToLive [
	^self execute: { #PTTL. self name }
]

{ #category : #accessing }
TRedisExpiration >> name [
	^ self explicitRequirement
]

{ #category : #expiration }
TRedisExpiration >> persist [ 
	^self execute: { #PERSIST. self name }
]

{ #category : #expiration }
TRedisExpiration >> secondsToLive [
	^self execute: { #TTL. self name }
]

{ #category : #expiration }
TRedisExpiration >> touch [
	^self execute: { #TOUCH. self name }
]
