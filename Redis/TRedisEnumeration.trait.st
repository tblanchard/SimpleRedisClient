"
I provide the Pharo Collections enumeration protocol for Redis collections. 

I am implemented as a Trait to provide flexibility in implementing immediate or batched 
command processing. Any object adopting this protocol will be expected to implement 



"
Trait {
	#name : #TRedisEnumeration,
	#category : #'Redis-Traits'
}

{ #category : #enumerating }
TRedisEnumeration >> allSatisfy: aBlock [
	^self contents allSatisfy: aBlock
]

{ #category : #enumerating }
TRedisEnumeration >> anySatisfy: aBlock [
	^self contents anySatisfy: aBlock
]

{ #category : #enumerating }
TRedisEnumeration >> associationsDo: aBlock [
	"Evaluate aBlock for each of the receiver's elements (key/value 
	associations).  If any non-association is within, the error is not caught now,
	but later, when a key or value message is sent to it."

	self do: aBlock
]

{ #category : #enumerating }
TRedisEnumeration >> collect: aBlock [ 
	^self contents collect: aBlock 
]

{ #category : #enumerating }
TRedisEnumeration >> collect: aBlock as: aClass [
	"Evaluate aBlock with each of the receiver's elements as the argument.  
	Collect the resulting values into an instance of aClass. Answer the resulting collection."

	^(aClass new: self size) fillFrom: self with: aBlock
]

{ #category : #enumerating }
TRedisEnumeration >> collect: aBlock into: aCollection [
	"Evaluate aBlock with each of the receiver's elements as the argument.  
	Collect the resulting values into aCollection. Answer aCollection."

	^aCollection fillFrom: self with: aBlock
]

{ #category : #enumerating }
TRedisEnumeration >> collect: collectBlock thenDo: doBlock [ 
	^self contents collect: collectBlock thenDo: doBlock 
]

{ #category : #enumerating }
TRedisEnumeration >> collect: collectBlock thenReject: selectBlock [
	^self contents collect: collectBlock thenReject: selectBlock
]

{ #category : #enumerating }
TRedisEnumeration >> collect: collectBlock thenSelect: selectBlock [
	^self contents collect: collectBlock thenSelect: selectBlock
]

{ #category : #accessing }
TRedisEnumeration >> contents [
	^ self explicitRequirement
]

{ #category : #enumerating }
TRedisEnumeration >> count: aBlock [ 
	^self contents count: aBlock 
]

{ #category : #enumerating }
TRedisEnumeration >> detect: aBlock [ 
	^self contents detect: aBlock 
]

{ #category : #enumerating }
TRedisEnumeration >> detect: aBlock ifFound: foundBlock [
	^self contents detect: aBlock ifFound: foundBlock
]

{ #category : #enumerating }
TRedisEnumeration >> detect: aBlock ifFound: foundBlock ifNone: exceptionBlock [
	"Evaluate aBlock with each of the receiver's elements as the argument.  
	If some element evaluates aBlock to true, then cull this element into 
	foundBlock and answer the result of this evaluation. 
	If none evaluate to true, then evaluate exceptionBlock."
	^self contents detect: aBlock ifFound: foundBlock ifNone: exceptionBlock
	
]

{ #category : #enumerating }
TRedisEnumeration >> detect: aBlock ifNone: exceptionBlock [
	"Evaluate aBlock with each of the receiver's elements as the argument.  
	If some element evaluates aBlock to true, then cull this element into 
	foundBlock and answer the result of this evaluation. 
	If none evaluate to true, then evaluate exceptionBlock."
	^self contents detect: aBlock ifNone: exceptionBlock
	
]

{ #category : #enumerating }
TRedisEnumeration >> detectMax: aBlock [
	^self contents detectMax: aBlock
	
]

{ #category : #enumerating }
TRedisEnumeration >> detectMin: aBlock [
	^self contents detectMin: aBlock
	
]

{ #category : #enumerating }
TRedisEnumeration >> detectSum: aBlock [
	^self contents detectSum: aBlock
	
]

{ #category : #enumerating }
TRedisEnumeration >> difference: aCollection [
	^self contents difference: aCollection
	
]

{ #category : #enumerating }
TRedisEnumeration >> do: aBlock [ 
	^self contents do: aBlock 
	
]

{ #category : #enumerating }
TRedisEnumeration >> do: elementBlock separatedBy: separatorBlock [
	^self contents do: elementBlock separatedBy: separatorBlock 
	
]

{ #category : #enumerating }
TRedisEnumeration >> do: aBlock without: anItem [ 
	^self contents do: aBlock without: anItem  
	
]

{ #category : #enumerating }
TRedisEnumeration >> doWithIndex: aBlock2 [
	^self contents doWithIndex: aBlock2
	
]

{ #category : #enumerating }
TRedisEnumeration >> fold: binaryBlock [
	^self contents fold: binaryBlock
	
]

{ #category : #enumerating }
TRedisEnumeration >> groupedBy: aBlock [
	^self contents groupedBy: aBlock
	
]

{ #category : #enumerating }
TRedisEnumeration >> groupedBy: aBlock having: aSelectionBlock [
	^self contents groupedBy: aBlock having: aSelectionBlock
	
]

{ #category : #enumerating }
TRedisEnumeration >> inject: thisValue into: binaryBlock [ 
	^self contents inject: thisValue into: binaryBlock 
	
]

{ #category : #enumerating }
TRedisEnumeration >> intersection: aCollection [
	^self contents intersection: aCollection
	
]

{ #category : #enumerating }
TRedisEnumeration >> noneSatisfy: aBlock [
	^self contents noneSatisfy: aBlock
	
]

{ #category : #enumerating }
TRedisEnumeration >> occurrencesOf: anObject [ 
	^self contents occurrencesOf: anObject 
	
]

{ #category : #enumerating }
TRedisEnumeration >> reduce: aBlock [
	^self contents reduce: aBlock
	
]

{ #category : #enumerating }
TRedisEnumeration >> reject: aBlock [ 
	^self contents reject: aBlock 
	
]

{ #category : #enumerating }
TRedisEnumeration >> reject: rejectBlock thenDo: doBlock [ 
	^self contents reject: rejectBlock thenDo: doBlock 
	
]

{ #category : #enumerating }
TRedisEnumeration >> select: aBlock [ 
	^self contents select: aBlock 
	
]

{ #category : #enumerating }
TRedisEnumeration >> select: selectBlock thenCollect: collectBlock [
	^self contents select: selectBlock thenCollect: collectBlock
	
]

{ #category : #enumerating }
TRedisEnumeration >> select: selectBlock thenDo: doBlock [
	^self contents select: selectBlock thenDo: doBlock
	
]
