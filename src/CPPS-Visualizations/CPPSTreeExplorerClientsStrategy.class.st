"
Description
--------------------

I am a strategy managing the behavior of the SYNTreeExplorerVisualization when we explore the clients (incoming dependencies) of the concerned entity.
"
Class {
	#name : #CPPSTreeExplorerClientsStrategy,
	#superclass : #CPPSTreeExplorerDirectionStrategy,
	#category : #'CPPS-Visualizations-Visualizations-TreeExplorer'
}

{ #category : #accessing }
CPPSTreeExplorerClientsStrategy class >> childrenOf: anEntity [

	^ anEntity allClients
]

{ #category : #accessing }
CPPSTreeExplorerClientsStrategy class >> expandToOrigin [

	^ true
]
