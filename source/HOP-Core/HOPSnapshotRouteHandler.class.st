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

	self withStreamDo: [ :stream |
		aRoute request writeOn: stream.
		stream 
			nextPutAll: String crlf utf8Encoded;
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
			do: [ :error | 
				stream nextPutAll: (String streamContents: [ :out |
					error signalerContext printDebugStackOn: out ]) utf8Encoded.
				stream flush.
				error pass  ]
		]
		ensure: [ 
			response ifNotNil: [  
				response writeOn: stream.
				stream flush ] ] ].
	^ response 
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
	"Ein Byte-Strom, denn ZnMessage>>writeOn: schreibt Bytes. Auf einem
	Zeichen-Strom kodiert der UTF-8-Encoder jedes Byte ueber 127 ein zweites
	Mal: aus C3 9F wird C3 83 C2 9F, aus 'Faassen' wird 'FaaAYen'. Der
	Mitschnitt wuerde dann laenger als sein eigenes Content-Length."
	| stream |
	stream := self filename binaryWriteStream.
	[ aBlock value: stream ]
		ensure: [ 
			stream 
				flush;
				close ]
]
