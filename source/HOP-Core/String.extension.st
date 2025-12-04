Extension { #name : 'String' }

{ #category : '*HOP-Core' }
String >> /+ anObject [ 
	^ self asHOPSegment /+ anObject
]

{ #category : '*HOP-Core' }
String >> addToHOPNode: aNode [ 
	^ aNode addNode: self asHOPSegment
]

{ #category : '*HOP-Core' }
String >> asHOPSegment [
	^ HOPNamedSegment new 
		name: self
]
