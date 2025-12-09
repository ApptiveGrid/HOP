Extension { #name : 'SequenceableCollection' }

{ #category : '*HOP-Core' }
SequenceableCollection >> addMethodsTo: aHOPSegment [ 
	self do: [ :each | each addMethodsTo: aHOPSegment ]
]
