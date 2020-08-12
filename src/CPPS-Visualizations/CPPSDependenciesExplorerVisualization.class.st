"
Description
--------------------

I am a visualization that show and hide dependencies  of an entity or its children.
We can ask for dependencies of this dependencies and tag a entities and its visibles dependencies 
"
Class {
	#name : #CPPSDependenciesExplorerVisualization,
	#superclass : #CPPSVisualization,
	#traits : 'CPPSTDependenciesExplorerVisualization - {#createNeededEntitiesFor:atLevel:}',
	#classTraits : 'CPPSTDependenciesExplorerVisualization classTrait',
	#instVars : [
		'filter',
		'elementsToAnalyze',
		'currentTag'
	],
	#category : #'CPPS-Visualizations-Visualizations'
}

{ #category : #building }
CPPSDependenciesExplorerVisualization >> buildFirstLevelNodes [

	"Here I create the children of the node at the first level because the first time it can be long and we prefere to add some time to the first node generation."

	self allNodes do: [ :node | node childrenGroup do: #childrenGroup ]
]

{ #category : #building }
CPPSDependenciesExplorerVisualization >> buildLegend [

	super buildLegend.
	FamixKindColorStrategy default addBorderLegendToVisualization: self.
	self legend
		description: (self translate: ('External dependencies' french: 'Dépendances externes'))
		forConnectionStyle: (TLStyleSheet new
				 color: MDLColor black;
				 fontSize: '2em')
		icon: '→';
		description: (self translate: ('Internal dependencies' french: 'Dépendances internes'))
		forConnectionStyle: (TLStyleSheet new
				 color: MDLColor black;
				 fontSize: '1em')
		icon: '─█'.
	self
		addLegendForIncomings;
		addLegendForOutgoings
]

{ #category : #building }
CPPSDependenciesExplorerVisualization >> buildVisualization [

	self setGlobalStyle.
	self setAdditionalStyle.
	self title: 'Block Call Analysis'.
	self setLayouts.
	self buildInteractions.
	self setInteractions.
	self buildFirstLevelNodes.
	self buildLegend
]

{ #category : #layout }
CPPSDependenciesExplorerVisualization >> compositeChildrenLayout [

	^ TLLinearLayout
		  gap: 10
		  ratio: 2 / 5
]

{ #category : #building }
CPPSDependenciesExplorerVisualization >> compositeProperty [

	^ [ :each | each childrenForTransitiveExploreEntitesVisualization sorted: [ :child1 :child2 | child1 hasPriorityOn: child2 ] ]
]

{ #category : #actions }
CPPSDependenciesExplorerVisualization >> createLinksFor: node to: aCollection atLevel: aLevel [

	| group |

	group := self groupAtLevel: aLevel.
	aCollection do: [ :each | node connectIfNotTo: (group nodeForEntity: each) ]
]

{ #category : #accessing }
CPPSDependenciesExplorerVisualization >> currentTag [

	^ currentTag value
]

{ #category : #accessing }
CPPSDependenciesExplorerVisualization >> currentTag: aBlock [

	currentTag := aBlock
]

{ #category : #interaction }
CPPSDependenciesExplorerVisualization >> defaultExpandAction [

	^ CPPSDependenciesExplorerExpandCollapseCompositeNodeAction new
]

{ #category : #accessing }
CPPSDependenciesExplorerVisualization >> elementsToAnalyze [

	^ elementsToAnalyze
]

{ #category : #accessing }
CPPSDependenciesExplorerVisualization >> elementsToAnalyze: anObject [

	"reset interactions to avoid  have many time the same interaction when we change the methodsToAnalyze"

	self interactions: OrderedCollection new.
	elementsToAnalyze := Array with: anObject
]

{ #category : #actions }
CPPSDependenciesExplorerVisualization >> entitiesForNextLevelFor: anEntity [

	^ anEntity allProviders
]

{ #category : #actions }
CPPSDependenciesExplorerVisualization >> entity: entity isIn: elementToAnalyse [

	^ entity == elementToAnalyse or:
		  [ elementToAnalyse children anySatisfy:
			  [ :children | 
			  self
				  entity: entity
				  isIn: children
			  ]
		  ]
]

{ #category : #actions }
CPPSDependenciesExplorerVisualization >> entityIsInElementToAnalyze: entity [

	entity ifNil: [ ^ false ].
	^ self elementsToAnalyze anySatisfy:
		  [ :elementToAnalyse | 
		  self
			  entity: entity
			  isIn: elementToAnalyse
		  ]
]

{ #category : #accessing }
CPPSDependenciesExplorerVisualization >> filter [

	^ filter
]

{ #category : #accessing }
CPPSDependenciesExplorerVisualization >> filter: anObject [

	filter := anObject
]

{ #category : #interactions }
CPPSDependenciesExplorerVisualization >> getMultiDrillDownInteractionWithExpandAction: expandAction [

	^ (TLCustomWithParameterAction block:
		   [ :node :choice | 
		   | nodes |

		   nodes := OrderedCollection with: node.
		   1 to: choice asNumber do:
			   [ :i | 
			   | children |

			   children := OrderedCollection new.
			   nodes do:
				   [ :aNode | 
				   expandAction regularActionIfNecessaryOn: aNode.
				   children addAll: (aNode childrenNodes select: [ :n | n isCompositeNode ])
				   ].
			   nodes := children
			   ]
		   ])
		  withMultipleChoices: [ #( '1' '2' '3' ) ]
		  menu: (self
				   translate: 'Drill down n time'
				   french: 'Déplier le noeud n fois')
]

{ #category : #interactions }
CPPSDependenciesExplorerVisualization >> getMultiLinksInteraction [

	^ (TLCustomWithParameterAction block:
		   [ :node :choice | 
		   | nodes |

		   nodes := OrderedCollection with: node.
		   (1 to: choice asNumber) do:
			   [ :i | 
			   nodes do: [ :aNode | self ensureEntitiesAndLinksFor: aNode ].
			   nodes := nodes flatCollect: #outgoingAdjacentNodes
			   ]
		   ])
		  withMultipleChoices: [ #( '1' '2' '3' ) ]
		  menu: (self
				   translate: 'Ask dependencies on n level'
				   french: 'Afficher les dépendances sur n niveaux')
]

{ #category : #interactions }
CPPSDependenciesExplorerVisualization >> linksAction [

	^ TLCustomAction block: [ :node | self ensureEntitiesAndLinksFor: node ]
]

{ #category : #interactions }
CPPSDependenciesExplorerVisualization >> removeAction [

	^ TLCustomAction block: [ :node | self removeNodeAndOutgoing: node ]
]

{ #category : #actions }
CPPSDependenciesExplorerVisualization >> removeNodeAndOutgoing: node [

	"handle error to give a better message for user"

	node outgoingAdjacentNodes do: [ :aNode | self removeNodeAndOutgoing: aNode ].
	node parent remove: node
]

{ #category : #interactions }
CPPSDependenciesExplorerVisualization >> removeOutgoingAction [

	^ TLCustomAction block: [ :node | self removeNodeAndOutgoing: node ]
]

{ #category : #actions }
CPPSDependenciesExplorerVisualization >> selectEntitiesToCreateForNextLevelFrom: aCollection [

	^ aCollection
]

{ #category : #building }
CPPSDependenciesExplorerVisualization >> setAdditionalStyle [

	self styleSheet backgroundColor:
		[ :entity | 
		(entity tags includes: self currentTag)
			ifTrue: [ self currentTag color ]
			ifFalse: [ Color orange lighter alpha: 0.5 ]
		].
	self styleSheet > #connection > #head shape:
		[ :entity :connection | 
		(self entityIsInElementToAnalyze: connection toNode entity)
			ifTrue: [ TLSquare ]
			ifFalse: [ TLTriangle ]
		]
]

{ #category : #initialization }
CPPSDependenciesExplorerVisualization >> setInteractions [

	| expandAction |

	expandAction := self defaultExpandAction
		                condition: [ :drawable | (drawable entity perform: self compositeProperty) isNotEmpty ];
		                yourself.
	self setMenuInteractionsWithExpandAction: expandAction
]

{ #category : #interactions }
CPPSDependenciesExplorerVisualization >> setMenuInteractionsWithExpandAction: expandAction [

	self
		addInteraction: (self linksAction withMenu: (self
						  translate: 'Show outgoing'
						  french: 'Afficher les liens sortants')) propagateToChildren;
		addInteraction: self getMultiLinksInteraction propagateToChildren;
		addInteraction: (self removeAction withMenu: (self
						  translate: 'Remove self and outgoing'
						  french: 'Supprimer le noeud et ses liens sortants')) propagateToChildren;
		addInteraction: (self removeOutgoingAction withMenu: (self
						  translate: 'Remove outgoing'
						  french: 'Supprimer les liens sortants')) propagateToChildren;
		addInteraction: (self tagAction withMenu: (self
						  translate: 'Tag himself and transitively outgoing'
						  french: 'Tagger le noeud et ses liens sortants')) propagateToChildren;
		addInteraction: (self untagAction withMenu: (self
						  translate: 'Untag himself and transitively outgoing'
						  french: 'Détagger le noeud et ses liens sortants')) propagateToChildren;
		addInteraction: (self getMultiDrillDownInteractionWithExpandAction: expandAction) propagateToChildren
]

{ #category : #testing }
CPPSDependenciesExplorerVisualization >> shouldHideWithFilterNode: drawable [

	self filter ifNil: [ ^ false ].
	^ drawable isNode and: [ (drawable entity sourceText includesSubstring: self filter) not ]
]

{ #category : #interactions }
CPPSDependenciesExplorerVisualization >> tagAction [

	^ TLCustomAction block: [ :node | self tagWithOutgoing: node ]
]

{ #category : #actions }
CPPSDependenciesExplorerVisualization >> tagWithOutgoing: aNode [

	self flag: #todo. "handle error to give a better message for user"
	self currentTag ifNil: [ ^ nil ].
	self
		tagWithOutgoing: aNode
		with: self currentTag
]

{ #category : #actions }
CPPSDependenciesExplorerVisualization >> tagWithOutgoing: node with: aTag [

	| taggedEntities |

	taggedEntities := Set new.
	self
		tagWithOutgoing: node
		with: aTag
		storingTaggedEntityIn: taggedEntities.

	"The entities can be linked to multiple nodes in the visualization. Thus, we check all the visible nodes for un update."
	self obtain recursively visibles nodes
		select: [ :each | taggedEntities includes: each entity ]
		thenDo: #requireUpdate
]

{ #category : #actions }
CPPSDependenciesExplorerVisualization >> tagWithOutgoing: node with: aTag storingTaggedEntityIn: aCollection [

	| entity |

	entity := node entity.
	(entity isTaggedWith: self currentTag) ifFalse:
		[ entity tagWith: aTag.
		aCollection add: entity
		].
	node outgoingAdjacentNodes do:
		[ :aNode | 
		self
			tagWithOutgoing: aNode
			with: aTag
			storingTaggedEntityIn: aCollection
		].
	node isComposite ifTrue:
		[ node childrenNodes do:
			[ :child | 
			self
				tagWithOutgoing: child
				with: aTag
				storingTaggedEntityIn: aCollection
			]
		]
]

{ #category : #interactions }
CPPSDependenciesExplorerVisualization >> untagAction [

	^ TLCustomAction block: [ :node | self untagWithOutgoing: node ]
]

{ #category : #actions }
CPPSDependenciesExplorerVisualization >> untagWithOutgoing: aNode [

	self flag: #todo. "handle error to give a better message for user"
	self currentTag ifNil: [ ^ nil ].
	self
		untagWithOutgoing: aNode
		with: self currentTag
]

{ #category : #actions }
CPPSDependenciesExplorerVisualization >> untagWithOutgoing: node with: aTag [

	| taggedEntities |

	taggedEntities := Set new.
	self
		untagWithOutgoing: node
		with: aTag
		storingTaggedEntityIn: taggedEntities.

	"The entities can be linked to multiple nodes in the visualization. Thus, we check all the visible nodes for un update."
	self obtain recursively visibles nodes
		select: [ :each | taggedEntities includes: each entity ]
		thenDo: #requireUpdate
]

{ #category : #actions }
CPPSDependenciesExplorerVisualization >> untagWithOutgoing: node with: aTag storingTaggedEntityIn: aCollection [

	| entity |

	entity := node entity.
	(entity isTaggedWith: self currentTag) ifTrue:
		[ entity removeTag: aTag.
		aCollection add: entity
		].
	node outgoingAdjacentNodes do:
		[ :aNode | 
		self
			untagWithOutgoing: aNode
			with: aTag
			storingTaggedEntityIn: aCollection
		].
	node isComposite ifTrue:
		[ node childrenNodes do:
			[ :child | 
			self
				untagWithOutgoing: child
				with: aTag
				storingTaggedEntityIn: aCollection
			]
		]
]
