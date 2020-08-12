Class {
	#name : #CPPSMultiClassSplitterVisualization,
	#superclass : #CPPSClassSplitterVisualization,
	#instVars : [
		'elementsToAnalyze'
	],
	#category : #'CPPS-Visualizations-Visualizations-ClassSplitter'
}

{ #category : #accessing }
CPPSMultiClassSplitterVisualization class >> entity: _ subEntities: aCollection [

	^ self new
		  elementsToAnalyze: aCollection;
		  yourself
]

{ #category : #testing }
CPPSMultiClassSplitterVisualization class >> supportMultipleEntities [

	^ true
]

{ #category : #building }
CPPSMultiClassSplitterVisualization >> addToVisible: anEntity [

	self addNodeIfNotPresentFromEntity: anEntity
]

{ #category : #building }
CPPSMultiClassSplitterVisualization >> borderColorStrategy [

	^ FamixKindColorStrategy defaultStrategyWithFallback
]

{ #category : #building }
CPPSMultiClassSplitterVisualization >> buildChildrenInteractions [

	self allChildrenNodes
		addInteraction: (TLPopUpAction text:
					 [ :child | 
					 child
						 tooltipNameIn: self language
						 forModel: self model
					 ]) onMouseOver;
		addInteraction: (TLCustomAction block: self tagActionBlock) onClick.
	self obtain compositeRecursively visibles nodes
		addInteraction: ((TLCustomWithParameterAction block: [ :node :choice | (self connectionsInteractionsMap at: choice) cull: node ])
				 withMultipleChoices: [ self connectionsInteractionsMap keys ]
				 menu: (self translate: ('Show dependencies' french: 'Montrer les dépendances')));
		addInteraction: ((TLCustomWithParameterAction block: [ :node :choice | (self hideConnectionsInteractionsMap at: choice) cull: node ])
				 withMultipleChoices: [ self hideConnectionsInteractionsMap keys ]
				 menu: (self translate: ('Hide dependencies' french: 'Cacher les dépendances')));
		addInteractions: self highlightConnectionsOnMouseOver
]

{ #category : #building }
CPPSMultiClassSplitterVisualization >> buildLegend [

	super buildLegend.
	self borderColorStrategy addBorderLegendToVisualization: self.
	self legend
		nodeShapeDescription:
			[ :entity | 
			entity isTag
				ifTrue: [ 'Tag' ]
				ifFalse: [ 'Entity' ]
			]
		forNodes: [ self obtain recursively nodes ].
	self
		addLegendForOutgoings;
		addLegendForIncomings
]

{ #category : #building }
CPPSMultiClassSplitterVisualization >> buildVisualization [

	super buildVisualization.
	self nodeCreationStrategy
		childrenProperty: [ :ent | self getChildrenOf: ent ];
		childrenSortingStrategy: (TLSortingBlockStrategy sortingBlock: [ :node1 :node2 | node1 entity hasPriorityOn: node2 entity ]).
	self addNodesFromEntities: self elementsToAnalyze.
	self styleSheet
		expandCompositeNodes;
		nodeLabel: #name
		position: #top;
		layout: (TLLinearLayout
				 gap: 100
				 ratio: 4 / 3);
		shape: #cytoscapeShape;
		backgroundColor: [ :anEntity | self backgroundColorStrategy colorFor: anEntity ];
		borderColor: [ :anEntity | self borderColorStrategy colorFor: anEntity ];
		borderWidth: 2.
	(self styleSheet > #children)
		noNodeLabel;
		layout: (TLLinearLayout
				 gap: 20
				 ratio: 4 / 3).
	self buildChildrenInteractions
]

{ #category : #interaction }
CPPSMultiClassSplitterVisualization >> connectionsInteractionsMap [

	^ OrderedDictionary
		  with: '1. From this node (Outgoing)' -> [ :node | self showOutgoingDependenciesOf: node ]
		  with: '2. To this node (Incoming)' -> [ :node | self showIncomingDependenciesOf: node ]
		  with: '3. From all children nodes (can be long if there are too many nodes)' -> [ self allChildrenNodes nodesDo: [ :node | self showOutgoingDependenciesOf: node ] ]
		  with: '3. To all children nodes (can be long if there are too many nodes)' -> [ self allChildrenNodes nodesDo: [ :node | self showIncomingDependenciesOf: node ] ]
		  with: '4. Between all nodes (can be long if there are too many nodes)' -> [ self obtain recursively visibles nodesDo: [ :node | self showOutgoingDependenciesOf: node ] ]
]

{ #category : #accessing }
CPPSMultiClassSplitterVisualization >> elementsToAnalyze [

	^ elementsToAnalyze
]

{ #category : #accessing }
CPPSMultiClassSplitterVisualization >> elementsToAnalyze: anObject [

	elementsToAnalyze := anObject
]

{ #category : #building }
CPPSMultiClassSplitterVisualization >> getChildrenOf: anEntity [

	| taggedChildren children tags |

	children := anEntity children.
	taggedChildren := children select: #isTagged.
	tags := taggedChildren flatCollectAsSet: #tags.
	^ children \ taggedChildren , tags
]

{ #category : #interaction }
CPPSMultiClassSplitterVisualization >> hideConnectionsInteractionsMap [

	^ OrderedDictionary
		  with: '1. From this node (Outgoing)' -> [ :node | self removeOutgoingInteractionsOf: node ]
		  with: '2. To this node (Incoming)' -> [ :node | self removeIncomingInteractionsOf: node ]
		  with: '3. From all children nodes' -> [ self allChildrenNodes nodesDo: [ :node | self removeOutgoingInteractionsOf: node ] ]
		  with: '4. To all children nodes' -> [ self allChildrenNodes nodesDo: [ :node | self removeIncomingInteractionsOf: node ] ]
		  with: '5. Of all nodes' -> [ self obtain recursively all nodesDo: [ :node | node removeAllConnections ] ]
]

{ #category : #interaction }
CPPSMultiClassSplitterVisualization >> refreshOnTagUpdates [

	"I manage what is happening when we receive an announcement about tag change."

	self allChildrenNodes do:
		[ :node | 
		node entity isTagged ifTrue:
			[ node entity tags do: [ :tag | node parent addNodeIfNotPresentFromEntity: tag ].
			node remove
			]
		].
	self update
]

{ #category : #interaction }
CPPSMultiClassSplitterVisualization >> removeIncomingInteractionsOf: node [

	node incomingConnections reverseDo: #removed
]

{ #category : #interaction }
CPPSMultiClassSplitterVisualization >> removeOutgoingInteractionsOf: node [

	node outgoingConnections reverseDo: #removed
]

{ #category : #interaction }
CPPSMultiClassSplitterVisualization >> showIncomingDependenciesOf: aNode [

	| possibleNodes |

	possibleNodes := self obtain compositeRecursively visibles nodes.
	(self nodesForEntities: (aNode entity
			  allClientsIn: (possibleNodes collect: #entity)
			  forModel: model)) do: [ :n | n connectIfNotTo: aNode ]
]

{ #category : #interaction }
CPPSMultiClassSplitterVisualization >> showOutgoingDependenciesOf: aNode [

	| possibleNodes |

	possibleNodes := self obtain compositeRecursively visibles nodes.
	aNode connectIfNotToAll: (self nodesForEntities: (aNode entity
				  allProvidersIn: (possibleNodes collect: #entity)
				  forModel: model))
]
