"
Description
--------------------

I am a strategy managing the behavior of the SYNTreeExplorerVisualization when we explore the providers (outgoing dependencies) of the concerned entity.
"
Class {
	#name : #CPPSTreeExplorerProvidersStrategy,
	#superclass : #CPPSTreeExplorerDirectionStrategy,
	#category : #'CPPS-Visualizations-Visualizations-TreeExplorer'
}

{ #category : #accessing }
CPPSTreeExplorerProvidersStrategy class >> childrenOf: anEntity [

	^ anEntity allProviders
]

{ #category : #accessing }
CPPSTreeExplorerProvidersStrategy class >> expandToOrigin [

	^ false
]

{ #category : #accessing }
CPPSTreeExplorerProvidersStrategy class >> layout [

	^ super layout
		  useOutgoingLinks;
		  yourself
]
