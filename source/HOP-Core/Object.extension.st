Extension { #name : 'Object' }

{ #category : '*HOP-Core' }
Object >> addToHOPNode: aNode [ 
	^ aNode addSegment: self asHOPSegment
]

{ #category : '*HOP-Core' }
Object >> extraReceiver [
	"the object a route continues to resolve its extra path at, see
	HOPResourceRoute>>matchExtraPath. By default it is the receiver itself; a resource
	that stands for another one (a link or a hook for the space it gives access to)
	answers that one"

	^ self
]

{ #category : '*HOP-Core' }
Object >> hopOperation [
	"the operation a method entry of a segment stands for, if any. The uri space registers
	the segment under it so a uri for that operation can be built back. Any object can be
	an entry; one that answers an operation here takes part, see HOPOperationMapping"

	^ nil
]

{ #category : '*HOP-Core' }
Object class >> hopExposedClasses [

	^ self withAllSubclasses
]
