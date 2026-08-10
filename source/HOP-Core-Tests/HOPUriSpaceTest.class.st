Class {
	#name : 'HOPUriSpaceTest',
	#superclass : 'TestCase',
	#instVars : [
		'uriSpace'
	],
	#category : 'HOP-Core-Tests-Tests',
	#package : 'HOP-Core-Tests',
	#tag : 'Tests'
}

{ #category : 'instance creation' }
HOPUriSpaceTest >> newRouteMatcher [
	^ HOPRouteMatcher new 
		uriSpace: self uriSpace;
		yourself 
]

{ #category : 'tests' }
HOPUriSpaceTest >> testBuildUriSpace [ 
	self 
		shouldnt: [self uriSpace ]
		raise: Error
]

{ #category : 'tests' }
HOPUriSpaceTest >> testComposeUriSpace [ 
	| toMerge |
	uriSpace := self uriSpace.
	toMerge := (#api asHOPSegment /+ (HOPVariableSegment named:  #firstVariable) /+ #items /+ #foobar) asHOPUriSpace.
	uriSpace mergeNode: toMerge.
	self assert: ((uriSpace / #api / #firstVariable / #items) includesNodeNamed: #foobar)
	
]

{ #category : 'tests' }
HOPUriSpaceTest >> testRegisterSegmentAllowsDistinctOperationRegistrations [
    | space segment |
    space := HOPUriSpace new.
    segment := #testOp asHOPSegment
        atMethod: #get put: HOPTestOperationMapping;
        atMethod: #delete put: HOPTestOperationMapping new;
        yourself.
    space /+ segment.
    self shouldnt: [ space buildOperationSegments ] raise: Error
]

{ #category : 'tests' }
HOPUriSpaceTest >> testRegisterSegmentSignalsOnDuplicateOperationRegistration [
    "registerSegment:forResourceRoot:andOperation: used to silently overwrite a collision in
    operationSegments (last-registered node wins, order-dependent) - it should signal instead,
    analogous to the existing behaviorSegments collision check in buildInstanceMap."
    | space segment |
    space := HOPUriSpace new.
    segment := #testOp asHOPSegment
        atMethod: #get put: HOPTestOperationMapping;
        atMethod: #post put: HOPTestOperationMapping;
        yourself.
    space /+ segment.
    self should: [ space buildOperationSegments ] raise: Error
]

{ #category : 'tests' }
HOPUriSpaceTest >> testVariableSegment [ 
	| matcher value uri match |
	matcher := self newRouteMatcher.
	uri := '/api/first123/items/4321' asZnUrl.
	match := matcher matchUri: uri.
	value := match variableAt: #firstVariable.
	self assert: value equals: 'first123'.
	value := match variableAt: #secondVariable.
	self assert: value equals: '4321'
]

{ #category : 'tests' }
HOPUriSpaceTest >> uriSpace [ 
	^ uriSpace ifNil: [
		uriSpace := HOPTestUriSpace new build ]
]
