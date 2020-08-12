"
Description
--------------------

I am a cleaning strategy that will remove the outgoing links of the receiver transitivelly and remove the useless nodes in the visualization.
(The node at the first layer of the visualization with no incoming connection)
"
Class {
	#name : #CPPSRIADependencyCleaningStrategy,
	#superclass : #CPPSRIACleaningStrategy,
	#category : #'CPPS-Visualizations-Visualizations-RefactoringImpactAnalyzer'
}

{ #category : #accessing }
CPPSRIADependencyCleaningStrategy class >> description [

	^ 'Remove my dependencies'
]

{ #category : #execute }
CPPSRIADependencyCleaningStrategy class >> executeOn: aNode in: aVisualization [

	(aNode
		 deep: [ :node | node outgoingAdjacentNodes ]
		 flatCollect: [ :n | n incomingConnections ]
		 as: Set) do: #removed.
	aVisualization obtain groupRecursively nodes \ (aVisualization groupAtLevel: 0) nodes
		select: [ :node | node incomingConnections isEmpty ]
		thenDo: #remove
]

{ #category : #accessing }
CPPSRIADependencyCleaningStrategy class >> index [

	^ 2
]
