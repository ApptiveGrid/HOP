"
A uri space whose tree carries an operation, so a test can see the space find its way back to it after build.
"
Class {
	#name : 'HOPTestUriSpaceOperations',
	#superclass : 'HOPUriSpace',
	#category : 'HOP-Core-Tests-TestData',
	#package : 'HOP-Core-Tests',
	#tag : 'TestData'
}

{ #category : 'building' }
HOPTestUriSpaceOperations >> buildTree [
	self /+ #api /+ #items @@ (#POST -> HOPTestOperationMapping)
]
