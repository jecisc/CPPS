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
				package: 'CPPS-Entities' with: [ spec requires: #('FamixReplication') ];
				package: 'CPPS-Generator' with: [ spec requires: #('Famix') ].

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
				loads: #('Basic');
				repository: 'github://moosetechnology/Famix:development/src' ]
]

{ #category : #dependencies }
BaselineOfCPPS >> famixReplication: spec [
	spec
		baseline: 'FamixReplication'
		with: [ spec
				loads: #('Core' 'CPP');
				repository: 'github://moosetechnology/FamixReplication:v1.x.x/src' ]
]

{ #category : #accessing }
BaselineOfCPPS >> projectClass [
	^ MetacelloCypressBaselineProject
]
