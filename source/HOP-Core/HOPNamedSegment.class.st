Class {
	#name : 'HOPNamedSegment',
	#superclass : 'HOPSegment',
	#category : 'HOP-Core',
	#package : 'HOP-Core'
}

{ #category : 'visiting' }
HOPNamedSegment >> acceptHOP: aHOPVisitor [
	^ aHOPVisitor visitNamedSegment: self  
]

{ #category : 'matching' }
HOPNamedSegment >> matches: aString [ 
	^ name = aString 
]

{ #category : 'testing' }
HOPNamedSegment >> matchesNode: aHOPNode [
	(aHOPNode class == self class) ifFalse: [ ^ false ].
	^ aHOPNode name = name
]

{ #category : 'printing' }
HOPNamedSegment >> nodeLabel [
	^ 'named'
]

{ #category : 'accessing' }
HOPNamedSegment >> priority [ 
	^ 1
]
