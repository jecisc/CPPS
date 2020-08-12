"
Description
--------------------

I am a cleaning strategy that will remove thedependencies of the receiver that have only me as dependency transitivelly and remove the useless nodes in the visualization.
(The node at the first layer of the visualization with no incoming connection)
"
Class {
	#name : #CPPSRIAExclusiveDependencyCleaningStrategy,
	#superclass : #CPPSRIACleaningStrategy,
	#category : #'CPPS-Visualizations-Visualizations-RefactoringImpactAnalyzer'
}

{ #category : #accessing }
CPPSRIAExclusiveDependencyCleaningStrategy class >> description [

	^ 'Remove my exclusive dependencies'
]

{ #category : #execute }
CPPSRIAExclusiveDependencyCleaningStrategy class >> executeOn: aNode in: aVisualization [

	(aNode
		 deep: [ :n | n outgoingAdjacentNodes select: [ :n2 | n2 incomingConnections size < 2 ] ]
		 flatCollect: [ :n | n incomingConnections ]
		 as: Set) do: #removed.
	aVisualization obtain groupRecursively nodes \ (aVisualization groupAtLevel: 0) nodes
		select: [ :node | node incomingConnections isEmpty ]
		thenDo: #remove
]

{ #category : #accessing }
CPPSRIAExclusiveDependencyCleaningStrategy class >> index [

	^ 3
]
