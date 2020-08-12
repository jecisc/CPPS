"
Description
--------------------

I am an architecture configuration for a visualization.
I will store the architecture that should be viewed.
The concerned version and all the other parameters required by the visualization.
"
Class {
	#name : #CPPSArchitectureVisualizationConfiguration,
	#superclass : #Object,
	#instVars : [
		'architecture',
		'version'
	],
	#category : #'CPPS-Visualizations-Visualizations-Architecture'
}

{ #category : #'instance creation' }
CPPSArchitectureVisualizationConfiguration class >> architecture: anArchitecture version: aVersion [

	^ self new
		  architecture: anArchitecture;
		  version: aVersion;
		  yourself
]

{ #category : #possibilities }
CPPSArchitectureVisualizationConfiguration >> allowArchitectureManipulation [

	^ self architecture isTagGenerated not
]

{ #category : #accessing }
CPPSArchitectureVisualizationConfiguration >> architecture [

	^ architecture
]

{ #category : #accessing }
CPPSArchitectureVisualizationConfiguration >> architecture: anObject [

	architecture := anObject
]

{ #category : #accessing }
CPPSArchitectureVisualizationConfiguration >> version [

	^ version
]

{ #category : #accessing }
CPPSArchitectureVisualizationConfiguration >> version: anObject [

	version := anObject
]
