Class {
	#name : 'HOPSpaceZone',
	#superclass : 'HOPTreeNode',
	#instVars : [
		'handlers'
	],
	#category : 'HOP-Core',
	#package : 'HOP-Core'
}

{ #category : 'converting' }
HOPSpaceZone class >> asHOPSegment [
	^ self new 
		build;
		asHOPSegment 
]

{ #category : 'instance creation' }
HOPSpaceZone class >> named: aString [ 
	^ self new 
		name: aString 
]

{ #category : 'adding' }
HOPSpaceZone >> addHandler: aHandler [ 
	handlers add: aHandler 
]

{ #category : 'testing' }
HOPSpaceZone >> addSegment: segment routeMatch: routeMatch [. 
	routeMatch addNode: self.
	
	handlers ifNotNil: [ 
		routeMatch addHandlers: handlers ]
]

{ #category : 'converting' }
HOPSpaceZone >> asHOPSegment [
	^ self 
]

{ #category : 'as yet unclassified' }
HOPSpaceZone >> canonicalUriFor: aResource [
	| path |
	path := super canonicalUriFor: aResource.
	parent ifNotNil: [ 
		"if we are not the root space we add our name to be 
		part of the URI" 
		path add: name ].
	^ path 	
]

{ #category : 'accessing' }
HOPSpaceZone >> handlers [ 
	^ handlers
]

{ #category : 'testing' }
HOPSpaceZone >> hasHandlers [ 
	^ handlers notEmpty
]

{ #category : 'testing' }
HOPSpaceZone >> hasMethods [
	^ false 
]

{ #category : 'initialization' }
HOPSpaceZone >> initialize [ 
	super initialize.
	handlers := OrderedCollection new
]

{ #category : 'testing' }
HOPSpaceZone >> isSpaceZone [ 
	^ true 
]

{ #category : 'testing' }
HOPSpaceZone >> matches: segment [ 
	^ name = segment  
]

{ #category : 'testing' }
HOPSpaceZone >> matchesScope: aResource in: requestContext [
	^ false
]

{ #category : 'printing' }
HOPSpaceZone >> nodeLabel [
	^ 'zone'
]

{ #category : 'accessing' }
HOPSpaceZone >> priority [
	^ 1
]

{ #category : 'as yet unclassified' }
HOPSpaceZone >> uriFor: aResource requestContext: requestContext [
	| path |
	path := super uriFor: aResource requestContext: requestContext.
	parent ifNotNil: [  
		path add: name ].
	^ path
		
]
