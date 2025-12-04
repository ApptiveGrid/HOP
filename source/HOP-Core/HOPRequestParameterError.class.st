Class {
	#name : 'HOPRequestParameterError',
	#superclass : 'Error',
	#category : 'HOP-Core-Errors',
	#package : 'HOP-Core',
	#tag : 'Errors'
}

{ #category : 'accessing' }
HOPRequestParameterError class >> neoJsonMapping: mapper [
	mapper for: self do: [ :mapping |
		mapping mapAccessor: #typeLabel to: #error.
		mapping mapAccessor: #messageText to: #description ].

]

{ #category : 'as yet unclassified' }
HOPRequestParameterError >> typeLabel [
	^ 'GenericError'
]
