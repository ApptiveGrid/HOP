Class {
	#name : 'HOPTestUriSpace',
	#superclass : 'HOPUriSpace',
	#category : 'HOP-Core-Tests-TestData',
	#package : 'HOP-Core-Tests',
	#tag : 'TestData'
}

{ #category : 'building' }
HOPTestUriSpace >> build [ 

	self /+ #api
		/+ (self firstVariable)
			/+ #items 
				/+ (self secondVariable) @@ (#GET -> HOPTestMapping new)
]

{ #category : 'building' }
HOPTestUriSpace >> firstVariable [
	^ HOPVariableSegment new 
		name: #firstVariable;
		resolveClass: HOPUriSpaceTestClass1
]

{ #category : 'instance creation' }
HOPTestUriSpace >> newRequestContext [ 
	^ HOPRouteMatch new 
		uriSpace: self 
]

{ #category : 'instance creation' }
HOPTestUriSpace >> newRouteMatch [
	^ HOPRouteMatch new 
		uriSpace: self 
]

{ #category : 'instance creation' }
HOPTestUriSpace >> newRouteMatcher [
	^ HOPRouteMatcher new 
		uriSpace: self;
		yourself.
]

{ #category : 'instance creation' }
HOPTestUriSpace >> newUriResolver [
	^ HOPRouteMatcher new 
		uriSpace: self;
		yourself 
]

{ #category : 'building' }
HOPTestUriSpace >> secondVariable [
	^ HOPVariableSegment new 
		name: #secondVariable;
		resolveClass: HOPUriSpaceTestClass2
]
