Class {
	#name : #RedisPresenter,
	#superclass : #SpPresenter,
	#category : #'Redis-GUI'
}

{ #category : #specs }
RedisPresenter class >> defaultLayout [
	^self subclassResponsibility 

]

{ #category : #specs }
RedisPresenter class >> defaultSpec [
	^self defaultLayout

]
