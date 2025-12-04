Class {
	#name : 'HOPPluggableSegment',
	#superclass : 'HOPSegment',
	#instVars : [
		'block'
	],
	#category : 'HOP-Core',
	#package : 'HOP-Core'
}

{ #category : 'accessing' }
HOPPluggableSegment >> block [

	^ block
]

{ #category : 'accessing' }
HOPPluggableSegment >> block: anObject [

	block := anObject
]

{ #category : 'printing' }
HOPPluggableSegment >> nodeLabel [
	^ 'pluggable'
]

{ #category : 'accessing' }
HOPPluggableSegment >> priority [ 
	^ 3
]
