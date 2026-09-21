Class {
	#name : 'BaselineOfHOP',
	#superclass : 'BaselineOf',
	#category : 'BaselineOfHOP',
	#package : 'BaselineOfHOP'
}

{ #category : 'baselines' }
BaselineOfHOP >> baseline: spec [
	"Groups, so that an image loads what it serves. Without any, Metacello's default group is
	every package there is, and apptive-common asks for this baseline without naming one - so
	HOP-Core-Tests, HOP-Extra-Tests and HOP-Roassal travelled into apptive-base,
	apptive-account and apptive-metabase, which serve none of them.

	Test classes in a deployed image are not idle: AGTestRunnerHandler hangs under #health in
	two of those servers and runs the whole suite of any TestCase class it is asked for.
	HOP-Roassal does not even belong there twice over - it names Roassal classes this baseline
	never loads, so it has been compiling against undeclared variables wherever it landed.

	'All' is what CI loads and is the package set this baseline had before the groups; nothing
	about the test run changes."
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
			package: 'HOP-Extra-Tests' with: [ 
				spec requires: #('HOP-Extra') ];
			package: 'HOP-Roassal' with: [ 
				spec requires: #('HOP-Core') ].

		spec
			group: 'Core' with: #('HOP-Core' 'HOP-Extra');
			group: 'Tests' with: #('HOP-Core-Tests' 'HOP-Extra-Tests');
			group: 'Roassal' with: #('HOP-Roassal');
			group: 'All' with: #('Core' 'Tests' 'Roassal');
			group: 'default' with: #('Core') ]
]

{ #category : 'as yet unclassified' }
BaselineOfHOP >> jsonSchema: spec [
	
	spec baseline: 'JSONSchema' with: [ 
		spec 
			repository: 'github://ApptiveGrid/JSONSchema:1d2fd5a23b5b6701bba5ce50e2e48e32afc70811/source' ]
]

{ #category : 'baselines' }
BaselineOfHOP >> zinc: spec [
	spec baseline: 'ZincHTTPComponents' with: [ 
		spec 
			loads: #('REST' 'Zinc-HTTP-Examples');
			repository: 'github://ApptiveGrid/zinc/repository']
]
