Class {
	#name : 'HOPTestSnapshotRouteHandler',
	#superclass : 'HOPSnapshotRouteHandler',
	#instVars : [
		'testPath'
	],
	#category : 'HOP-Core-Tests-Tests',
	#package : 'HOP-Core-Tests',
	#tag : 'Tests'
}

{ #category : 'accessing' }
HOPTestSnapshotRouteHandler >> path [
	"Statt /data/logs, damit ein Test den Mitschnitt wieder einlesen kann."
	^ testPath
]

{ #category : 'accessing' }
HOPTestSnapshotRouteHandler >> path: aFileReference [
	testPath := aFileReference
]
