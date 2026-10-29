"
I am the method entry of a segment for an operation. The uri space knows the segment by my operation, so a uri for it can be built back (see HOPUriSpace>>buildOperationSegments).

An entry does not have to be me: any object answering hopOperation takes part. I am the base an application can build its entries on.
"
Class {
	#name : 'HOPOperationMapping',
	#superclass : 'Object',
	#instVars : [
		'operation'
	],
	#category : 'HOP-Core',
	#package : 'HOP-Core'
}

{ #category : 'instance creation' }
HOPOperationMapping class >> operation: anOperation [
	^ self new 
		operation: anOperation;
		yourself
]

{ #category : 'converting' }
HOPOperationMapping >> asHOPRouteHandler [
	^ operation asHOPRouteHandler
]

{ #category : 'accessing' }
HOPOperationMapping >> hopOperation [
	^ operation
]

{ #category : 'accessing' }
HOPOperationMapping >> operation [
	^ operation
]

{ #category : 'accessing' }
HOPOperationMapping >> operation: anOperation [
	operation := anOperation
]
