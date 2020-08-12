"
Description
--------------------

I am a visualization to display an architecture simulation.
"
Class {
	#name : #CPPSArchitectureVisualization,
	#superclass : #CPPSVisualization,
	#traits : 'CPPSTArchitectureVisualization',
	#classTraits : 'CPPSTArchitectureVisualization classTrait',
	#instVars : [
		'configuration',
		'tagToHighlight',
		'entitiesLinkedToTag',
		'tagsLinkedToTag',
		'borderColorBlock',
		'postBuild'
	],
	#category : #'CPPS-Visualizations-Visualizations-Architecture'
}

{ #category : #accessing }
CPPSArchitectureVisualization class >> configuration: aConfiguration [

	^ self new
		  configuration: aConfiguration;
		  yourself
]

{ #category : #'architecture-manipulation' }
CPPSArchitectureVisualization >> addArchitectureManipulationInteractions: aNodeCreationStrategy [

	self configuration allowArchitectureManipulation ifTrue:
		[ self
			addInteraction: ((TLCustomWithParameterAction
					  block:
						  [ :node :choice | 
						  choice = #Layer
							  ifTrue:
								  [ node
									  addChildNodeFromEntity: (node entity addChild: CPPSArchitectureLayer new)
									  withStrategy: aNodeCreationStrategy
								  ]
							  ifFalse: [ node addChildNodeFromEntity: (node entity addChild: CPPSArchitectureComponent new) ].
						  node expanded: true
						  ]
					  condition: [ :n | n entity isArchitecturalLayer ])
					 withMultipleChoices: [ :aNode | #( 'Layer' 'Component' ) ]
					 menu: (self translate: ('Add' french: 'Ajouter'))) propagateToChildren;
			addInteraction: ((TLCustomAction
					  block:
						  [ :node | 
						  node entity remove.
						  node remove
						  ]
					  condition: [ :n | n entity isArchitecturalElement ]) withMenu: (self translate: ('Remove' french: 'Supprimer'))) propagateToChildren
		]
]

{ #category : #building }
CPPSArchitectureVisualization >> addConnectionsInteractions [

	self setIncomingHighlightStyleTo: self styleSheet > #outgoing.
	self setOutgoingHighlightStyleTo: self styleSheet > #incoming.
	^ { 
		  (self addInteraction: ((TLConnectAction
				     property: [ :n | self obtainEntitiesToConnectFrom: n ]
				     context: [ self obtain recursively visibles nodes ])
				    connectionStyle: #outgoing;
				    withMenu: (self translate: ('Show outgoing dependencies' french: 'Montrer les dépendances sortantes'))) propagateToChildren).
		  (self addInteraction: ((TLConnectAction
				     property: [ :n | self obtainEntitiesToConnectTo: n ]
				     context: [ self obtain recursively visibles nodes ])
				    connectToOrigin: true;
				    connectionStyle: #incoming;
				    withMenu: (self translate: ('Show incoming dependencies' french: 'Montrer les dépendances entrantes'))) propagateToChildren) }
]

{ #category : #accessing }
CPPSArchitectureVisualization >> borderColorBlock [

	^ borderColorBlock ifNil: [ MDLColor black ]
]

{ #category : #accessing }
CPPSArchitectureVisualization >> borderColorBlock: aBlock [

	borderColorBlock := aBlock
]

{ #category : #building }
CPPSArchitectureVisualization >> buildLegend [

	super buildLegend.
	self legend
		backgroundDescription: [ :e | self translate: e multilanguageDisplayName ]
		forNodes: [ self obtain recursively visibles nodes reject: [ :node | node entity isTaggedWith: self tagToHighlight ] ].
	self
		addLegendForChildrenBorderStyle;
		addLegendForOutgoings;
		addLegendForIncomings
]

{ #category : #building }
CPPSArchitectureVisualization >> buildVisualization [

	| connectionInteractions |

	self nodeCreationStrategy
		nodeStyle: [ :e | e style ];
		compositeProperty: [ :aLayer | aLayer architecturalElementsChildrenInModel: self model ];
		beRecursive.
	self defineCommonStyle.
	self defineEntityStyle.
	self defineLayerStyle.
	self defineComponentStyle.
	self defineTagHighlightStyle.
	self addArchitectureManipulationInteractions: self nodeCreationStrategy.
	self addNodesFromEntities: self mainLayer children.
	self addInteraction: TLExpandCollapseCompositeNodeAction onClick propagateToChildren.
	connectionInteractions := self addConnectionsInteractions.
	self addInteraction: (TLCustomAction block:
			 [ :node | 
			 self
				 adaptDependenciesForNode: node
				 interactions: connectionInteractions.
			 self manageTagStyleOnNodes
			 ]) onClick propagateToChildren.
	self styleSheet borderStyle: [ :e :node | node borderStyleForChildrenPresence ].
	self postBuild ifNotNil: [ self postBuild value ].
	self buildLegend
]

{ #category : #tags }
CPPSArchitectureVisualization >> calculateEntitiesLinkedTo: aFamixTag [

	| entities tagsLinked |

	entities := IdentitySet new.
	aFamixTag ifNil: [ ^ entities ].
	(aFamixTag taggedEntitiesInModel: self model) do:
		[ :aTaggedEntity | 
		| currentEntity |

		currentEntity := aTaggedEntity.
		[ currentEntity ] whileNotNil:
			[ entities add: currentEntity.
			currentEntity := [ currentEntity belongsTo ]
				                 on: MessageNotUnderstood
				                 do: [ nil ]
			]
		].
	self entitiesLinkedToTag: entities.
	tagsLinked := self calculateTagsLinkedToEntities: entities.
	tagsLinked addAll: (self tagsCorrespondingToTag: aFamixTag).
	self tagsLinkedToTag: tagsLinked
]

{ #category : #linking }
CPPSArchitectureVisualization >> calculateTagsLinkedToEntities: entities [

	^ self collectParentTagAndHimselfFor: (entities flatCollectAsSet: #tags)
]

{ #category : #tags }
CPPSArchitectureVisualization >> collectParentTagAndHimselfFor: tags [

	| upperLevelTags |

	upperLevelTags := tags.
	[ upperLevelTags isEmpty ] whileFalse:
		[ upperLevelTags := upperLevelTags
			                  collect: #parentTag
			                  thenReject: #isNil.
		tags addAll: upperLevelTags
		].
	^ tags
]

{ #category : #accessing }
CPPSArchitectureVisualization >> configuration [

	^ configuration
]

{ #category : #accessing }
CPPSArchitectureVisualization >> configuration: anObject [

	configuration := anObject
]

{ #category : #building }
CPPSArchitectureVisualization >> defineCommonStyle [

	self styleSheet
		beChildrenRecursive;
		adaptNodeWidthFromLabelWithDefault: 80;
		nodeLabel: [ :n | n name ifNil: [ '' ] ]
		position: #top;
		layout: (TLLinearLayout leftToRight
				 gap: 25;
				 ratio: 16 / 9;
				 yourself)
]

{ #category : #building }
CPPSArchitectureVisualization >> defineComponentStyle [

	(self styleSheet > #component)
		borderColor: self borderColorBlock;
		backgroundColor: CPPSArchitectureComponent backgroundColor;
		childrenLayout: TLLinearLayout
]

{ #category : #building }
CPPSArchitectureVisualization >> defineEntityStyle [

	(self styleSheet > #entity)
		childrenLayout: (TLLinearLayout leftToRight
				 gap: 25;
				 ratio: 16 / 9;
				 yourself);
		backgroundColor: [ :entity | FamixKindColorStrategy default colorFor: entity ]
]

{ #category : #building }
CPPSArchitectureVisualization >> defineLayerStyle [

	(self styleSheet > #layer)
		backgroundColor: CPPSArchitectureLayer backgroundColor;
		borderColor: self borderColorBlock;
		childrenLayout:
			[ :layer | 
			(layer isVertical
				 ifTrue: [ TLLinearLayout topToBottom ]
				 ifFalse: [ TLLinearLayout leftToRight ])
				gap: 25;
				ratio: 16 / 9;
				yourself
			]
]

{ #category : #building }
CPPSArchitectureVisualization >> defineTagHighlightStyle [

	self styleSheet > #tagHighlight backgroundColor: [ :entity | self tagToHighlight color ].
	self styleSheet > #noTagHighlight backgroundColor:
		[ :entity :node | 
		self styleSheet > entity style
			obtainValue: #backgroundColor
			forEntity: entity
			inNode: node
		].
	self styleSheet > #noTagChildrenHighlight borderColor: Color black
]

{ #category : #accessing }
CPPSArchitectureVisualization >> entitiesLinkedToTag [

	^ entitiesLinkedToTag
]

{ #category : #accessing }
CPPSArchitectureVisualization >> entitiesLinkedToTag: anObject [

	entitiesLinkedToTag := anObject
]

{ #category : #tags }
CPPSArchitectureVisualization >> highlightForSearchForNode: node tag: entity [

	self flag: #todo. "This is a hack. For now we implemented a search in the architecture by creating a new tag whose name is the pattern to search and the parent tag is 'researchs'. Then we highlight this tag. The problem is that we cannot tag a tag but some architectural elements points dinectly to tags. In that case we check if it is a reasearch tag and if it is we check if the entity includes the name.
	Later we should use another mechanism but for now we don't have the time."
	^ (self tagToHighlight parentTag isNotNil and: [ self tagToHighlight parentTag name = 'researchs' and: [ entity name includesSubstring: self tagToHighlight name ] ]) ifTrue: [ self setTagHighlightTo: node ]
]

{ #category : #tags }
CPPSArchitectureVisualization >> highlightTag: aFamixTag [

	self tagToHighlight: aFamixTag.
	self manageTagStyleOnNodes.
	[ self update ]
		on: KeyNotFound
		do: [ :e | "We do notheng. This happen because sometime we update before the visu is created and the delegate does not find it." ]
]

{ #category : #tags }
CPPSArchitectureVisualization >> isLinkedToTag: aNode [

	| anArchitectureElement |

	anArchitectureElement := aNode entity.
	^ [ anArchitectureElement modelEntity isTag
		  ifFalse: [ self entitiesLinkedToTag includes: anArchitectureElement modelEntity ]
		  ifTrue:
			  [ (self tagsLinkedToTag includes: anArchitectureElement modelEntity) or:
				  [ self flag: #todo. "The contents of the #or: is really bad. This is a hack. Check the flag in the method #highlightForSearchForNode:tag: to get more informations."
				  self tagToHighlight parentTag isNotNil and: [ self tagToHighlight parentTag name = 'researchs' and: [ (TLDrawableCollection with: aNode) obtain recursively nodes anySatisfy: [ :node | node entity modelEntity name includesSubstring: self tagToHighlight name ] ] ]
				  ]
			  ]
	  ]
		  on: MessageNotUnderstood
		  do: [ self entitiesLinkedToTag includes: anArchitectureElement ]
]

{ #category : #accessing }
CPPSArchitectureVisualization >> mainLayer [

	^ self configuration architecture obtainLayer
]

{ #category : #tags }
CPPSArchitectureVisualization >> manageTagStyleOnNodes [

	self obtain recursively visibles nodesDo:
		[ :node | 
		self removeTagHighlightTo: node.
		self removeTagChildrenHighlightTo: node.
		self tagToHighlight
			ifNotNil:
				[ | entity |

				entity := node entity. " (entity name beginsWith: 'SLM') ifTrue: [1halt]."
				(entity includesAnyTag: { self tagToHighlight })
					ifTrue: [ self setTagHighlightTo: node ]
					ifFalse:
						[ self removeTagHighlightTo: node.
						self
							highlightForSearchForNode: node
							tag: entity
						].
				(self isLinkedToTag: node)
					ifTrue: [ self setTagChildrenHighlightTo: node ]
					ifFalse: [ self removeTagChildrenHighlightTo: node ]
				]
			ifNil:
				[ node addStyle: #noTagHighlight.
				node addStyle: #tagChildrenHighlight
				]
		]
]

{ #category : #accessing }
CPPSArchitectureVisualization >> model [

	^ self configuration version mooseModel
]

{ #category : #dependencies }
CPPSArchitectureVisualization >> obtainEntitiesToConnectFrom: node [

	| possibleNodes providerNodes resultNodes providerEntities providerParentNodes |

	resultNodes := TLDrawableCollection new. "we start from the lowest visibles for performance"
	possibleNodes := self obtain recursively lowestVisibles nodes.
	providerParentNodes := TLDrawableCollection new. "here we will store the parent nodes of the providers"
	[ possibleNodes isNotEmpty ] whileTrue:
		[ providerEntities := node
			                    allProvidersIn: (possibleNodes entities collect:
					                     [ :entity | 
					                     [ entity modelEntity ]
						                     on: MessageNotUnderstood
						                     do: [ entity ]
					                     ]) asMooseGroup
			                    forModel: self model.
		providerNodes := providerEntities
			                 collect:
				                 [ :anEntityToBeConnected | 
				                 possibleNodes detect:
					                 [ :aNode | 
					                 ([ aNode entity modelEntity ]
						                  on: MessageNotUnderstood
						                  do: [ aNode entity ]) = anEntityToBeConnected
					                 ]
				                 ]
			                 as: TLDrawableCollection.
		resultNodes addAll: providerNodes.
		possibleNodes := possibleNodes parentNodes \ (providerParentNodes
			                  addAll: (self obtainHierarchyFrom: providerNodes);
			                  yourself)
		].
	^ resultNodes entities
]

{ #category : #dependencies }
CPPSArchitectureVisualization >> obtainEntitiesToConnectTo: node [

	| possibleNodes providerNodes resultNodes providerEntities providerParentNodes |

	resultNodes := TLDrawableCollection new. "we start from the lowest visibles for performance"
	possibleNodes := self obtain recursively lowestVisibles nodes.
	providerParentNodes := TLDrawableCollection new. "here we will store the parent nodes of the providers"
	[ possibleNodes isNotEmpty ] whileTrue:
		[ providerEntities := node
			                    allClientsIn: (possibleNodes entities collect:
					                     [ :entity | 
					                     [ entity modelEntity ]
						                     on: MessageNotUnderstood
						                     do: [ entity ]
					                     ]) asMooseGroup
			                    forModel: self model.
		providerNodes := providerEntities
			                 collect:
				                 [ :anEntityToBeConnected | 
				                 possibleNodes detect:
					                 [ :aNode | 
					                 ([ aNode entity modelEntity ]
						                  on: MessageNotUnderstood
						                  do: [ aNode entity ]) = anEntityToBeConnected
					                 ]
				                 ]
			                 as: TLDrawableCollection.
		resultNodes addAll: providerNodes.
		possibleNodes := possibleNodes parentNodes \ (providerParentNodes
			                  addAll: (self obtainHierarchyFrom: providerNodes);
			                  yourself)
		].
	^ resultNodes entities
]

{ #category : #building }
CPPSArchitectureVisualization >> obtainHierarchyFrom: providerNodes [

	| parentNodes result |

	result := TLDrawableCollection withAll: (parentNodes := providerNodes parentNodes).
	[ parentNodes isNotEmpty ] whileTrue: [ result addAll: (parentNodes := parentNodes parentNodes) ].
	^ result
]

{ #category : #accessing }
CPPSArchitectureVisualization >> postBuild [

	^ postBuild
]

{ #category : #accessing }
CPPSArchitectureVisualization >> postBuild: aBlock [

	postBuild := aBlock
]

{ #category : #tags }
CPPSArchitectureVisualization >> removeTagChildrenHighlightTo: node [

	node addStyle: #noTagChildrenHighlight
]

{ #category : #tags }
CPPSArchitectureVisualization >> removeTagHighlightTo: node [

	node addStyle: #noTagHighlight
]

{ #category : #tags }
CPPSArchitectureVisualization >> setTagChildrenHighlightTo: node [

	self removeTagChildrenHighlightTo: node.
	node addStyle: #tagChildrenHighlight
]

{ #category : #tags }
CPPSArchitectureVisualization >> setTagHighlightTo: node [

	self removeTagHighlightTo: node.
	node addStyle: #tagHighlight
]

{ #category : #accessing }
CPPSArchitectureVisualization >> tagToHighlight [

	^ tagToHighlight
]

{ #category : #accessing }
CPPSArchitectureVisualization >> tagToHighlight: aTag [

	tagToHighlight := aTag.
	self calculateEntitiesLinkedTo: aTag
]

{ #category : #tags }
CPPSArchitectureVisualization >> tagsCorrespondingToTag: tag [

	| regex |

	tag isSearchTag ifFalse: [ ^ #( #aFamixTag ) ].
	regex := tag name asRegex.
	^ self collectParentTagAndHimselfFor: (self obtain recursively nodes
			   collect: [ :drawable | drawable entity modelEntity ]
			   thenSelect: [ :ent | ent isTag and: [ regex matches: ent name ] ])
]

{ #category : #accessing }
CPPSArchitectureVisualization >> tagsLinkedToTag [

	^ tagsLinkedToTag
]

{ #category : #accessing }
CPPSArchitectureVisualization >> tagsLinkedToTag: anObject [

	tagsLinkedToTag := anObject
]
