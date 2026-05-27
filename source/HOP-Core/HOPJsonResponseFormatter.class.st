Class {
	#name : 'HOPJsonResponseFormatter',
	#superclass : 'Object',
	#category : 'HOP-Core',
	#package : 'HOP-Core'
}

{ #category : 'formatting' }
HOPJsonResponseFormatter >> format: responseObject [ 
	^	ZnStringEntity json: (NeoJSONWriter toStringPretty: {
			#code -> responseObject statusCode.
			#type -> responseObject exceptionType.
			#message -> responseObject hopMessageObject
		} asDictionary )
]
