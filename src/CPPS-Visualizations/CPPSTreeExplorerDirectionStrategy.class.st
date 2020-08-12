"
Description
--------------------

I am an abstract strategy managing everything related to the direction the visualization (SYNTreeExplorerVisualization) will explore since the visualization can be done through the incoming dependencies or the outgoing dependencies.

I implement the Strategy design pattern.
"
Class {
	#name : #CPPSTreeExplorerDirectionStrategy,
	#superclass : #Object,
	#category : #'CPPS-Visualizations-Visualizations-TreeExplorer'
}

{ #category : #accessing }
CPPSTreeExplorerDirectionStrategy class >> childrenOf: anEntity [

	"I should return the entities to display in the next level of the tree explorer visualization for a given entity."

	^ self subclassResponsibility
]

{ #category : #accessing }
CPPSTreeExplorerDirectionStrategy class >> expandToOrigin [

	"I should return a boolean. If true, this mean that the entities in the next level of the visualization should point to the origin entity. If false, the origin entity should point to its children."

	^ self subclassResponsibility
]

{ #category : #accessing }
CPPSTreeExplorerDirectionStrategy class >> layout [

	"I return the layout that should be used by the tree explorer for this direction."

	^ TLTreeLayout new
		  leavesGap: 200;
		  levelGap: 100;
		  yourself
]
