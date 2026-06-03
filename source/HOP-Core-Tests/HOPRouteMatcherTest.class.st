Class {
	#name : 'HOPRouteMatcherTest',
	#superclass : 'TestCase',
	#instVars : [
		'uriSpace'
	],
	#category : 'HOP-Core-Tests-Tests',
	#package : 'HOP-Core-Tests',
	#tag : 'Tests'
}

{ #category : 'tests' }
HOPRouteMatcherTest >> testMatchRoute [ 
	| matcher match |
	self uriSpace.
	matcher := self uriSpace newRouteMatcher.
	match := matcher matchUri: '/api/first123/items/4321' asZnUrl.
	self assert: match receiverNode name equals: #secondVariable
]

{ #category : 'accessing' }
HOPRouteMatcherTest >> uriSpace [ 
	^ uriSpace ifNil: [
		uriSpace := HOPTestUriSpace new build ]
]
