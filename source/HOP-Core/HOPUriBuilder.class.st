Class {
	#name : 'HOPUriBuilder',
	#superclass : 'HOPVisitor',
	#instVars : [
		'segments',
		'resource',
		'operation',
		'resourceRoute'
	],
	#category : 'HOP-Core',
	#package : 'HOP-Core'
}

{ #category : 'building' }
HOPUriBuilder >> build [
	| startSegment |
	startSegment := operation 
		ifNotNil: [ uriSpace segmentForResource: resource andOperation: operation ]
		ifNil: [ uriSpace segmentForResource: resource ].
	self visit: startSegment.
	^ ($/ join: segments reversed) copyWithFirst: $/ 
]

{ #category : 'as yet unclassified' }
HOPUriBuilder >> containerOf: aHOPSegment [  
	^ resource perform: aHOPSegment containerSelector asSymbol 
]

{ #category : 'initialization' }
HOPUriBuilder >> initialize [ 
	super initialize.
	segments := OrderedCollection new 
]

{ #category : 'accessing' }
HOPUriBuilder >> operation: aClass [ 
	operation := aClass 
]

{ #category : 'accessing' }
HOPUriBuilder >> resource: anObject [ 
	resource := anObject 
]

{ #category : 'accessing' }
HOPUriBuilder >> resourceRoute: aHOPResourceRoute [ 
	resourceRoute := aHOPResourceRoute 
]

{ #category : 'services' }
HOPUriBuilder >> valueFor: aHOPVariableSegment [ 
	^ resource perform: aHOPVariableSegment segmentNameSelector asSymbol  
]

{ #category : 'visiting' }
HOPUriBuilder >> visitNamedSegment: aNamedSegment [ 
	segments add: aNamedSegment name.
	super visitNamedSegment: aNamedSegment.
	
]

{ #category : 'visiting' }
HOPUriBuilder >> visitSegment: aHOPSegment [ 
	aHOPSegment isRoot ifFalse: [
		self visit: aHOPSegment parent  ]
]

{ #category : 'visiting' }
HOPUriBuilder >> visitSpaceZone: aSpaceZone [ 
	segments add: aSpaceZone name.
	super visitSpaceZone: aSpaceZone
]

{ #category : 'visiting' }
HOPUriBuilder >> visitUriSpace: aUriSpace [ 
	
]

{ #category : 'visiting' }
HOPUriBuilder >> visitVariableSegment: aHOPVariableSegment [ 
	segments add: (self valueFor: aHOPVariableSegment) .
	resource := self containerOf: aHOPVariableSegment .
	super visitVariableSegment: aHOPVariableSegment 
]
