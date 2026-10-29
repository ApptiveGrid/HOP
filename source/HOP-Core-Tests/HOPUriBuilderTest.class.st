Class {
	#name : 'HOPUriBuilderTest',
	#superclass : 'TestCase',
	#category : 'HOP-Core-Tests-Tests',
	#package : 'HOP-Core-Tests',
	#tag : 'Tests'
}

{ #category : 'tests' }
HOPUriBuilderTest >> testBuildLinkForOperation [
	"the link carries the method the operation hangs at, the way a request reaches it"
	| uriSpace objectSegment object link |
	objectSegment := HOPVariableSegment new
		name: #objectId;
		segmentNameSelector: #id.
	uriSpace := (HOPUriSpace /+ #api asHOPSegment /+ #objects /+ objectSegment --> HOPUriBuildObject /+ #children @@ (#POST -> HOPTestOperationMapping)) root.
	uriSpace buildOperationSegments.
	object := HOPUriBuildObject new.
	link := uriSpace newUriBuilder 
		resource: object; 
		operation: HOPTestOperationMapping; 
		buildLink.
	self assert: link href equals: '/api/objects/1/children'.
	self assert: link method equals: #post
]

{ #category : 'tests' }
HOPUriBuilderTest >> testBuildLinkForResource [
	| uriSpace objectSegment link |
	objectSegment := HOPVariableSegment new
		name: #objectId;
		segmentNameSelector: #id.
	uriSpace := (HOPUriSpace /+ #api asHOPSegment /+ #objects /+ objectSegment --> HOPUriBuildObject) root.
	link := uriSpace newUriBuilder resource: HOPUriBuildObject new; buildLink.
	self assert: link href equals: '/api/objects/1'.
	self assert: link method isNil
]

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

{ #category : 'tests' }
HOPUriBuilderTest >> testBuildUriForResourceInAMountedUriSpace [
	"a uri space mounted under a name is a named segment of the space it hangs in"
	| uriSpace mounted objectSegment childSegment object uri |
	objectSegment := HOPVariableSegment new
		name: #objectId;
		segmentNameSelector: #id.
	childSegment := HOPVariableSegment new
		name: #childId;
		segmentNameSelector: #id.
	mounted := HOPUriSpace new
		name: #mounted;
		yourself.
	uriSpace := (HOPUriSpace /+ mounted) root.
	mounted /+ #objects /+ objectSegment --> HOPUriBuildObject /+ #children /+ childSegment --> HOPUriBuildChildObject.
	object := HOPUriBuildChildObject new container: HOPUriBuildObject new.
	uri := uriSpace buildUriForResource: object.
	self assert: uri equals: '/mounted/objects/1/children/2'
]

{ #category : 'tests' }
HOPUriBuilderTest >> testBuildUriForResourceThroughAStandIn [
	"an object below the resource a stand-in gives access to keeps the stand-in's uri as its
	prefix when the request came through the stand-in"
	| uriSpace route object child |
	uriSpace := self uriSpaceWithStandIn.
	object := HOPUriBuildObject new.
	child := HOPUriBuildChildObject new container: object.
	route := (HOPTestResourceRoute new
		routeMatch: (uriSpace newRouteMatcher matchUri: '/api/standins/7' asZnUrl);
		standIn: (HOPUriStandIn new standsFor: object);
		yourself).
	self 
		assert: (uriSpace newUriBuilder resource: child; resourceRoute: route; build)
		equals: '/api/standins/7/children/2'.
	self 
		assert: (uriSpace newUriBuilder resource: child; build)
		equals: '/api/objects/1/children/2'
]

{ #category : 'tests' }
HOPUriBuilderTest >> testBuildUriOutsideTheScopeOfTheRoute [
	"a resource the stand-in does not lead to is built the canonical way"
	| uriSpace route child |
	uriSpace := self uriSpaceWithStandIn.
	child := HOPUriBuildChildObject new container: HOPUriBuildObject new.
	route := (HOPTestResourceRoute new
		routeMatch: (uriSpace newRouteMatcher matchUri: '/api/standins/7' asZnUrl);
		standIn: (HOPUriStandIn new standsFor: HOPUriBuildObject new);
		yourself).
	self 
		assert: (uriSpace newUriBuilder resource: child; resourceRoute: route; build)
		equals: '/api/objects/1/children/2'
]

{ #category : 'running' }
HOPUriBuilderTest >> uriSpaceWithStandIn [
	"objects have their canonical place under /api/objects, a stand-in for one of them lives
	under /api/standins"
	| api uriSpace |
	api := #api asHOPSegment.
	uriSpace := (HOPUriSpace /+ api) root.
	api /+ #objects /+ (HOPVariableSegment new name: #objectId; segmentNameSelector: #id; yourself) --> HOPUriBuildObject 
		/+ #children /+ (HOPVariableSegment new name: #childId; segmentNameSelector: #id; yourself) --> HOPUriBuildChildObject.
	api /+ #standins /+ (HOPVariableSegment new name: #standInId; segmentNameSelector: #id; resourceSelector: #standIn; yourself) --> HOPUriStandIn.
	^ uriSpace
]
