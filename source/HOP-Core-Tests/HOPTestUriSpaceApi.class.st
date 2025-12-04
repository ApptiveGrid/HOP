Class {
	#name : 'HOPTestUriSpaceApi',
	#superclass : 'HOPUriSpace',
	#category : 'HOP-Core-Tests-TestData',
	#package : 'HOP-Core-Tests',
	#tag : 'TestData'
}

{ #category : 'accessing' }
HOPTestUriSpaceApi >> build [
	self /+ { 
		#objects /+ self objectVariable @@ (#GET -> HOPTestMapping new)
	} 
]

{ #category : 'accessing' }
HOPTestUriSpaceApi >> handler: aHOPRequestHandler [ 
self halt.
	handlers := aHOPRequestHandler 
]

{ #category : 'initialization' }
HOPTestUriSpaceApi >> initialize [ 
	super initialize.
	self build
]

{ #category : 'as yet unclassified' }
HOPTestUriSpaceApi >> objectVariable [ 
	^ HOPVariableSegment new 
		name: #objectId;
		resourceSelector: #object;
		resolveClass: Object
]
