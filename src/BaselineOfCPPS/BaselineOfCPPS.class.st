"
I am a baseline to define the structure and dependencies of the CPPS project.
"
Class {
	#name : #BaselineOfCPPS,
	#superclass : #BaselineOf,
	#category : #BaselineOfCPPS
}

{ #category : #baseline }
BaselineOfCPPS >> baseline: spec [
	<baseline>
	spec
		for: #common
		do: [
			"Dependencies"
			self famix: spec.

			"Packages"
			spec
				package: 'CPPS-Entities' with: [ spec requires: #('Famix') ];
				package: 'CPPS-Generator' with: [ spec requires: #('FamixGenerator') ].

			"Groups"
			spec
				group: 'Model' with: #('CPPS-Entities');
				group: 'Generator' with: #('CPPS-Generator') ].
]

{ #category : #dependencies }
BaselineOfCPPS >> famix: spec [
	spec
		baseline: 'Famix'
			with: [ spec
				loads: #('Core');
				repository: 'github://jecisc/Famix:v6.x.x/src' ];
		project: 'FamixGenerator' copyFrom: 'Famix' with: [ spec loads: #('Basic') ]
]

{ #category : #accessing }
BaselineOfCPPS >> projectClass [
	^ MetacelloCypressBaselineProject
]
