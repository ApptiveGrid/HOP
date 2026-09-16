Class {
	#name : 'HOPSnapshotRouteHandlerTest',
	#superclass : 'TestCase',
	#instVars : [
		'uriSpace',
		'directory'
	],
	#category : 'HOP-Core-Tests-Tests',
	#package : 'HOP-Core-Tests',
	#tag : 'Tests'
}

{ #category : 'running' }
HOPSnapshotRouteHandlerTest >> setUp [ 
	super setUp.
	directory := (FileLocator temp / ('hop-snapshot-', UUID new asString36)) ensureCreateDirectory.
	uriSpace := (HOPUriSpace /+ #scim) root.
	uriSpace / #scim @@ (#POST -> (HOPPluggableHandler new block: [ :req | #ok ])).
	uriSpace addHandler: (HOPTestSnapshotRouteHandler new path: directory; yourself)
]

{ #category : 'running' }
HOPSnapshotRouteHandlerTest >> tearDown [ 
	directory ifNotNil: [ directory ensureDeleteAll ].
	super tearDown
]

{ #category : 'tests' }
HOPSnapshotRouteHandlerTest >> testSnapshotKeepsTheBytesOnTheWire [
	"Der Mitschnitt gibt die Bytes des Requests unveraendert wieder. Auf einem
	Zeichen-Strom kodiert der UTF-8-Encoder jedes Byte ueber 127 ein zweites
	Mal - aus C3 9F wird C3 83 C2 9F, und der Rumpf enthaelt dann nicht mehr,
	was der Client geschickt hat."
	| body request snapshot |
	body := '{"familyName":"Faaßen"}'.
	request := (ZnRequest post: #scim) 
		entity: (ZnEntity with: body type: ZnMimeType applicationJson);
		yourself.
	uriSpace asZincDelegate handleRequest: request.
	snapshot := ZnCharacterEncoder utf8 decodeBytes: 
		(directory files detect: [ :each | each basename beginsWith: 'SCIM-' ]) binaryReadStream upToEnd.
	self 
		assert: (snapshot includesSubstring: body)
		description: 'Der Mitschnitt gibt den Rumpf nicht Byte fuer Byte wieder'
]
