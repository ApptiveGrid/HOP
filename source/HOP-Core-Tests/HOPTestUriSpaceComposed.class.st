Class {
	#name : 'HOPTestUriSpaceComposed',
	#superclass : 'HOPUriSpace',
	#category : 'HOP-Core-Tests-TestData',
	#package : 'HOP-Core-Tests',
	#tag : 'TestData'
}

{ #category : 'accessing' }
HOPTestUriSpaceComposed >> apiSpace [
	^ HOPTestUriSpaceApi new 
		name: #api;
		addHandler: HOPRouteHandlerWrapper new.
]

{ #category : 'accessing' }
HOPTestUriSpaceComposed >> build [
	self /+ {
		self apiSpace.
		HOPTestUriSpaceAuth new name: #auth.
	}
]

{ #category : 'instance creation' }
HOPTestUriSpaceComposed >> newRouteMatch [
	^ HOPRouteMatch new 
		uriSpace: self 
]

{ #category : 'instance creation' }
HOPTestUriSpaceComposed >> newRouteMatcher [
	^ HOPRouteMatcher new 
		uriSpace: self;
		yourself.
]
