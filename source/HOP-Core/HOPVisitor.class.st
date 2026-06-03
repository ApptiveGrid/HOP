Class {
	#name : 'HOPVisitor',
	#superclass : 'Object',
	#category : 'HOP-Core',
	#package : 'HOP-Core'
}

{ #category : 'visiting' }
HOPVisitor >> visit: anObject [ 
	^ anObject acceptHOP: self 
]

{ #category : 'visiting' }
HOPVisitor >> visitNamedSegment: aNamedSegment [ 
	self visitSegment: aNamedSegment 
]

{ #category : 'visiting' }
HOPVisitor >> visitSegment: aHOPSegment [ 
	
]

{ #category : 'visiting' }
HOPVisitor >> visitSpaceZone: aHOSpaceZone [
	self visitSegment: aHOSpaceZone 
]

{ #category : 'visiting' }
HOPVisitor >> visitUriSpace: aHOPUriSpace [ 
	self visitSpaceZone: aHOPUriSpace 
]

{ #category : 'visiting' }
HOPVisitor >> visitVariableSegment: aHOPVariableSegment [ 
	self visitSegment: aHOPVariableSegment 
]
