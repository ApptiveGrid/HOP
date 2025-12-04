Class {
	#name : 'HOPCatchAllSegment',
	#superclass : 'HOPSegment',
	#category : 'HOP-Core',
	#package : 'HOP-Core'
}

{ #category : 'arithmetic' }
HOPCatchAllSegment >> / aString [ 
	^ self 
]

{ #category : 'testing' }
HOPCatchAllSegment >> addSegment: segment routeMatch: requestContext [
	requestContext addExtraPath: segment.
	^ self
]

{ #category : 'accessing' }
HOPCatchAllSegment >> detectSegmentNamed: segment routeMatch: routeMatch [
	routeMatch addExtraPath: segment.
	^ self
]

{ #category : 'initialization' }
HOPCatchAllSegment >> initialize [ 
	super initialize.
	name := #catchall
]

{ #category : 'testing' }
HOPCatchAllSegment >> matches: aString [ 
	^ true
]

{ #category : 'printing' }
HOPCatchAllSegment >> nodeLabel [
	^ '*'
]

{ #category : 'accessing' }
HOPCatchAllSegment >> priority [ 
	^ 4
]
