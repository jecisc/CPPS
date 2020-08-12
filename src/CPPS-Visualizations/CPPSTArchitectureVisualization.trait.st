"
Description
--------------------

I should be used by visualizations with connections interactions to update the connections when the user open/close a node.
"
Trait {
	#name : #CPPSTArchitectureVisualization,
	#category : #'CPPS-Visualizations-Core'
}

{ #category : #dependencies }
CPPSTArchitectureVisualization >> adaptDependenciesForNode: aTLCompositeNode interactions: aCollectionOfTLInteraction [

	self
		updateSourcesForNode: aTLCompositeNode
		interactions: aCollectionOfTLInteraction.
	self
		updateTargetsForNode: aTLCompositeNode
		interactions: aCollectionOfTLInteraction.
	aTLCompositeNode expanded ifFalse: [ aTLCompositeNode childrenNodes do: [ :child | aCollectionOfTLInteraction do: [ :anInteraction | anInteraction action reverseActionIfNecessaryOn: child ] ] ]
]

{ #category : #dependencies }
CPPSTArchitectureVisualization >> updateSourcesForNode: aTLCompositeNode interactions: aCollectionOfTLInteraction [

	aTLCompositeNode incomingAdjacentNodes , (aTLCompositeNode childrenNodes flatCollect: [ :e | e incomingAdjacentNodes ]) do:
		[ :node | 
		aCollectionOfTLInteraction do:
			[ :anInteraction | 
			(anInteraction action shouldTriggerReverseActionFor: node) ifTrue:
				[ anInteraction action
					actionOn: node;
					actionOn: node "doing twice so we remove links then redo the connecting"
				]
			]
		]
]

{ #category : #dependencies }
CPPSTArchitectureVisualization >> updateTargetsForNode: aTLCompositeNode interactions: aCollectionOfTLInteraction [

	"We do it only if the node is expanded because it is too hard to know what to do if we close the node. Should we display the dependencies of the parent node? When? When one children shown a dependency?"

	aTLCompositeNode expanded ifFalse: [ ^ self ].
	aCollectionOfTLInteraction do:
		[ :interaction | 
		(interaction action shouldTriggerReverseActionFor: aTLCompositeNode) ifTrue:
			[ aTLCompositeNode asTLDrawableCollection obtain visibles recursively nodes do: [ :e | interaction action actionOn: e ].
			interaction action actionOn: aTLCompositeNode
			]
		]
]
