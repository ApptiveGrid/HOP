Class {
	#name : 'BaselineOfHyperObjectPresentation',
	#superclass : 'BaselineOf',
	#category : 'BaselineOfHyperObjectPresentation',
	#package : 'BaselineOfHyperObjectPresentation'
}

{ #category : 'baselines' }
BaselineOfHyperObjectPresentation >> baseline: spec [
	<baseline>
	spec for: #'common' do: [
		self 
			jsonSchema: spec;
			zinc: spec.

		spec 
			package: 'HOP-Core' with: [ 
				spec requires: #() ];
			package: 'HOP-Core-Tests' with: [ 
				spec requires: #('HOP-Core') ];
			package: 'HOP-Extra' with: [ 
				spec requires: #('HOP-Core') ];
			package: 'HOP-Roassal' with: [ 
				spec requires: #('HOP-Core') ] ]
]

{ #category : 'as yet unclassified' }
BaselineOfHyperObjectPresentation >> jsonSchema: spec [
	
	spec baseline: 'JSONSchema' with: [ 
		spec 
			repository: 'github://zweidenker/JSONSchema/source' ]
]

{ #category : 'baselines' }
BaselineOfHyperObjectPresentation >> zinc: spec [
	spec baseline: 'ZincHTTPComponents' with: [ 
		spec 
			loads: #('REST' 'Zinc-HTTP-Examples');
			repository: 'github://svenvc/zinc/repository']
]
