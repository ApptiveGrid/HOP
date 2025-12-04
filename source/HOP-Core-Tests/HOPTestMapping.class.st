Class {
	#name : 'HOPTestMapping',
	#superclass : 'Object',
	#category : 'HOP-Core-Tests-TestData',
	#package : 'HOP-Core-Tests',
	#tag : 'TestData'
}

{ #category : 'instance creation' }
HOPTestMapping >> asHOPRouteHandler [
	^ HOPTestCall new 
]
