"
Description
--------------------

I am a simple cleaning strategy that will remove the outgoing links of the receiver node.
"
Class {
	#name : #CPPSRIAOutgoingLinksCleaningStrategy,
	#superclass : #CPPSRIACleaningStrategy,
	#category : #'CPPS-Visualizations-Visualizations-RefactoringImpactAnalyzer'
}

{ #category : #accessing }
CPPSRIAOutgoingLinksCleaningStrategy class >> description [

	^ 'Remove my outgoing links'
]

{ #category : #execute }
CPPSRIAOutgoingLinksCleaningStrategy class >> executeOn: aNode in: aVisualization [

	aNode outgoingConnections asSet do: #removed
]

{ #category : #accessing }
CPPSRIAOutgoingLinksCleaningStrategy class >> index [

	^ 4
]
