Class {
	#name : 'HOPUriBuilderTest',
	#superclass : 'TestCase',
	#category : 'HOP-Core-Tests-Tests',
	#package : 'HOP-Core-Tests',
	#tag : 'Tests'
}

{ #category : 'tests' }
HOPUriBuilderTest >> testBuildUriForOperation [
	| uriSpace objectSegment uri object childSegment |
	objectSegment := HOPVariableSegment new
		name: #objectId;
		segmentNameSelector: #id.
	childSegment := HOPVariableSegment new
		name: #childId;
		segmentNameSelector: #id.
	uriSpace := (HOPUriSpace /+ #api asHOPSegment /+ #objects /+ objectSegment --> HOPUriBuildObject /+ #children @@ (#POST -> HOPTestOperationMapping)) root.
	uriSpace buildOperationSegments.
	object := HOPUriBuildChildObject new container: HOPUriBuildObject new.
	uri := uriSpace buildUriForOperation: HOPTestOperationMapping resource: object container . 
	self assert: uri equals: '/api/objects/1/children'
]

{ #category : 'tests' }
HOPUriBuilderTest >> testBuildUriForResource [
	| uriSpace objectSegment uri object childSegment |
	objectSegment := HOPVariableSegment new
		name: #objectId;
		segmentNameSelector: #id.
	childSegment := HOPVariableSegment new
		name: #childId;
		segmentNameSelector: #id.
	uriSpace := (HOPUriSpace /+ #api asHOPSegment /+ #objects /+ objectSegment --> HOPUriBuildObject /+ #children /+ childSegment --> HOPUriBuildChildObject ) root.
	object := HOPUriBuildChildObject new container: HOPUriBuildObject new.
	uri := uriSpace buildUriForResource: object. 
	self assert: uri equals: '/api/objects/1/children/2'
]
