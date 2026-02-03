Class {
	#name : 'HOPSnapshotRouteHandler',
	#superclass : 'HOPRouteHandlerWrapper',
	#category : 'HOP-Core',
	#package : 'HOP-Core'
}

{ #category : 'accessing' }
HOPSnapshotRouteHandler >> filename [ 
	^ self path / ('SCIM-', DateAndTime now printString)
]

{ #category : 'as yet unclassified' }
HOPSnapshotRouteHandler >> handleRoute: aRoute [ 
	| response |
	(self loggingEnabled: aRoute) ifFalse: [ ^ super handleRoute: aRoute ].

	self withStreamDo: [ :stream |.
		aRoute request writeOn: stream.
		stream 
			nextPutAll: String crlf;
			flush.
		[
			[
				[ response := super handleRoute: aRoute ]
					on: ZnRespond 
					do: [ :err |
						response := err response. 
						err pass ]
			]
			on: Error 
			do: [ :error | error signalerContext printDebugStackOn: stream  ]
		]
		ensure: [ 
			response ifNotNil: [  
				response writeOn: stream ] ] ].
	^ response 
]

{ #category : 'as yet unclassified' }
HOPSnapshotRouteHandler >> loggingEnabled [ 
	^ self path exists
]

{ #category : 'as yet unclassified' }
HOPSnapshotRouteHandler >> loggingEnabled: aRoute [ 
	^ self path exists and: [ 
		aRoute request uri pathSegments first = 'scim' ]
]

{ #category : 'as yet unclassified' }
HOPSnapshotRouteHandler >> path [
	^ '/data/logs' asFileReference
]

{ #category : 'as yet unclassified' }
HOPSnapshotRouteHandler >> withStreamDo: aBlock [ 
	| stream |
	stream := self filename writeStream.
	[ aBlock value: stream ]
		ensure: [ 
			stream 
				flush;
				close ]
]
