Extension { #name : 'Collection' }

{ #category : '*HOP-Core' }
Collection >> addToHOPNode: aNode [
	self do: [ :each | 
		aNode addNode: each asHOPSegment root merging: true ].
	^ aNode
]
