Class {
	#name : 'HOPUriBuilderTest',
	#superclass : 'TestCase',
	#category : 'HOP-Core-Tests-Tests',
	#package : 'HOP-Core-Tests',
	#tag : 'Tests'
}

{ #category : 'tests' }
HOPUriBuilderTest >> testBuildSimple [ 
	| space objectSegment uri object |
	objectSegment := HOPVariableSegment new
		name: #objectId;
		segmentNameSelector: #id.
	object := HOPUriBuildChildObject new container: HOPUriBuildObject new.
	space := (#api asHOPSegment /+ #objects /+ objectSegment /+ #children) asHOPUriSpace.
	self halt.
	uri := space buildUriForResource: object startingAt: space segments last. 
	self halt.
]
