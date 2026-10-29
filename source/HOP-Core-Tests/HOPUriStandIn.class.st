"
I stand in for another resource, the way a link or a hook gives access to a space: a route through me continues at the resource I stand for.
"
Class {
	#name : 'HOPUriStandIn',
	#superclass : 'HOPUriObject',
	#instVars : [
		'standsFor'
	],
	#category : 'HOP-Core-Tests-TestData',
	#package : 'HOP-Core-Tests',
	#tag : 'TestData'
}

{ #category : 'accessing' }
HOPUriStandIn >> extraReceiver [
	^ standsFor
]

{ #category : 'accessing' }
HOPUriStandIn >> id [
	^ '7'
]

{ #category : 'accessing' }
HOPUriStandIn >> standsFor: anObject [
	standsFor := anObject
]
