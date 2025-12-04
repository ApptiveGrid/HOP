Class {
	#name : 'HOPTreeNode',
	#superclass : 'HOPNode',
	#instVars : [
		'nodes'
	],
	#category : 'HOP-Core',
	#package : 'HOP-Core'
}

{ #category : 'testing' }
HOPTreeNode class >> isAbstract [ 
	^ self == HOPTreeNode 
]

{ #category : 'instance creation' }
HOPTreeNode class >> named: aString [ 
	^ self new 
		name: aString 
]

{ #category : 'arithmetic' }
HOPTreeNode >> / segment [ 

	^ self 
		atName: segment
		ifAbsent: [ HOPSegmentNotFound signal: 'could not find segment named ', segment asString ]
]

{ #category : 'arithmetic' }
HOPTreeNode >> /+ aSegment [ 

	^ aSegment addToHOPNode: self

]

{ #category : 'adding' }
HOPTreeNode >> addNode: aNode [ 
	^ self 
		addNode: aNode 
		merging: false
]

{ #category : 'adding' }
HOPTreeNode >> addNode: aNode merging: aBoolean [  

	 | presentNode |
	aNode parent: self.

	presentNode := self 
		atName: aNode name
		ifAbsent: [ ^ self basicAddNode: aNode ].
	
	^ aBoolean 
		ifTrue: [  aNode mergeInto: presentNode ]
		ifFalse: [ HOPNodeExists signal: 'a node with name ', aNode name asString, ' already exists' ]

]

{ #category : 'enumerating' }
HOPTreeNode >> allChildrenDo: aBlock [  
	nodes do: [ :each |
		aBlock value: each.
		each allChildrenDo: aBlock ]

]

{ #category : 'helpers' }
HOPTreeNode >> allNodes [ 
	
	^ (nodes flatCollect: #allNodes)
		addFirst: self;
		yourself 
]

{ #category : 'methods' }
HOPTreeNode >> atName: aName [

	^ self 
		atName: aName 
		ifAbsent: [ HOPNodeNotFound signal: ('No node with name ' , aName , ' found.') ]
]

{ #category : 'accessing' }
HOPTreeNode >> atName: key ifAbsent: aBlock [
	^ nodes 
		detect: [ :node | node name = key ]
		ifNone: aBlock
]

{ #category : 'accessing' }
HOPTreeNode >> atName: key ifAbsentPut: aBlock [
	^ nodes 
		detect: [ :node | node name = key ]
		ifNone: [ self basicAddNode: aBlock value ]
]

{ #category : 'as yet unclassified' }
HOPTreeNode >> basicAddNode: aNode [ 
	
	aNode parent: self.
	nodes add: aNode.
	^ aNode
]

{ #category : 'enumerating' }
HOPTreeNode >> collect: aBlock into: aCollection [ 
	nodes do: [ :each |
		aBlock value: each value: aCollection.
		each collect: aBlock into: aCollection ].
	^ aCollection
]

{ #category : 'accessing' }
HOPTreeNode >> detectSegmentNamed: segment routeMatch: routeMatch [
	| node |
	node := nodes 
		detect: [ :n | n matches: segment ]
		ifNone: [ HOPSegmentNotFound signal: 'cannot find key' ].
	routeMatch ifNotNil: [  
		node addSegment: segment routeMatch: routeMatch ].  
	^ node 
]

{ #category : 'testing' }
HOPTreeNode >> includesNodeNamed: aString [ 
	self 
		atName: aString 
		ifAbsent: [ ^ false ].
	^ true
]

{ #category : 'initialization' }
HOPTreeNode >> initialize [ 
	super initialize.
	nodes := SortedCollection new sortBlock: [ :a :b | a priority < b priority ]
]

{ #category : 'inspector' }
HOPTreeNode >> inspectionSegments: aBuilder [
	<inspectorPresentationOrder: 0 title: 'segments'>

	^ aBuilder newTable
		items: nodes;
		addColumn: (SpStringTableColumn new
			title: 'key'";
			width: 30";
			evaluated: [:each | each printString   ])
]

{ #category : 'as yet unclassified' }
HOPTreeNode >> mergeNode: aNode [ 
	| childNode | 
	aNode nodes do: [ :node |
		childNode := nodes 
			detect: [ :each | each matchesNode: node ]
			ifFound: [ :each | each mergeNode: node ]
			ifNone: [ self addNode: node ] ]
]

{ #category : 'accessing' }
HOPTreeNode >> nodes [
	^ nodes
]

{ #category : 'enumerating' }
HOPTreeNode >> recursiveDo: aBlock [  
	aBlock value: self.
	self allChildrenDo: aBlock
]

{ #category : 'as yet unclassified' }
HOPTreeNode >> segmentIn: anAGRequestContext [ 
	^ self name
]
