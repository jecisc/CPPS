Class {
	#name : #CPPSRIAVisualization,
	#superclass : #CPPSVisualization,
	#traits : 'CPPSTDependenciesExplorerVisualization',
	#classTraits : 'CPPSTDependenciesExplorerVisualization classTrait',
	#instVars : [
		'model',
		'owner',
		'elementsToAnalyze'
	],
	#category : #'CPPS-Visualizations-Visualizations-RefactoringImpactAnalyzer'
}

{ #category : #'instance creation' }
CPPSRIAVisualization class >> owner: aComponent elementsToAnalyze: aCollection [

	^ self new
		  owner: aComponent;
		  elementsToAnalyze: aCollection;
		  yourself
]

{ #category : #interactions }
CPPSRIAVisualization >> addConnectionsInteractions [

	^ self addInteractions: { 
			  ((TLCustomWithParameterAction block: [ :node :choice | (self visibleConnectionsInteractionsMap at: choice) cull: node ])
				   withMultipleChoices: [ self visibleConnectionsInteractionsMap keys ]
				   menu: (self translate: ('Show visibles dependencies' french: 'Montrer les dépendances visibles'))) propagateToChildren.
			  ((TLCustomWithParameterAction block: [ :node :choice | (self connectionsInteractionsMap at: choice) cull: node ])
				   withMultipleChoices: [ self connectionsInteractionsMap keys ]
				   menu: (self translate: ('Show all dependencies' french: 'Montrer toutes les dépendances'))) propagateToChildren }
]

{ #category : #interactions }
CPPSRIAVisualization >> addFindCommonDependenciesInteractions [

	self > #group0 addInteraction: ((TLCustomWithParameterAction block:
			  [ :node :choice | 
			  CPPSRIACommonDependencyBuildingStrategy
				  for: self
				  findUntil: choice asInteger
			  ])
			 withMultipleChoices: [ #( '1' '2' '3' ) ]
			 menu: (self
					  translate: 'Common dependencies on n levels'
					  french: 'Dépendances communes sur n niveaux'))
]

{ #category : #interactions }
CPPSRIAVisualization >> addInteractions [

	self addConnectionsInteractions.
	self addFindCommonDependenciesInteractions.
	self addRemovalInteractions
]

{ #category : #interactions }
CPPSRIAVisualization >> addRemovalInteractions [

	self addInteraction: ((TLCustomWithParameterAction block:
			  [ :node :choice | 
			  (CPPSRIACleaningStrategy strategyAtIndex: choice asInteger)
				  executeOn: node
				  in: self
			  ])
			 withMultipleChoices: [ CPPSRIACleaningStrategy userChoices ]
			 menu: (self
					  translate: 'Cleaning'
					  french: 'Nettoyage')) propagateToChildren
]

{ #category : #adding }
CPPSRIAVisualization >> addToVisible: entity [

	self > #group0 addNodeIfNotPresentFromEntity: entity
]

{ #category : #accessing }
CPPSRIAVisualization >> backgroundColorStrategy [

	^ FamixTagColorStrategy defaultStrategyWithFallback
]

{ #category : #accessing }
CPPSRIAVisualization >> borderColorStrategy [

	^ FamixKindColorStrategy default
]

{ #category : #building }
CPPSRIAVisualization >> buildLegend [

	super buildLegend.
	self legend descriptionForWidth: (self translate: ('Number of dependencies' french: 'Nombre de dépendances')).
	self backgroundColorStrategy addBackgroundLegendToVisualization: self.
	self borderColorStrategy addBorderLegendToVisualization: self.
	self
		addLegendForChildrenBorderStyle;
		addLegendForIncomings;
		addLegendForOutgoings
]

{ #category : #building }
CPPSRIAVisualization >> buildVisualization [

	super buildVisualization.
	self styleSheet
		width: [ :anEntity | ((self getAllConnectableEntitiesFor: anEntity) size raisedTo: 0.8) + 10 ];
		"We raise to 0.8 to avoid entity with many dependencies to be too large."height: 10;
		backgroundColor: [ :ent | self backgroundColorStrategy colorFor: ent ];
		borderColor: [ :entity | self borderColorStrategy colorFor: entity ];
		nodeLabel: #name;
		labelSize: 10.
	self setLayouts.
	self setGlobalStyle.
	self buildInteractions.
	self addInteractions
]

{ #category : #accessing }
CPPSRIAVisualization >> compositeChildrenLayout [

	^ (TLLinearLayout ratio: 16 / 9)
		  verticalGap: 18;
		  horizontalGap: 60;
		  yourself
]

{ #category : #accessing }
CPPSRIAVisualization >> compositeProperty [

	^ [ :entity | 
	  (entity isTag
		   ifTrue: [ entity children , ((entity taggedEntitiesInModel: self model) sorted: [ :child1 :child2 | child1 hasPriorityOn: child2 ]) ]
		   ifFalse: [ entity sortedChildrenByPriority ]) reject: [ :child | self owner kindsToExclude includes: child class ]
	  ]
]

{ #category : #accessing }
CPPSRIAVisualization >> connectionsInteractionsMap [

	^ OrderedDictionary
		  with: '1. For this node' -> [ :node | self ensureEntitiesAndLinksFor: node ]
		  with: '2. For all visible nodes (can be long if there is too many nodes)' -> [ self obtain groupRecursively visibles nodesDo: [ :node | self ensureEntitiesAndLinksFor: node ] ]
]

{ #category : #'as yet unclassified' }
CPPSRIAVisualization >> createEntities: entities atLevel: aLevel [

	entities do:
		[ :anElement | 
		self
			createNodeFor: anElement
			atLevel: aLevel
		]
]

{ #category : #'as yet unclassified' }
CPPSRIAVisualization >> createLinksFor: node to: aCollection atLevel: aLevel [

	| entitiesNodes allNodes |

	allNodes := self obtain recursively nodes.
	entitiesNodes := aCollection
		                 collect:
			                 [ :each | 
			                 allNodes
				                 detect: [ :n | n entity = each ]
				                 ifNone: [ nil "Possible if we show only the visibles" ]
			                 ]
		                 as: TLDrawableCollection.
	entitiesNodes := entitiesNodes reject: #isNil.
	self
		createLinksFor: node
		toNodes: entitiesNodes
]

{ #category : #actions }
CPPSRIAVisualization >> createLinksFor: node toNode: aCollection [

	self directionStrategy
		createLinksFor: node
		toNode: aCollection.

	"Here we need to open nodes containing dependencies"
	node openParents
]

{ #category : #actions }
CPPSRIAVisualization >> createLinksFor: node toNodes: aCollection [

	self directionStrategy
		createLinksFor: node
		toNodes: aCollection.

	"Here we need to open nodes containing dependencies"
	aCollection do: #openParents
]

{ #category : #actions }
CPPSRIAVisualization >> createNextLevelLinkFor: node [

	(node isComposite and: [ node expanded and: [ node hasChildren ] ])
		ifTrue: [ node childrenNodes do: [ :child | self createNextLevelLinkFor: child ] ]
		ifFalse:
			[ self
				createLinksFor: node
				to: (self entitiesForNextLevelFor: node entity)
				atLevel: (self getLevelOfNode: node)
			]
]

{ #category : #actions }
CPPSRIAVisualization >> createNextVisibleLevelLinkFor: node [

	node hasChildrenToDisplay
		ifTrue: [ node childrenNodes do: [ :child | self createNextVisibleLevelLinkFor: child ] ]
		ifFalse:
			[ self
				createVisibleLinksFor: node
				to: (self entitiesForNextLevelFor: node entity)
				atLevel: (self getLevelOfNode: node)
			]
]

{ #category : #actions }
CPPSRIAVisualization >> createNodeFor: anEntity atLevel: anInteger [

	| newNode childrenEntitiesOfNewNode allNodes |

	newNode := (self groupAtLevel: anInteger) addNodeFromEntity: anEntity.
	childrenEntitiesOfNewNode := newNode childrenGroup obtain recursively nodes collect: #entity.
	allNodes := self obtain groupRecursively nodes.
	allNodes
		select: [ :node | childrenEntitiesOfNewNode includes: node entity ]
		thenDo:
			[ :visuNodeDuplicatedInNewNode | 
			| childrenParent |

			newNode childrenGroup obtain recursively nodes
				detect: [ :node | node entity = visuNodeDuplicatedInNewNode entity ]
				ifFound:
					[ :duplicatedNodeInNewNode | 
					childrenParent := duplicatedNodeInNewNode parent.
					duplicatedNodeInNewNode remove
					].
			visuNodeDuplicatedInNewNode parent: childrenParent.
			visuNodeDuplicatedInNewNode openParents
			].
	^ newNode
]

{ #category : #actions }
CPPSRIAVisualization >> createVisibleLinksFor: node to: aCollection atLevel: aLevel [

	| entitiesNodes allNodes |

	allNodes := self obtain recursively nodes.
	entitiesNodes := aCollection
		                 collect:
			                 [ :each | 
			                 allNodes
				                 detect: [ :n | n entity = each ]
				                 ifFound:
					                 [ :n | 
					                 n isVisible
						                 ifTrue: [ n ]
						                 ifFalse: [ self getLowerVisibleNodeFor: n ]
					                 ]
				                 ifNone: [ nil "Possible if we show only the visibles" ]
			                 ]
		                 as: TLDrawableCollection.
	entitiesNodes := entitiesNodes reject: #isNil.
	self
		createLinksFor: node
		toNodes: entitiesNodes
]

{ #category : #accessing }
CPPSRIAVisualization >> directionStrategy [

	^ self owner directionStrategy
]

{ #category : #accessing }
CPPSRIAVisualization >> elementsToAnalyze [

	^ elementsToAnalyze
]

{ #category : #accessing }
CPPSRIAVisualization >> elementsToAnalyze: aCollection [

	elementsToAnalyze := aCollection
]

{ #category : #'as yet unclassified' }
CPPSRIAVisualization >> entitiesForNextLevelFor: anEntity [

	^ self getAllConnectableEntitiesFor: anEntity
]

{ #category : #actions }
CPPSRIAVisualization >> getAllConnectableEntitiesFor: anEntity [

	^ (self directionStrategy
		   getAllConnectableEntitiesFor: anEntity
		   in: self model
		   atDefaultScope: self owner defaultScope) reject: [ :entity | self owner kindsToExclude includes: entity class ]
]

{ #category : #actions }
CPPSRIAVisualization >> getLowerVisibleNodeFor: aTLNode [

	aTLNode isVisualization ifTrue: [ ^ nil ].
	^ aTLNode parentNode isVisible
		  ifTrue: [ aTLNode parentNode ]
		  ifFalse: [ self getLowerVisibleNodeFor: aTLNode parentNode ]
]

{ #category : #accessing }
CPPSRIAVisualization >> model [

	^ model
]

{ #category : #accessing }
CPPSRIAVisualization >> model: aModel [

	model := aModel
]

{ #category : #accessing }
CPPSRIAVisualization >> owner [

	^ owner
]

{ #category : #accessing }
CPPSRIAVisualization >> owner: anObject [

	owner := anObject
]

{ #category : #'as yet unclassified' }
CPPSRIAVisualization >> selectEntitiesToCreateForNextLevelFrom: aCollection [

	| allEntities |

	allEntities := self obtain recursively nodes collect: #entity.
	^ aCollection reject: [ :ent | (allEntities includes: ent) or: [ ent allParents anySatisfy: [ :e | (allEntities includes: e) or: [ aCollection includes: e ] ] ] ]
]

{ #category : #accessing }
CPPSRIAVisualization >> visibleConnectionsInteractionsMap [

	^ OrderedDictionary
		  with: '1. For this node' -> [ :node | self createNextVisibleLevelLinkFor: node ]
		  with: '2. For all visible nodes' -> [ self obtain groupRecursively visibles nodesDo: [ :node | self createNextVisibleLevelLinkFor: node ] ]
]
