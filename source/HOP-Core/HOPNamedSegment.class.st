Class {
	#name : 'HOPNamedSegment',
	#superclass : 'HOPSegment',
	#category : 'HOP-Core',
	#package : 'HOP-Core'
}

{ #category : 'converting' }
HOPNamedSegment >> asHOPSpaceZone [
	^ HOPSpaceZone new 
		name: name;
		mergeNode: self root;
		yourself 
]

{ #category : 'as yet unclassified' }
HOPNamedSegment >> canonicalUriFor: aResource [
	^ (super canonicalUriFor: aResource)
		add: name;
		yourself 
		
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

{ #category : 'services' }
HOPNamedSegment >> matchesScope: aResource in: requestContext [

	^ false
]

{ #category : 'printing' }
HOPNamedSegment >> nodeLabel [
	^ 'named'
]

{ #category : 'accessing' }
HOPNamedSegment >> priority [ 
	^ 1
]

{ #category : 'as yet unclassified' }
HOPNamedSegment >> uriFor: aResource requestContext: requestContext [
	^ (super uriFor: aResource requestContext: requestContext)
		add: name;
		yourself 
		
]
