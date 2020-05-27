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
		do: [ "Dependencies"
			self
				famix: spec;
				famixReplication: spec;
				petitParser: spec;
				petitParser2: spec;
				rules: spec.

			"Packages"
			spec
				package: 'CPPS-Entities' with: [ spec requires: #('FamixReplication' 'Rules') ];
				package: 'CPPS-Entities-Tests' with: [ spec requires: #('CPPS-Entities') ];
				package: 'CPPS-Generator' with: [ spec requires: #('Famix') ];
				
				package: 'CPPS-Parser' with: [ spec requires: #('CPPS-Entities' 'PetitParser2Core' 'PetitParser') ];
				package: 'CPPS-Parser-Tests' with: [ spec requires: #('CPPS-Parser') ].

			"Groups"
			spec
				group: 'Model' with: #('CPPS-Entities');
				group: 'Parser' with: #('CPPS-Parser');
				group: 'Generator' with: #('CPPS-Generator');
				group: 'Tests' with: #('CPPS-Entities-Tests' 'CPPS-Parser-Tests') ]
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

{ #category : #dependencies }
BaselineOfCPPS >> petitParser2: spec [
	spec baseline: 'PetitParser2Core' with: [ spec repository: 'github://kursjan/petitparser2' ]
]

{ #category : #dependencies }
BaselineOfCPPS >> petitParser: spec [
	spec
		baseline: 'PetitParser'
		with: [ spec
				loads: #('Core' 'Preprocessor');
				repository: 'github://moosetechnology/PetitParser:v2.x.x/src' ]
]

{ #category : #accessing }
BaselineOfCPPS >> projectClass [
	^ MetacelloCypressBaselineProject
]

{ #category : #dependencies }
BaselineOfCPPS >> rules: spec [
	spec baseline: 'Rules' with: [ spec repository: 'github://jecisc/Rules:v1.x.x/src' ]
]
