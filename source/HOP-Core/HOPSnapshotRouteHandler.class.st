Class {
	#name : 'HOPSnapshotRouteHandler',
	#superclass : 'HOPRouteHandlerWrapper',
	#category : 'HOP-Core',
	#package : 'HOP-Core'
}

{ #category : 'as yet unclassified' }
HOPSnapshotRouteHandler >> handleRoute: aRoute [ 
	| id stream response |
	'/data/logs' asFileReference exists 
		ifTrue: [  
			id := DateAndTime now printString.
			stream := ('requests' asFileReference / id) writeStream.
			stream 
				nextPutAll: 'REQUEST';
				nextPutAll: String crlf.
			aRoute request writeOn: stream.
			stream 
				nextPutAll: String crlf;
				flush.
			[[ response := super handleRoute: aRoute ]
				on: ZnRespond 
				do: [ :err |
					response := err response. 
					err pass ]]
				ensure: [ 
					response ifNotNil: [  
						response writeOn: stream ].
					stream 
						flush;
						close ].
			^ response ]
		ifFalse: [ 
			^ super handleRoute: aRoute ]
]
