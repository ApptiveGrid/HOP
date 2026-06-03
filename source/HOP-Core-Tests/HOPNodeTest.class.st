Class {
	#name : 'HOPNodeTest',
	#superclass : 'TestCase',
	#category : 'HOP-Core-Tests-Tests',
	#package : 'HOP-Core-Tests',
	#tag : 'Tests'
}

{ #category : 'tests' }
HOPNodeTest >> testAddCollection [
	| node |
	node := #root /+ { #bar . #foo }.
	self assert: node nodes size equals: 2.
	self assert: (node nodes anySatisfy: [ :each | each name = #bar ])
]

{ #category : 'tests' }
HOPNodeTest >> testAddNameNode [ 
	| node |
	node := #root /+ #bar.
	self assert: node name equals: #bar.
	self assert: node root name equals: #root
	
]

{ #category : 'tests' }
HOPNodeTest >> testAddNameNodeCascading [
	| node |
	node := #root /+ #foo /+ #bar.
	self assert: node name equals: #bar.
	self assert: node root name equals: #root
	
]

{ #category : 'tests' }
HOPNodeTest >> testAddNodeWithBlock [
	| root last | 
	root := #/ asHOPSegment.
	last := root /+ [:x| ].
	self assert: (root atName: #x) equals: last 
]

{ #category : 'tests' }
HOPNodeTest >> testAddSubTree [
	| node1 node2 |
	node1 := (#root1 /+ #foo /+ #bar) root.
	node2 := (#root2 /+ #one /+ #two) root.
	node1 /+ node2.
	self assert: (node1 / #foo) name  equals: #foo.
	self assert: (node1 / #root2 / #one) name equals: #one.
	
]

{ #category : 'tests' }
HOPNodeTest >> testAddUriSpace [ 
	| node |
	node := (#root /+ (HOPTestUriSpaceApi named: #api)) root.
	self assert: node nodes size equals: 1.
	self assert: (node nodes anySatisfy: [ :each | each name = #api ])

]

{ #category : 'tests' }
HOPNodeTest >> testAddVariableNode [ 
	| node |
	node := #root /+ [ :foo| ].
	self assert: node name equals: #foo.
	self assert: node root name equals: #root
	
]

{ #category : 'tests' }
HOPNodeTest >> testCatchAllConsumesAllOfPath [
	| root catchall |
	root := (#root /+ (HOPCatchAllSegment named: #onelevel)) root.
	catchall := root / #onelevel / #one / #two / #three.
	self assert: catchall name equals: #onelevel.
	

]

{ #category : 'tests' }
HOPNodeTest >> testConversionBlock [
	| node |
	node := [ :foo| #foo asHOPSegment ] asHOPSegment.
	self assert: node class equals: HOPPluggableSegment 
]

{ #category : 'tests' }
HOPNodeTest >> testConversionSymbol [
	| node |
	node := #foo asHOPSegment.
	self assert: node class equals: HOPNamedSegment.
	self assert: node name equals: #foo
]

{ #category : 'tests' }
HOPNodeTest >> testLookupMatchesNameBeforeVariable [
	| root |
	root := (#root /+ {  
		(HOPVariableSegment new name: #notfoo ).
		#foo 
		}) root.
	self assert: (root / #foo) name  equals: #foo.

]

{ #category : 'tests' }
HOPNodeTest >> testLookupNameNode [
	| node |
	node := (#root /+ #foo /+ #bar) root.
	self assert: (node / #foo) name  equals: #foo.
	self assert: (node / #foo / #bar) name equals: #bar.
	
]
