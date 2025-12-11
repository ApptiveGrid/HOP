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
HOPUriSpaceTest >> testVariableSegment [ 
	| matcher value uri |
	matcher := self newRouteMatcher.
	uri := '/api/first123/items/4321' asZnUrl.
	matcher matchUri: uri.
	value := matcher valueAt: #firstVariable.
	self assert: value equals: 'first123'.
	value := matcher valueAt: #secondVariable.
	self assert: value equals: '4321'
]

{ #category : 'tests' }
HOPUriSpaceTest >> uriSpace [ 
	^ uriSpace ifNil: [
		uriSpace := HOPTestUriSpace new build ]
]
