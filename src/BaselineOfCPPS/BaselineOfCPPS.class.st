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
				famixPresentation: spec;
				famixReplication: spec;
				famixTagging: spec;
				petitParser: spec;
				petitParser2: spec;
				rules: spec;
				tinyLogger: spec.

			"Packages"
			spec
				package: 'CPPS-Entities' with: [ spec requires: #('Famix' 'Moose-ProjectHolder-Core' 'FamixPresentation' 'FamixReplication' 'Rules' 'FamixTagging' 'TinyLogger') ];
				package: 'CPPS-Entities-Tests' with: [ spec requires: #('CPPS-Entities') ];
				package: 'CPPS-Generator' with: [ spec requires: #('FamixGeneration') ];
				
				package: 'Moose-ProjectHolder-Core' with: [ spec requires: #('Famix') ];
				package: 'Moose-ProjectHolder-Tests' with: [ spec requires: #('Moose-ProjectHolder-Core') ];
				
				package: 'CPPS-Parser' with: [ spec requires: #('CPPS-Entities' 'PetitParser2Core' 'PetitParser') ];
				package: 'CPPS-Parser-Tests' with: [ spec requires: #('CPPS-Parser') ].

			"Groups"
			spec
				group: 'Model' with: #('CPPS-Entities');
				group: 'Parser' with: #('CPPS-Parser');
				group: 'Generator' with: #('CPPS-Generator');
				group: 'Tests' with: #('CPPS-Entities-Tests' 'CPPS-Parser-Tests' 'Moose-ProjectHolder-Tests') ]
]

{ #category : #dependencies }
BaselineOfCPPS >> famix: spec [
	spec
		baseline: 'Famix'
			with: [ spec
				loads: #('BasicTraits' 'CommentAnalyzer');
				repository: 'github://moosetechnology/Famix:development/src' ];
		project: 'FamixGeneration' copyFrom: 'Famix' with: [ spec loads: #('Basic') ]
]

{ #category : #dependencies }
BaselineOfCPPS >> famixPresentation: spec [
	spec baseline: 'FamixPresentation' with: [ spec repository: 'github://moosetechnology/FamixPresentation:v1.x.x/src' ]
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
BaselineOfCPPS >> famixTagging: spec [
	spec baseline: 'FamixTagging' with: [ spec repository: 'github://moosetechnology/FamixTagging:v1.x.x/src' ]
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

{ #category : #dependencies }
BaselineOfCPPS >> tinyLogger: spec [
	spec
		baseline: 'TinyLogger'
		with: [ spec
				loads: #('Core');
				repository: 'github://jecisc/TinyLogger:v1.x.x/src' ]
]
