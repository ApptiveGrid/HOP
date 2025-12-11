Class {
	#name : 'HOPBodyParameter',
	#superclass : 'HOPParameterLocation',
	#category : 'HOP-Core',
	#package : 'HOP-Core'
}

{ #category : 'as yet unclassified' }
HOPBodyParameter >> readFromRequest: aRequest [

	aRequest hasEntity ifFalse: [ 
		HOPParameterConstraintsError signal: 'request has no body'  ].
	^ aRequest contents
]
