Class {
	#name : 'HOPUriBuilder',
	#superclass : 'HOPVisitor',
	#instVars : [
		'segments',
		'resource'
	],
	#category : 'HOP-Core',
	#package : 'HOP-Core'
}

{ #category : 'building' }
HOPUriBuilder >> build [
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
HOPUriBuilder >> resource: anObject [ 
	resource := anObject 
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
HOPUriBuilder >> visitVariableSegment: aHOPVariableSegment [ 
	segments add: (self valueFor: aHOPVariableSegment) .
	resource := self containerOf: aHOPVariableSegment .
	super visitVariableSegment: aHOPVariableSegment 
]
