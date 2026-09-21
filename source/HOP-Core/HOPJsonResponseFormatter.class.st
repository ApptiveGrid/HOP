Class {
	#name : 'HOPJsonResponseFormatter',
	#superclass : 'Object',
	#category : 'HOP-Core',
	#package : 'HOP-Core'
}

{ #category : 'formatting' }
HOPJsonResponseFormatter >> format: responseObject [ 
	"STONJSON rather than NeoJSONWriter, and the reason is not taste: HOP-Core reached for a
	class its own baseline never declared. Neo-JSON came along behind JSONSchema, so the day a
	load did not bring JSONSchema this method read an undeclared variable - which is exactly
	how it showed up. STON-Core is in the image Pharo ships.

	The wire format does not move. Checked against the same payload: STONJSON toStringPretty:
	and NeoJSONWriter toStringPretty: write the same characters, and each reads the other's
	output."
	^	ZnStringEntity json: (STONJSON toStringPretty: {
			#code -> responseObject statusCode.
			#type -> responseObject exceptionType.
			#message -> responseObject hopMessageObject
		} asDictionary )
]
