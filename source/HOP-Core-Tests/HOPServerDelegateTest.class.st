Class {
	#name : 'HOPServerDelegateTest',
	#superclass : 'TestCase',
	#instVars : [
		'uriSpace'
	],
	#category : 'HOP-Core-Tests',
	#package : 'HOP-Core-Tests'
}

{ #category : 'tests' }
HOPServerDelegateTest >> testComposed [ 
	| root matcher matched request response |
	root := HOPTestUriSpaceComposed new build.
	matcher := root newRouteMatcher .
	request := ZnRequest get: 'api/objects/1234' asZnUrl.
	matched := matcher matchRequest: request.
	self assert: (matched variableAt: #objectId) equals: '1234'.
	response := matched handle.
	self assert: response status equals: 200
]

{ #category : 'tests' }
HOPServerDelegateTest >> testHandleRequest [ 
	| request delegate response |
	request := ZnRequest get: '/api/1234/items/5678'.
	delegate := HOPServerDelegate new uriSpace: self uriSpace.
	response := delegate handleRequest: request.
	self assert: response status equals: 200
]

{ #category : 'accessing' }
HOPServerDelegateTest >> uriSpace [ 
	^ uriSpace ifNil: [
		uriSpace := HOPTestUriSpace new build ]
]
