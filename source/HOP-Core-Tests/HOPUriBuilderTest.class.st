Class {
	#name : 'HOPUriBuilderTest',
	#superclass : 'TestCase',
	#category : 'HOP-Core-Tests-Tests',
	#package : 'HOP-Core-Tests',
	#tag : 'Tests'
}

{ #category : 'tests' }
HOPUriBuilderTest >> testABuildLinkFollowsTheHolderOfTheResource [
	"the operation hangs at each of the segments the class is canonical at, so its link
	leads to the one of the holder"
	| uriSpace item link |
	uriSpace := self uriSpaceWithItemsUnderTwoHolders.
	item := HOPUriBuildItem new container: HOPUriBuildOtherObject new.
	link := uriSpace newUriBuilder 
		resource: item; 
		operation: HOPTestOperationMapping; 
		buildLink.
	self assert: link href equals: '/api/others/9/items/3/entries'.
	self assert: link method equals: #post.
	item container: HOPUriBuildObject new.
	link := uriSpace newUriBuilder 
		resource: item; 
		operation: HOPTestOperationMapping; 
		buildLink.
	self assert: link href equals: '/api/objects/1/items/3/entries'
]

{ #category : 'tests' }
HOPUriBuilderTest >> testAClassAtSeveralSegmentsBuildsTheUriOfItsHolder [
	| uriSpace item |
	uriSpace := self uriSpaceWithItemsUnderTwoHolders.
	item := HOPUriBuildItem new container: HOPUriBuildObject new.
	self 
		assert: (uriSpace buildUriForResource: item) 
		equals: '/api/objects/1/items/3'.
	item container: HOPUriBuildOtherObject new.
	self 
		assert: (uriSpace buildUriForResource: item) 
		equals: '/api/others/9/items/3'
]

{ #category : 'tests' }
HOPUriBuilderTest >> testAClassAtSeveralSegmentsIsAmbiguousUnderTheSameHolderClass [
	| uriSpace api |
	api := #api asHOPSegment.
	uriSpace := (HOPUriSpace /+ api) root.
	api /+ #objects /+ (self variable: #objectId resolving: HOPUriBuildObject) /+ #items /+ (self variable: #itemId resolving: HOPUriBuildItem).
	api /+ #mirror /+ (self variable: #mirrorId resolving: HOPUriBuildObject) /+ #items /+ (self variable: #itemId resolving: HOPUriBuildItem).
	uriSpace buildInstanceMap.
	self 
		should: [ uriSpace buildUriForResource: (HOPUriBuildItem new container: HOPUriBuildObject new) ]
		raise: Error
]

{ #category : 'tests' }
HOPUriBuilderTest >> testAClassAtSeveralSegmentsNeedsAHolderThatFits [
	| uriSpace |
	uriSpace := self uriSpaceWithItemsUnderTwoHolders.
	self 
		should: [ uriSpace buildUriForResource: HOPUriBuildItem new ]
		raise: Error.
	self 
		should: [ uriSpace buildUriForResource: (HOPUriBuildItem new container: HOPUriBuildChildObject new) ]
		raise: Error
]

{ #category : 'tests' }
HOPUriBuilderTest >> testAClassAtSeveralSegmentsCannotBeAskedWithoutAResource [
	| uriSpace |
	uriSpace := self uriSpaceWithItemsUnderTwoHolders.
	self 
		should: [ uriSpace segmentForResourceType: HOPUriBuildItem ]
		raise: Error.
	self 
		assert: (uriSpace segmentForResourceType: HOPUriBuildObject) name
		equals: #objectId
]

{ #category : 'tests' }
HOPUriBuilderTest >> testAChildOfAResourceAtSeveralSegmentsFollowsTheHolderTwoLevelsUp [
	"the child's own container is the item at both of its segments, so only the chain up to
	the holder tells them apart"
	| uriSpace item |
	uriSpace := self uriSpaceWithItemsUnderTwoHolders.
	item := HOPUriBuildItem new container: HOPUriBuildOtherObject new.
	self 
		assert: (uriSpace buildUriForResource: (HOPUriBuildChildObject new container: item)) 
		equals: '/api/others/9/items/3/children/2'.
	item container: HOPUriBuildObject new.
	self 
		assert: (uriSpace buildUriForResource: (HOPUriBuildChildObject new container: item)) 
		equals: '/api/objects/1/items/3/children/2'
]

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
HOPUriBuilderTest >> uriSpaceWithItemsUnderTwoHolders [
	"items have their canonical place under objects and under others, below an item hang
	its children and an operation"
	| api uriSpace |
	api := #api asHOPSegment.
	uriSpace := (HOPUriSpace /+ api) root.
	{ #objects -> HOPUriBuildObject . #others -> HOPUriBuildOtherObject } do: [ :each | 
		| items |
		items := api /+ each key /+ (self variable: (each key , 'Id') asSymbol resolving: each value) /+ #items /+ (self variable: #itemId resolving: HOPUriBuildItem).
		items /+ #children /+ (self variable: #childId resolving: HOPUriBuildChildObject).
		items /+ #entries @@ (#POST -> HOPTestOperationMapping) ].
	uriSpace 
		buildInstanceMap;
		buildOperationSegments.
	^ uriSpace
]

{ #category : 'running' }
HOPUriBuilderTest >> variable: aName resolving: aClass [
	^ HOPVariableSegment new 
		name: aName;
		segmentNameSelector: #id;
		resolveClass: aClass;
		beCanonical;
		yourself
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
