Class {
	#name : 'HOPNode',
	#superclass : 'Object',
	#instVars : [
		'parent',
		'name',
		'nodes'
	],
	#category : 'HOP-Core',
	#package : 'HOP-Core'
}

{ #category : 'instance creation' }
HOPNode class >> named: aString [ 
	^ self new 
		name: aString 
]

{ #category : 'arithmetic' }
HOPNode >> / segment [ 

	^ self 
		atName: segment
		ifAbsent: [ HOPSegmentNotFound signal: 'could not find segment named ', segment asString ]
]

{ #category : 'arithmetic' }
HOPNode >> /+ aSegment [ 

	^ aSegment addToHOPNode: self

]

{ #category : 'visiting' }
HOPNode >> acceptHOP: aHOPVisitor [
	self subclassResponsibility 
]

{ #category : 'adding' }
HOPNode >> addNode: aNode merging: aBoolean [  

	 | presentNode |
	aNode parent: self.

	presentNode := self 
		atName: aNode name
		ifAbsent: [ ^ self basicAddNode: aNode ].
	
	^ aBoolean 
		ifTrue: [  aNode mergeInto: presentNode ]
		ifFalse: [ HOPNodeExists signal: 'a node with name ', aNode name asString, ' already exists' ]

]

{ #category : 'adding' }
HOPNode >> addSegment: aNode [ 
	^ self 
		addNode: aNode 
		merging: false
]

{ #category : 'enumerating' }
HOPNode >> allChildrenDo: aBlock [  
	nodes do: [ :each |
		aBlock value: each.
		each allChildrenDo: aBlock ]

]

{ #category : 'helpers' }
HOPNode >> allNodes [ 
	
	^ (nodes flatCollect: #allNodes)
		addFirst: self;
		yourself 
]

{ #category : 'methods' }
HOPNode >> atName: aName [

	^ self 
		atName: aName 
		ifAbsent: [ HOPNodeNotFound signal: ('No node with name ' , aName , ' found.') ]
]

{ #category : 'accessing' }
HOPNode >> atName: key ifAbsent: aBlock [
	^ nodes 
		detect: [ :node | node name = key ]
		ifNone: aBlock
]

{ #category : 'accessing' }
HOPNode >> atName: key ifAbsentPut: aBlock [
	^ nodes 
		detect: [ :node | node name = key ]
		ifNone: [ self basicAddNode: aBlock value ]
]

{ #category : 'as yet unclassified' }
HOPNode >> basicAddNode: aNode [ 
	
	aNode parent: self.
	nodes add: aNode.
	^ aNode
]

{ #category : 'as yet unclassified' }
HOPNode >> canonicalUriFor: aResource [ 
	^ parent 
		ifNotNil: [ parent canonicalUriFor: aResource ] 
		ifNil: [ OrderedCollection new ]
]

{ #category : 'enumerating' }
HOPNode >> collect: aBlock into: aCollection [ 
	nodes do: [ :each |
		aBlock value: each value: aCollection.
		each collect: aBlock into: aCollection ].
	^ aCollection
]

{ #category : 'accessing' }
HOPNode >> detectSegmentNamed: segment routeMatch: routeMatch [
	| node |
	node := nodes 
		detect: [ :n | n matches: segment ]
		ifNone: [ HOPSegmentNotFound signal: 'cannot find key' ].
	routeMatch ifNotNil: [  
		node addSegment: segment routeMatch: routeMatch ].  
	^ node 
]

{ #category : 'testing' }
HOPNode >> includesNodeNamed: aString [ 
	self 
		atName: aString 
		ifAbsent: [ ^ false ].
	^ true
]

{ #category : 'initialization' }
HOPNode >> initialize [ 
	super initialize.
	nodes := SortedCollection new sortBlock: [ :a :b | a priority < b priority ]
]

{ #category : 'inspector' }
HOPNode >> inspectionSegments: aBuilder [
	<inspectorPresentationOrder: 0 title: 'segments'>

	^ aBuilder newTable
		items: nodes;
		addColumn: (SpStringTableColumn new
			title: 'name';
			evaluated: [:each | each printString   ]);
		addColumn: (SpStringTableColumn new
			title: 'methods';
			evaluated: [:each | $, join: (each methods associations collect: [ :assoc | assoc key asSymbol -> assoc value printString  ]) ])
]

{ #category : 'testing' }
HOPNode >> isRoot [ 
	^ parent isNil 
]

{ #category : 'testing' }
HOPNode >> isSpaceZone [ 
	^ false 
]

{ #category : 'accessing' }
HOPNode >> label [
	^ self name 
]

{ #category : 'actions' }
HOPNode >> mergeInto: aNode [
	nodes do: [ :each | 
		aNode addSegment: each ].
]

{ #category : 'as yet unclassified' }
HOPNode >> mergeNode: aNode [ 
	| childNode | 
	aNode nodes do: [ :node |
		childNode := nodes 
			detect: [ :each | each matchesNode: node ]
			ifFound: [ :each | each mergeNode: node ]
			ifNone: [ self addSegment: node ] ]
]

{ #category : 'accessing' }
HOPNode >> methods [ 
	^ Dictionary new
]

{ #category : 'accessing' }
HOPNode >> name [

	^ name
]

{ #category : 'accessing' }
HOPNode >> name: anObject [

	name := anObject
]

{ #category : 'as yet unclassified' }
HOPNode >> nearestResourceNode [
	parent ifNil: [ ^ nil ].
	^ parent nearestResourceNode 
]

{ #category : 'printing' }
HOPNode >> nodeLabel [
	self subclassResponsibility 
]

{ #category : 'accessing' }
HOPNode >> nodes [
	^ nodes
]

{ #category : 'accessing' }
HOPNode >> parent [

	^ parent
]

{ #category : 'accessing' }
HOPNode >> parent: anObject [

	parent := anObject
]

{ #category : 'printing' }
HOPNode >> printOn: aStream [ 
	aStream << self label asString << ' [' << self nodeLabel << ']' 
]

{ #category : 'enumerating' }
HOPNode >> recursiveDo: aBlock [  
	aBlock value: self.
	self allChildrenDo: aBlock
]

{ #category : 'accessing' }
HOPNode >> root [
	^ parent isNil 
		ifTrue: [ ^ self ]
		ifFalse: [ parent root ]
]

{ #category : 'as yet unclassified' }
HOPNode >> segmentIn: anAGRequestContext [ 
	^ self name
]

{ #category : 'as yet unclassified' }
HOPNode >> uriFor: aResource resourceRoute: resourceRoute [
	^ parent 
		ifNotNil: [ parent uriFor: aResource resourceRoute: resourceRoute ] 
		ifNil: [ OrderedCollection new ]
]
