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
				mooseProject: spec;
				petitParser: spec;
				petitParser2: spec;
				rules: spec;
				telescopeCytoscape: spec;
				tinyLogger: spec;
				xmiAnalyzer: spec;
				bugReport: spec;
				chartJs: spec;
				cpps: spec;
				deploymentUtility: spec;
				heimdall: spec;
				magritte: spec;
				materialDesignLite: spec;
				prismCodeDisplayer: spec;
				seaside3: spec;
				systemInteraction: spec.

			"Packages"
			spec
				package: 'CPPS-Entities' with: [ spec requires: #('Famix' 'MooseProject' 'FamixPresentation' 'FamixReplication' 'Rules' 'FamixTagging' 'TinyLogger') ];
				package: 'CPPS-Entities-Tests' with: [ spec requires: #('CPPS-Entities' 'MooseProjectTests') ];
				package: 'CPPS-Generator' with: [ spec requires: #('FamixGeneration') ];

				package: 'CPPS-Parser' with: [ spec requires: #('CPPS-Entities' 'PetitParser2Core' 'PetitParser') ];
				package: 'CPPS-Parser-Tests' with: [ spec requires: #('CPPS-Parser') ];
				
				package: 'CPPS-Architecture' with: [ spec requires: #('CPPS-Entities' 'XMIAnalyzer') ];
				package: 'CPPS-Architecture-Tests' with: [ spec requires: #('CPPS-Architecture') ];
				
				package: 'CPPS-Visualizations' with: [ spec requires: #('Model' 'Architecture' 'TelescopeCytoscape') ];
				
				package: 'Famix-Queries' with: [ spec requires: #('Model') ];
				
				

				package: 'CPPS-Toolkit-ArchitectureSimulation' with: [ spec requires: #('CPPS-Toolkit-Core' 'CPPS-Toolkit-CodeAnalyzer') ];
				package: 'CPPS-Toolkit-CodeAnalyzer' with: [ spec requires: #('PrismCodeDisplayer' 'CPPS-Toolkit-ClassSplitter') ];
				package: 'CPPS-Toolkit-ClassSplitter' with: [ spec requires: #('CPPS-Toolkit-Core') ];
				package: 'CPPS-Toolkit-Core' with: [ spec requires: #('Seaside3' 'MaterialDesignLite' 'Heimdall' 'CPPS-Toolkit-Server' 'CPPS-Toolkit-Magritte') ];
				package: 'CPPS-Toolkit-Dashboard' with: [ spec requires: #('ChartJs' 'CPPS-Toolkit-CodeAnalyzer') ];
				package: 'CPPS-Toolkit-Duplication' with: [ spec requires: #('CPPS-Toolkit-Core' 'PrismCodeDisplayer' 'ChartJs') ];
				package: 'CPPS-Toolkit-Executive' with: [ spec requires: #('CPPS-Toolkit-Core' 'CPPS-Toolkit-CodeAnalyzer') ];
				package: 'CPPS-Toolkit-QueryBrowser' with: [ spec requires: #('CPPS-Toolkit-Core' 'CPPS-Toolkit-Duplication') ];
				package: 'CPPS-Toolkit-RefactoringImpactAnalyzer' with: [ spec requires: #('CPPS-Toolkit-Core') ];
				package: 'CPPS-Toolkit-RulesBrowser' with: [ spec requires: #('CPPS-Toolkit-QueryBrowser') ];
				package: 'CPPS-Toolkit-Server' with: [ spec requires: #('Backend' 'DeploymentUtility' 'SystemInteraction' 'BugReport') ];

				package: 'CPPS-Toolkit-Magritte' with: [ spec requires: #('Magritte')].

			"Groups"
			spec
				group: 'Model' with: #('CPPS-Entities');
				group: 'Queries' with: #('Famix-Queries');
				group: 'Architecture' with: #('CPPS-Architecture');
				group: 'Parser' with: #('CPPS-Parser');
				group: 'Visualizations' with: #('CPPS-Visualizations');
				group: 'Generator' with: #('CPPS-Generator');
				group: 'Tests' with: #('CPPS-Entities-Tests' 'CPPS-Parser-Tests' 'CPPS-Architecture-Tests');
				group: 'Backend' with: #('Model' 'Queries' 'Architecture' 'Parser' 'Visualizations' 'Generator' 'Tests');
				group: 'Server' with: #('CPPS-Toolkit-Server') ]
]

{ #category : #dependencies }
BaselineOfCPPS >> bugReport: spec [
	spec
		baseline: 'BugReport'
		with: [ spec
				loads: 'Core';
				repository: 'github://jecisc/BugReport:v1.x.x/src' ]
]

{ #category : #dependencies }
BaselineOfCPPS >> chartJs: spec [
	spec baseline: 'ChartJs' with: [ spec repository: 'github://DuneSt/ChartJs:v1.x.x/src' ]
]

{ #category : #dependencies }
BaselineOfCPPS >> deploymentUtility: spec [
	spec baseline: 'DeploymentUtility' with: [ spec repository: 'github://jecisc/DeploymentUtility:v1.x.x/src' ]
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
BaselineOfCPPS >> heimdall: spec [
	spec baseline: 'Heimdall' with: [ spec repository: 'github://DuneSt/Heimdall:v1.x.x/src' ]
]

{ #category : #dependencies }
BaselineOfCPPS >> magritte: spec [
	spec
		baseline: 'Magritte'
		with: [ spec
				loads: #('Core' 'Seaside');
				repository: 'github://jecisc/magritte:v1PharoMinimal/source' ]
]

{ #category : #dependencies }
BaselineOfCPPS >> materialDesignLite: spec [
	spec baseline: 'MaterialDesignLite' with: [ spec repository: 'github://DuneSt/MaterialDesignLite:v2.x.x/src' ]
]

{ #category : #dependencies }
BaselineOfCPPS >> mooseProject: spec [
	spec
		baseline: 'MooseProject'
			with: [ spec
				loads: 'Core';
				repository: 'github://moosetechnology/MooseProject:v1.x.x/src' ];
		project: 'MooseProjectTests' copyFrom: 'MooseProject' with: [ spec loads: 'Tests' ]
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

{ #category : #dependencies }
BaselineOfCPPS >> prismCodeDisplayer: spec [
	spec
		baseline: 'PrismCodeDisplayer'
		with: [ spec repository: 'github://DuneSt/PrismCodeDisplayer:v1.x.x/src' ]
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
BaselineOfCPPS >> seaside3: spec [
	spec
		baseline: 'Seaside3'
		with: [ spec
				loads: #('Core' 'JQuery' 'Zinc');
				repository: 'github://SeasideSt/Seaside:v3.4.x/repository' ]
]

{ #category : #dependencies }
BaselineOfCPPS >> systemInteraction: spec [
	spec
		baseline: 'SystemInteraction'
		with: [ spec
				loads: 'TinyLoggerIntegration';
				repository: 'github://jecisc/SystemInteraction:v1.x.x/src' ]
]

{ #category : #dependencies }
BaselineOfCPPS >> telescopeCytoscape: spec [

	spec
		baseline: 'TelescopeCytoscape'
		with: [ spec repository: 'github://TelescopeSt/TelescopeCytoscape:v2.x.x/src' ]
]

{ #category : #dependencies }
BaselineOfCPPS >> tinyLogger: spec [
	spec
		baseline: 'TinyLogger'
		with: [ spec
				loads: #('Core');
				repository: 'github://jecisc/TinyLogger:v1.x.x/src' ]
]

{ #category : #dependencies }
BaselineOfCPPS >> xmiAnalyzer: spec [
	spec baseline: 'XMIAnalyzer' with: [ spec repository: 'github://moosetechnology/xmi-analyzer:v1.x.x/repository' ]
]
