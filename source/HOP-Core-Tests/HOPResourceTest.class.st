Class {
	#name : 'HOPResourceTest',
	#superclass : 'TestCase',
	#instVars : [
		'uriSpace'
	],
	#category : 'HOP-Core-Tests-Tests',
	#package : 'HOP-Core-Tests',
	#tag : 'Tests'
}

{ #category : 'tests' }
HOPResourceTest >> testMatchRoute [ 
	| matcher node |
	self uriSpace.
	matcher := self uriSpace newRouteMatcher.
	matcher uri: '/api/first123/items/4321' asZnUrl.
	node := matcher findRoute.
	self assert: node name equals: #secondVariable
]

{ #category : 'accessing' }
HOPResourceTest >> uriSpace [ 
	^ uriSpace ifNil: [
		uriSpace := HOPTestUriSpace new build ]
]
