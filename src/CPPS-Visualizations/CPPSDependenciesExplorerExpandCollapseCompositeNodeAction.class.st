"
Description
--------------------

I am a specialization of the Explorer Expand Collapse composite node action specific to the dependency explorer visu.
"
Class {
	#name : #CPPSDependenciesExplorerExpandCollapseCompositeNodeAction,
	#superclass : #TLExpandCollapseCompositeNodeAction,
	#category : #'CPPS-Visualizations-Visualizations'
}

{ #category : #action }
CPPSDependenciesExplorerExpandCollapseCompositeNodeAction >> regularActionOn: aNode [

	super regularActionOn: aNode.
	aNode childrenNodes
		select: [ :child | aNode visualization shouldHideWithFilterNode: child ]
		thenDo: #hide
]

{ #category : #action }
CPPSDependenciesExplorerExpandCollapseCompositeNodeAction >> reverseActionOn: aNode [

	super reverseActionOn: aNode.
	aNode visualization update
]
