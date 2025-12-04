Extension { #name : 'Association' }

{ #category : '*HOP-Core' }
Association >> addMethodsTo: aHOPSegment [ 
	aHOPSegment 
		atMethod: key asLowercase 
		put: value
]

{ #category : '*HOP-Core' }
Association >> asHOPSegment [
	^ value asHOPSegment root 
		name: key
]
