Class {
	#name : 'AGHOPCodeTest',
	#superclass : 'TestCase',
	#category : 'HOP-Core-Tests',
	#package : 'HOP-Core-Tests'
}

{ #category : 'tests' }
AGHOPCodeTest >> testDependencies [ 
	| dependencies invalid |
	self skip.
	dependencies := (self dependencyPackageFor: HOPUriSpace package) dependentPackages collect: #name.
	invalid := dependencies reject: [ :name | self validDependentPackages includes: name ].
	self assertCollection: invalid hasSameElements: #()
]

{ #category : 'tests' }
AGHOPCodeTest >> testNoShadowedVariablesInMethods [
	"Fail if there are methods who define shadowed temps or args"
	| found validExceptions remaining |
	found := HOPUriSpace package methods select: [ :m |
		m isQuick not and: [ "quick methods do not define variables"
			m ast variableDefinitionNodes anySatisfy: [ :node | node variable isShadowing ] ]].
	"No other exceptions beside the ones mentioned here should be allowed"
	validExceptions := { }.

	remaining := found asOrderedCollection
								removeAll: validExceptions;
								yourself.

	self
		assert: remaining isEmpty
		description: ('the following methods have shadowing variable definitions and should be cleaned: ', remaining asString)
]

{ #category : 'tests' }
AGHOPCodeTest >> testNoVarsDefinedByClassesShadow [ [
	"make sure no class vars or ivars shadow"
	| classes |
	classes := HOPUriSpace package definedClasses select: [ :class |
		           class definedVariables anySatisfy: [ :var |
			           var isShadowing ] ].

	self assert: classes isEmpty description: classes asArray asString
]
]

{ #category : 'as yet unclassified' }
AGHOPCodeTest >> validDependentPackages [
	^ #( 
			'Collections-Abstract'
			'Collections-Sequenceable'
			'Collections-Strings'
			'Collections-Support'
			'Collections-Unordered'
			'HOP-Core'
			'JSONSchema-Core'
			'Kernel'
			'Kernel-CodeModel'
			"spec is a dependency because of the inspections"
			'Spec2-Core'
			'Zinc-HTTP'
			'Zinc-REST'
		)
]
