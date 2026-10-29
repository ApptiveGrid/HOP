Class {
	#name : 'HOPTestUriSpaceAuth',
	#superclass : 'HOPUriSpace',
	#category : 'HOP-Core-Tests-TestData',
	#package : 'HOP-Core-Tests',
	#tag : 'TestData'
}

{ #category : 'accessing' }
HOPTestUriSpaceAuth >> buildTree [
	self /+ #realm asHOPSegment /+ #authorize 
]
