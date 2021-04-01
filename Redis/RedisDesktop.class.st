Class {
	#name : #RedisDesktop,
	#superclass : #SpApplication,
	#instVars : [
		'clients'
	],
	#classVars : [
		'IconProvider'
	],
	#category : #'Redis-GUI'
}

{ #category : #accessing }
RedisDesktop class >> iconNamed: aName [
	 ^(IconProvider
		iconNamed: aName 
		ifAbsent: [ Smalltalk ui icons 
			iconNamed: aName 
			ifNone: [ ThemeIcons current blankIcon ] ]) scaledToSize: 20@20
]

{ #category : #'class initialization' }
RedisDesktop class >> initialize [
	IconProvider := SpLocationIconProvider newLocation: FileLocator home / 'Projects' / 'rdm' / 'src' / 'resources' / 'images'.
	self defaultApplication: (self new iconManager: IconProvider; yourself)
]

{ #category : #'as yet unclassified' }
RedisDesktop class >> systemIconName [
	^'database'
]
