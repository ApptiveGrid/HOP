Class {
	#name : 'HOPVariableSegment',
	#superclass : 'HOPSegment',
	#instVars : [
		'resolveBlock',
		'resolveClass',
		'canonical',
		'resourceSelector'
	],
	#category : 'HOP-Core',
	#package : 'HOP-Core'
}

{ #category : 'testing' }
HOPVariableSegment >> addSegment: key routeMatch: requestContext [. 
	super addSegment: key routeMatch: requestContext. 
	requestContext 
		receiverNode: self;
		variableAt: self name put: key
]

{ #category : 'as yet unclassified' }
HOPVariableSegment >> beCanonical [
	"this node is part of the canonical instance tree where every object class
	has its canonical position. This is dues to object variables can occur more
	than once but have only one canonical position "
	canonical := true
]

{ #category : 'as yet unclassified' }
HOPVariableSegment >> canonicalUriFor: aResource [
	^ (super canonicalUriFor: aResource container)
		add: aResource id asApptiveExternalId;
		yourself 
]

{ #category : 'initialization' }
HOPVariableSegment >> initialize [ 
	super initialize .
	canonical := false
]

{ #category : 'as yet unclassified' }
HOPVariableSegment >> initializePresenter [
	"a node refers to a basic instance class. We resolve all non-abstract instance
	classes do determine presenters on "
	self presenterClasses do: [ :presenterClass | 
		"each instance class can have a number of possible presenters. From an instance
		class we get the base presenter class"
		"we collect all links pragma for the base class and all its subclasses"
		presenterClass allLinksPragmas do: [ :pragma | 
			self registerOperationFor: pragma presenter: presenterClass  ] ].
	
			
]

{ #category : 'accessing' }
HOPVariableSegment >> instanceMapClasses [

	^ resolveClass presentedClasses
]

{ #category : 'testing' }
HOPVariableSegment >> isCanonical [
	^ canonical 
]

{ #category : 'testing' }
HOPVariableSegment >> matches: key [ 
	^ key notNil
]

{ #category : 'testing' }
HOPVariableSegment >> matchesNode: aHOPNode [
	(aHOPNode class == self class) ifFalse: [ ^ false ].
	^ aHOPNode name = name 
]

{ #category : 'services' }
HOPVariableSegment >> matchesScope: aResource in: requestContext [


	^ (aResource matchesScopeOf: (self valueIn: requestContext)).
]

{ #category : 'printing' }
HOPVariableSegment >> nodeLabel [
	^ 'variable'
]

{ #category : 'accessing' }
HOPVariableSegment >> presenterClasses [

	^ resolveClass presenterClasses
]

{ #category : 'accessing' }
HOPVariableSegment >> priority [ 
	^ 2
]

{ #category : 'accessing' }
HOPVariableSegment >> resolveBlock: anObject [

	resolveBlock := anObject
]

{ #category : 'accessing' }
HOPVariableSegment >> resolveClass [

	^ resolveClass
]

{ #category : 'accessing' }
HOPVariableSegment >> resolveClass: anObject [

	resolveClass := anObject
]

{ #category : 'as yet unclassified' }
HOPVariableSegment >> resourceSelector [
	^ resourceSelector 
]

{ #category : 'accessing' }
HOPVariableSegment >> resourceSelector: anObject [

	resourceSelector := anObject
]

{ #category : 'as yet unclassified' }
HOPVariableSegment >> segmentIn: anAGRequestContext [ 
	^ (anAGRequestContext variableAt: self name) 
]

{ #category : 'as yet unclassified' }
HOPVariableSegment >> uriFor: aResource requestContext: requestContext [

	(requestContext nodeMatchingScope: aResource) ifNotNil: [:aNode |
		"it could be that the current request uri has a segment matching the resource for wich we want to build the uri.
		in particular, in case of a external link nested request,  we want to preserve the link prefix part and append the specific segments after. "
		^ ((requestContext nodes  copyUpThrough: aNode) 
		collect: [ :each | each segmentIn: requestContext ])
		].
	^ (super uriFor: aResource container requestContext: requestContext)
		add: aResource id asApptiveExternalId;
		yourself 
]

{ #category : 'as yet unclassified' }
HOPVariableSegment >> valueIn: anAGRequestContext [ 
	^ anAGRequestContext resourceOfNode: self 
]
