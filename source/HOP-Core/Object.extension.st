Extension { #name : 'Object' }

{ #category : '*HOP-Core' }
Object >> addToHOPNode: aNode [ 
	^ aNode addSegment: self asHOPSegment
]
