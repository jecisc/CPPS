"
Description
--------------------

I am a simple cleaning strategy that will remove the incoming links of the receiver node.
"
Class {
	#name : #CPPSRIAIncomingLinksCleaningStrategy,
	#superclass : #CPPSRIACleaningStrategy,
	#category : #'CPPS-Visualizations-Visualizations-RefactoringImpactAnalyzer'
}

{ #category : #accessing }
CPPSRIAIncomingLinksCleaningStrategy class >> description [

	^ 'Remove my incoming links'
]

{ #category : #execute }
CPPSRIAIncomingLinksCleaningStrategy class >> executeOn: aNode in: aVisualization [

	aNode incomingConnections asSet do: #removed
]

{ #category : #accessing }
CPPSRIAIncomingLinksCleaningStrategy class >> index [

	^ 5
]
