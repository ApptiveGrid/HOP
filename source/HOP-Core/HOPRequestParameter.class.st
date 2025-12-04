Class {
	#name : 'HOPRequestParameter',
	#superclass : 'Object',
	#instVars : [
		'name',
		'in',
		'description',
		'required',
		'defaultValue',
		'deprecated',
		'allowEmptyValue',
		'style',
		'explode',
		'allowReserved',
		'schema',
		'example',
		'examples',
		'content',
		'accessor',
		'writeUsingAccessors',
		'constraints',
		'location'
	],
	#category : 'HOP-Core',
	#package : 'HOP-Core'
}

{ #category : 'visiting' }
HOPRequestParameter >> acceptOpenApi: aVisitor [ 
	^ aVisitor visitParameter: self
]

{ #category : 'accessing' }
HOPRequestParameter >> addConstraint: aBlock [
	constraints add: aBlock
]

{ #category : 'adding' }
HOPRequestParameter >> addConstraint: aBlock label: aString [
	constraints add: { aBlock . aString }
]

{ #category : 'accessing' }
HOPRequestParameter >> allowEmptyValue [
	^ allowEmptyValue
]

{ #category : 'accessing' }
HOPRequestParameter >> allowEmptyValue: anObject [
	allowEmptyValue := anObject
]

{ #category : 'accessing' }
HOPRequestParameter >> allowReserved [
	^ allowReserved
]

{ #category : 'accessing' }
HOPRequestParameter >> allowReserved: anObject [
	allowReserved := anObject
]

{ #category : 'accessing' }
HOPRequestParameter >> beBoolean [
	schema := JSONSchema boolean
]

{ #category : 'accessing' }
HOPRequestParameter >> beInteger [
	schema := JSONSchema integer
]

{ #category : 'accessing' }
HOPRequestParameter >> beString [
	schema := JSONSchema string
]

{ #category : 'accessing' }
HOPRequestParameter >> beStringFormattedAs: aString [
	schema := JSONSchema string
		formatString: aString
]

{ #category : 'accessing' }
HOPRequestParameter >> content [
	^ content
]

{ #category : 'accessing' }
HOPRequestParameter >> content: anObject [
	content := anObject
]

{ #category : 'as yet unclassified' }
HOPRequestParameter >> copyFrom: aDictionary to: aBuilder [ 
	(aDictionary includesKey: name)
		ifTrue: [ location write: name value: (aDictionary at: name) to: aBuilder ]
		ifFalse: [ 
			required ifTrue: [ (HOPMissingRequiredParameter parameter: name) signal ] ] 
]

{ #category : 'accessing' }
HOPRequestParameter >> defaultValue [

	^ defaultValue
]

{ #category : 'accessing' }
HOPRequestParameter >> defaultValue: anObject [

	defaultValue := anObject
]

{ #category : 'accessing' }
HOPRequestParameter >> deprecated [
	^ deprecated
]

{ #category : 'accessing' }
HOPRequestParameter >> description [
	^ description
]

{ #category : 'accessing' }
HOPRequestParameter >> description: anObject [
	description := anObject
]

{ #category : 'accessing' }
HOPRequestParameter >> in [
	^ in
]

{ #category : 'accessing' }
HOPRequestParameter >> in: aStringOrSymbol [
	in := aStringOrSymbol.
	location := ({(#path -> HOPPathParameter).
	(#query -> HOPQueryParameter).
	(#header -> HOPHeaderParameter).
	(#cookie -> HOPCookieParameter).
	(#body -> HOPBodyParameter) } asDictionary at: aStringOrSymbol asSymbol) of: self.

	"Parameters from path are required"
	in = #path
		ifTrue: [ required := true ].
]

{ #category : 'initialization' }
HOPRequestParameter >> initialize [
	super initialize.
	constraints := Set new.
	deprecated := false.
	allowEmptyValue := false.
	required := false.
	allowReserved := false.
	writeUsingAccessors := false.
]

{ #category : 'as yet unclassified' }
HOPRequestParameter >> location [
	^ location
]

{ #category : 'accessing' }
HOPRequestParameter >> name [
	^ name
]

{ #category : 'accessing' }
HOPRequestParameter >> name: anObject [
	name := anObject
]

{ #category : 'printing' }
HOPRequestParameter >> printOn: aStream [
	aStream << 'OAParameter name: ' << name << ', in: ' << in
]

{ #category : 'as yet unclassified' }
HOPRequestParameter >> read: aString [ 
	^ schema readString: aString
]

{ #category : 'accessing' }
HOPRequestParameter >> readFromRequest: aRequest [
	| value |
	value := [location readFromRequest: aRequest]  
		on: Error 
		do: [ :ex | HOPParameterInvalidFormat signal: ex description ].
	value ifNil: [ 
		required ifTrue: [ ^ (HOPMissingRequiredParameter parameter: name) signal ].
		defaultValue ifNotNil: [ ^ defaultValue ].
		^ nil  ].
	self validateContraints: value.
	^ value
]

{ #category : 'accessing' }
HOPRequestParameter >> required [
	^ required
]

{ #category : 'accessing' }
HOPRequestParameter >> required: anObject [
	required := anObject
]

{ #category : 'accessing' }
HOPRequestParameter >> schema [
	^ schema
]

{ #category : 'accessing' }
HOPRequestParameter >> schema: anObject [
	schema := anObject
]

{ #category : 'asserting' }
HOPRequestParameter >> shouldUseAccessors [
	^ writeUsingAccessors
]

{ #category : 'accessing' }
HOPRequestParameter >> style [
	^ style
]

{ #category : 'accessing' }
HOPRequestParameter >> style: anObject [
	style := anObject
]

{ #category : 'accessing' }
HOPRequestParameter >> useAccessors [
	writeUsingAccessors := true
]

{ #category : 'as yet unclassified' }
HOPRequestParameter >> validate: anObject [
	schema ifNotNil: [ 
		schema validate: anObject ]
]

{ #category : 'validating' }
HOPRequestParameter >> validateContraints: value [
	constraints do: [ :constraint |
		((constraint first value: value) = true) ifFalse: [ 
			HOPParameterConstraintsError signal: value asString, 'violates constraint: ', constraint second ] ]
]
