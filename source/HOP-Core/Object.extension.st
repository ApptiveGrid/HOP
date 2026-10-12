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
Object class >> hopExposedClasses [

	^ self withAllSubclasses
]
