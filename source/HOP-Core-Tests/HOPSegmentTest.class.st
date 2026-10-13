Class {
	#name : 'HOPSegmentTest',
	#superclass : 'TestCase',
	#category : 'HOP-Core-Tests-Tests',
	#package : 'HOP-Core-Tests',
	#tag : 'Tests'
}

{ #category : 'tests' }
HOPSegmentTest >> testResolveClassIsShortForOneClass [

	| segment |
	segment := HOPVariableSegment new resolveClass: HOPUriSpaceTestClass1.
	self assert: segment resolveClasses equals: { HOPUriSpaceTestClass1 }.
	self
		assertCollection: segment instanceMapClasses
		hasSameElements: HOPUriSpaceTestClass1 hopExposedClasses
]

{ #category : 'tests' }
HOPSegmentTest >> testResolveClassesExposesEveryClass [

	| segment |
	segment := HOPVariableSegment new resolveClasses: {
			           HOPUriSpaceTestClass1.
			           HOPUriSpaceTestClass2 }.
	self assert: (segment instanceMapClasses includes: HOPUriSpaceTestClass1).
	self assert: (segment instanceMapClasses includes: HOPUriSpaceTestClass2)
]
