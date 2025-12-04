Class {
	#name : 'HOPNode',
	#superclass : 'Object',
	#instVars : [
		'parent',
		'name'
	],
	#category : 'HOP-Core',
	#package : 'HOP-Core'
}

{ #category : 'as yet unclassified' }
HOPNode >> canonicalUriFor: aResource [ 
	^ parent 
		ifNotNil: [ parent canonicalUriFor: aResource ] 
		ifNil: [ OrderedCollection new ]
]

{ #category : 'accessing' }
HOPNode >> name [

	^ name
]

{ #category : 'accessing' }
HOPNode >> name: anObject [

	name := anObject
]

{ #category : 'printing' }
HOPNode >> nodeLabel [
	self subclassResponsibility 
]

{ #category : 'accessing' }
HOPNode >> parent [

	^ parent
]

{ #category : 'accessing' }
HOPNode >> parent: anObject [

	parent := anObject
]

{ #category : 'printing' }
HOPNode >> printOn: aStream [ 
	aStream << name asString << ' [' << self nodeLabel << ']' 
]

{ #category : 'accessing' }
HOPNode >> root [
	^ parent isNil 
		ifTrue: [ ^ self ]
		ifFalse: [ parent root ]
]

{ #category : 'as yet unclassified' }
HOPNode >> uriFor: aResource requestContext: requestContext [
	^ parent 
		ifNotNil: [ parent uriFor: aResource requestContext: requestContext ] 
		ifNil: [ OrderedCollection new ]
]
