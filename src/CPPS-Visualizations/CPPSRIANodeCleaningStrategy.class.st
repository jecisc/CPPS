"
Description
--------------------

I am a simple strategy that will remove the receiver node from the visualization.
"
Class {
	#name : #CPPSRIANodeCleaningStrategy,
	#superclass : #CPPSRIACleaningStrategy,
	#category : #'CPPS-Visualizations-Visualizations-RefactoringImpactAnalyzer'
}

{ #category : #accessing }
CPPSRIANodeCleaningStrategy class >> description [

	^ 'Delete me'
]

{ #category : #execute }
CPPSRIANodeCleaningStrategy class >> executeOn: aNode in: aVisualization [

	aNode allConnections do: #removed.
	aNode parent remove: aNode.
	aVisualization update
]

{ #category : #accessing }
CPPSRIANodeCleaningStrategy class >> index [

	^ 1
]
