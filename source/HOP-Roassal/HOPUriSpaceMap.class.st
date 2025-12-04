Class {
	#name : 'HOPUriSpaceMap',
	#superclass : 'Object',
	#instVars : [
		'root',
		'canvas',
		'builder',
		'nodes',
		'shapeMap'
	],
	#category : 'HOP-Roassal',
	#package : 'HOP-Roassal'
}

{ #category : 'instance creation' }
HOPUriSpaceMap class >> openOn: aRootNode [
    ^ self new
        root: aRootNode;
        open;
        yourself
]

{ #category : 'accessing' }
HOPUriSpaceMap >> applyLayout [
	"RSHorizontalLineLayout on: shapeMap values."
	"RSNormalizer size
		shapes: shapeMap values;
		normalize: #numberOfChildren."

    RSTreeLayout new 
		applyOn: nodes.

   nodes do: [ :shape |
        | p |
        p := shape position.
        shape position: p y @ p x ].
]

{ #category : 'accessing' }
HOPUriSpaceMap >> buildCanvas [
    canvas := RSCanvas new.
    self buildNodesAndEdges.
    self applyLayout
]

{ #category : 'accessing' }
HOPUriSpaceMap >> buildNodesAndEdges [
    | allModels eb |
    allModels := self collectAllNodesFrom: root.

    shapeMap := Dictionary new.
    nodes := OrderedCollection new.

    allModels do: [ :each |
        | label |
        label := RSLabel new
            model: each;
            text: each displayLabel;
            "padding: 5;"
            yourself.
        shapeMap at: each put: label.
        nodes add: label ].

    canvas addAll: nodes.
    "self connectEdgesWith: shapeMap"
	eb := RSLineBuilder orthoVertical.
	eb withVerticalAttachPoint.
	eb shapes: shapeMap values .
	eb connectFrom: #parent.
]

{ #category : 'accessing' }
HOPUriSpaceMap >> collectAllNodesFrom: aNode [
    | result |
    result := OrderedCollection new.
    self collectAllNodesFrom: aNode into: result.
    ^ result asArray
]

{ #category : 'accessing' }
HOPUriSpaceMap >> collectAllNodesFrom: aNode into: aCollection [
    aCollection add: aNode.
    aNode children do: [ :each |
        self collectAllNodesFrom: each into: aCollection ]
]

{ #category : 'accessing' }
HOPUriSpaceMap >> connectEdgesWith: aShapeMap [
    | allModels |
    allModels := aShapeMap keys.
    allModels do: [ :node |
        node children do: [ :child |
            | fromShape toShape line |
            fromShape := aShapeMap at: node.
            toShape   := aShapeMap at: child.

            line := RSLine new
                from: fromShape;
                to: toShape;
                yourself.

            canvas add: line ] ]
]

{ #category : 'accessing' }
HOPUriSpaceMap >> open [
    self buildCanvas.
    canvas @ RSCanvasController.  "Zoom, Pan, etc."
    canvas open
]

{ #category : 'accessing' }
HOPUriSpaceMap >> root: aRootNode [
    root := aRootNode
]
