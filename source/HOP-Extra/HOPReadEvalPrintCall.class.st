Class {
	#name : 'HOPReadEvalPrintCall',
	#superclass : 'HOPCall',
	#category : 'HOP-Extra',
	#package : 'HOP-Extra'
}

{ #category : 'execution' }
HOPReadEvalPrintCall >> evaluate: expression [
	| output |
	output := String streamContents: [ :stream |
		[ 
			stream << (self class compiler evaluate: expression) asString ]
			on: Error
			do: [ :exception |
				stream print: exception; cr.
				exception signalerContext printDetails: stream.
				exception signalerContext sender debugStack: 8 on: stream ] ].
	^ output copyReplaceAll: String cr with: String lf 
]

{ #category : 'execution' }
HOPReadEvalPrintCall >> execute [ 
	^ ZnResponse ok: (ZnEntity text: (self evaluate: routeMatch request entity contents)) 
	
]

{ #category : 'execution' }
HOPReadEvalPrintCall >> handleRouteMatch: aRouteMatch [  
	^ ZnResponse ok: (ZnEntity text: (self evaluate: aRouteMatch request entity contents)) 
	
]
