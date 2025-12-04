Extension { #name : 'Object' }

{ #category : '*HOP-Core' }
Object >> addToHOPNode: aNode [ 
	^ aNode addNode: self asHOPSegment
]
