Class {
	#name : 'HOPVariableSegment',
	#superclass : 'HOPSegment',
	#instVars : [
		'canonical',
		'resourceRouteSelector',
		'resourceClass',
		'segmentNameSelector',
		'containerSelector'
	],
	#category : 'HOP-Core',
	#package : 'HOP-Core'
}

{ #category : 'associating' }
HOPVariableSegment >> --> aClass [ 
	self root registerSegment: self forResourceType: aClass 
]

{ #category : 'visiting' }
HOPVariableSegment >> acceptHOP: aHOPVisitor [
	^ aHOPVisitor visitVariableSegment: self 
]

{ #category : 'testing' }
HOPVariableSegment >> addSegment: key routeMatch: routeMatch [. 
	super addSegment: key routeMatch: routeMatch. 
	routeMatch 
		lastVariableSegment: self;
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

{ #category : 'accessing' }
HOPVariableSegment >> containerSelector [

	^ containerSelector
]

{ #category : 'accessing' }
HOPVariableSegment >> containerSelector: anObject [

	containerSelector := anObject
]

{ #category : 'initialization' }
HOPVariableSegment >> initialize [ 
	super initialize .
	canonical := false.
	segmentNameSelector := #id.
	containerSelector := #container
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
	resourceClass ifNil: [ ^ nil ].
	^ resourceClass hopExposedClasses
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
HOPVariableSegment >> matchesScope: aResource in: routeMatch [


	^ (aResource matchesScopeOf: (self valueIn: routeMatch)).
]

{ #category : 'as yet unclassified' }
HOPVariableSegment >> nearestResourceNode [ 
	^ self 
]

{ #category : 'printing' }
HOPVariableSegment >> nodeLabel [
	^ 'variable'
]

{ #category : 'accessing' }
HOPVariableSegment >> presenterClasses [

	^ resourceClass presenterClasses
]

{ #category : 'accessing' }
HOPVariableSegment >> priority [ 
	^ 2
]

{ #category : 'accessing' }
HOPVariableSegment >> resolveClass [

	^ resourceClass
]

{ #category : 'accessing' }
HOPVariableSegment >> resolveClass: anObject [

	resourceClass := anObject
]

{ #category : 'as yet unclassified' }
HOPVariableSegment >> resourceSelector [
	^ resourceRouteSelector 
]

{ #category : 'accessing' }
HOPVariableSegment >> resourceSelector: anObject [

	resourceRouteSelector := anObject
]

{ #category : 'as yet unclassified' }
HOPVariableSegment >> segmentIn: aResourceRoute [ 
	^ (aResourceRoute variableAt: self name) 
]

{ #category : 'accessing' }
HOPVariableSegment >> segmentNameSelector [

	^ segmentNameSelector
]

{ #category : 'accessing' }
HOPVariableSegment >> segmentNameSelector: anObject [

	segmentNameSelector := anObject
]

{ #category : 'as yet unclassified' }
HOPVariableSegment >> uriFor: aResource resourceRoute: resourceRoute [
	| effectiveRoute |
	effectiveRoute := resourceRoute previous ifNil: [ resourceRoute ].
	((aResource isIdenticalTo: effectiveRoute receiver) or: [aResource isIdenticalTo: effectiveRoute receiver scope ]) ifTrue: [ 
				^ effectiveRoute receiverSegments collect: [ :each | each segmentIn: effectiveRoute ] ].
	
	^ (super uriFor: aResource container resourceRoute: resourceRoute)
		add: aResource id asApptiveExternalId;
		yourself 
]

{ #category : 'as yet unclassified' }
HOPVariableSegment >> valueIn: anAGRequestContext [ 
	^ anAGRequestContext resourceOfNode: self 
]
