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
	^ self buildFrom: (operation 
		ifNotNil: [ uriSpace segmentForResource: resource andOperation: operation ]
		ifNil: [ uriSpace segmentForResource: resource ])
]

{ #category : 'building' }
HOPUriBuilder >> buildFrom: aSegment [
	self visit: aSegment.
	^ ($/ join: segments reversed) copyWithFirst: $/ 
]

{ #category : 'building' }
HOPUriBuilder >> buildLink [
	"the uri together with the http method that reaches the operation there. A link to a
	resource without an operation has no method"
	| segmentAndMethod |
	operation ifNil: [ ^ HOPLink href: self build method: nil ].
	segmentAndMethod := uriSpace segmentAndMethodForResource: resource andOperation: operation.
	^ HOPLink href: (self buildFrom: segmentAndMethod first) method: segmentAndMethod second
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
HOPUriBuilder >> visitUriSpace: aUriSpace [ 
	"the root is the empty path and adds nothing. A space mounted under a name is a
	named segment of the space it is mounted in"
	aUriSpace isRoot ifFalse: [ 
		self visitNamedSegment: aUriSpace ]
]

{ #category : 'visiting' }
HOPUriBuilder >> visitVariableSegment: aHOPVariableSegment [
	"walking up from the resource, a resource the current route already stands at takes the
	rest of its uri from the route instead of the canonical tree. This keeps a link inside
	whatever the request came through, e.g. an object reached via a stand-in for it (see
	Object>>extraReceiver). A route continued at another resource looks at the route it
	continued from"
	resourceRoute ifNotNil: [
		| effectiveRoute |
		effectiveRoute := resourceRoute previous ifNil: [ resourceRoute ].
		(uriSpace isResource: resource inScopeOf: effectiveRoute receiver) ifTrue: [
			effectiveRoute receiverSegments reversed
				do: [ :each | segments add: (each segmentIn: effectiveRoute) ].
			^ self ] ].
	segments add: (self valueFor: aHOPVariableSegment) .
	resource := self containerOf: aHOPVariableSegment .
	super visitVariableSegment: aHOPVariableSegment 
]
