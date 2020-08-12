Trait {
	#name : #CPPSTDependenciesExplorerVisualization,
	#category : #'CPPS-Visualizations-Core'
}

{ #category : #interactions }
CPPSTDependenciesExplorerVisualization >> buildInteractions [

	self addInteractions: self highlightConnectionsOnMouseOver.
	self addInteraction: (TLPopUpAction
			 text: [ :e | e tooltipIn: self language ]
			 position: TLPosition left) onMouseOver propagateToChildren
]

{ #category : #layout }
CPPSTDependenciesExplorerVisualization >> compositeChildrenLayout [

	^ self explicitRequirement
]

{ #category : #actions }
CPPSTDependenciesExplorerVisualization >> createEntities: entities atLevel: aLevel [

	| group |

	group := self groupAtLevel: aLevel.
	entities do: [ :anElement | group addNodeIfNotPresentFromEntity: anElement ]
]

{ #category : #actions }
CPPSTDependenciesExplorerVisualization >> createLinksFor: node to: aCollection atLevel: aLevel [

	self explicitRequirement
]

{ #category : #interactions }
CPPSTDependenciesExplorerVisualization >> defaultExpandAction [

	^ TLExpandCollapseCompositeNodeAction new
]

{ #category : #actions }
CPPSTDependenciesExplorerVisualization >> ensureEntitiesAndLinksFor: node [

	| aLevel |

	aLevel := self getLevelOfNode: node.
	node hasChildrenToDisplay
		ifTrue:
			[ | outgoings |

			outgoings := node childrenNodes flatCollect:
				             [ :child | 
				             self ensureEntitiesAndLinksFor: child.
				             child outgoingAdjacentNodes
				             ].
			self
				ensureEntitiesAndLinksFor: node
				atLevel: aLevel
				withRejectOutgoings: outgoings
			]
		ifFalse:
			[ self
				ensureEntitiesAndLinksFor: node
				atLevel: aLevel
			]
]

{ #category : #actions }
CPPSTDependenciesExplorerVisualization >> ensureEntitiesAndLinksFor: node atLevel: aLevel [

	self
		createEntities: (self selectEntitiesToCreateForNextLevelFrom: (self entitiesForNextLevelFor: node entity))
		atLevel: aLevel.
	self
		createLinksFor: node
		to: (self entitiesForNextLevelFor: node entity)
		atLevel: aLevel
]

{ #category : #actions }
CPPSTDependenciesExplorerVisualization >> ensureEntitiesAndLinksFor: node atLevel: aLevel withRejectOutgoings: outgoing [

	| nodeEntity entities |

	nodeEntity := node entity.

	"If a node linked to a TAG is open, no need to check its dependencies since it cannot have dependencies by itself. Only its children can."
	(node hasChildrenToDisplay and: [ nodeEntity isTag ]) ifTrue: [ ^ self ].
	entities := (self entitiesForNextLevelFor: nodeEntity) \ (outgoing collect: #entity).
	self
		createEntities: (self selectEntitiesToCreateForNextLevelFrom: entities)
		atLevel: aLevel.
	self
		createLinksFor: node
		to: entities
		atLevel: aLevel
]

{ #category : #actions }
CPPSTDependenciesExplorerVisualization >> entitiesForNextLevelFor: anEntity [

	^ self explicitRequirement
]

{ #category : #accessing }
CPPSTDependenciesExplorerVisualization >> getLevelOfNode: node [

	| group index |

	index := 0.
	group := node.
	[ index = 0 ] whileTrue:
		[ group := group parent.
		index := self subGroups indexOf: group
		].
	^ index
]

{ #category : #accessing }
CPPSTDependenciesExplorerVisualization >> groupAtLevel: aLevel [

	^ self > ('group' , aLevel asString) asSymbol
]

{ #category : #actions }
CPPSTDependenciesExplorerVisualization >> selectEntitiesToCreateForNextLevelFrom: aCollection [

	^ self explicitRequirement
]

{ #category : #style }
CPPSTDependenciesExplorerVisualization >> setGlobalStyle [

	self styleSheet
		borderStyle: [ :e :node | node borderStyleForChildrenPresence ];
		borderColor: [ :entity | FamixKindColorStrategy default colorFor: entity ];
		nodeLabelPosition: #top
]

{ #category : #layout }
CPPSTDependenciesExplorerVisualization >> setLayouts [

	self nodeCreationStrategy: (TLNodeCreationStrategy
			 recursiveComposite: self compositeProperty
			 withLayout: self compositeChildrenLayout).
	self styleSheet layout: (TLLinearLayout gap: 200).
	self styleSheet > #group layout: (TLLinearLayout topToBottom
			 gap: 15;
			 yourself).
	self addInteraction: self defaultExpandAction onClick propagateToChildren.
	self > #group0 addNodesFromEntities: self elementsToAnalyze
]
