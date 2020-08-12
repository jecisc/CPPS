"
Description
--------------------

This visualization shows for a model the complete hierarchy starting from the root directory.
"
Class {
	#name : #CPPSCurrentArchitectureVisualization,
	#superclass : #CPPSVisualization,
	#traits : 'CPPSTArchitectureVisualization',
	#classTraits : 'CPPSTArchitectureVisualization classTrait',
	#instVars : [
		'model'
	],
	#category : #'CPPS-Visualizations-Visualizations-Executive'
}

{ #category : #accessing }
CPPSCurrentArchitectureVisualization >> addConnectionsInteractions [

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

{ #category : #building }
CPPSCurrentArchitectureVisualization >> backgroundColorStrategy [

	^ FamixKindColorStrategy default
]

{ #category : #building }
CPPSCurrentArchitectureVisualization >> buildLegend [

	super buildLegend.
	self backgroundColorStrategy addBackgroundLegendToVisualization: self.
	self
		addLegendForChildrenBorderStyle;
		addLegendForOutgoings;
		addLegendForIncomings
]

{ #category : #building }
CPPSCurrentArchitectureVisualization >> buildVisualization [

	| connectionInteractions |

	self styleSheet
		beChildrenRecursive;
		adaptNodeWidthFromLabelWithDefault: 15;
		nodeLabel: [ :n | n name ifNil: [ '' ] ]
		position: #top;
		backgroundColor: [ :entity | self backgroundColorStrategy colorFor: entity ];
		borderStyle: [ :entity :node | node borderStyleForChildrenPresence ];
		layout: (TLLinearLayout leftToRight
				 gap: 25;
				 ratio: 16 / 9;
				 yourself).
	self setIncomingHighlightStyleTo: self styleSheet > #connection.
	self nodeCreationStrategy
		beRecursive;
		compositeProperty: #sortedChildrenByPriority.
	self addNodesFromEntities: self model allRootContainers.
	self addInteraction: TLExpandCollapseCompositeNodeAction onClick propagateToChildren.
	connectionInteractions := self addConnectionsInteractions.
	self addInteraction: (TLCustomAction block:
			 [ :node | 
			 self
				 adaptDependenciesForNode: node
				 interactions: connectionInteractions
			 ]) onClick propagateToChildren.
	self buildLegend
]

{ #category : #accessing }
CPPSCurrentArchitectureVisualization >> model [

	^ model
]

{ #category : #accessing }
CPPSCurrentArchitectureVisualization >> model: anObject [

	model := anObject
]

{ #category : #dependencies }
CPPSCurrentArchitectureVisualization >> obtainEntitiesToConnectFrom: node [

	| possibleNodes providerNodes resultNodes providerEntities providerParentNodes |

	resultNodes := TLDrawableCollection new. "we start from the lowest visibles for performance"
	possibleNodes := self obtain compositeRecursively lowestVisibles nodes.
	providerParentNodes := TLDrawableCollection new. "here we will store the parent nodes of the providers"
	[ possibleNodes notEmpty ] whileTrue:
		[ providerEntities := node
			                    allProvidersIn: possibleNodes entities asMooseGroup
			                    forModel: self model.
		providerNodes := providerEntities
			                 collect: [ :anEntityToBeConnected | possibleNodes detect: [ :aNode | aNode entity = anEntityToBeConnected ] ]
			                 as: TLDrawableCollection.
		resultNodes addAll: providerNodes.
		possibleNodes := possibleNodes parentNodes \ (providerParentNodes
			                  addAll: (self obtainHierarchyFrom: providerNodes);
			                  yourself)
		].
	^ resultNodes entities
]

{ #category : #dependencies }
CPPSCurrentArchitectureVisualization >> obtainEntitiesToConnectTo: node [

	| possibleNodes providerNodes resultNodes providerEntities providerParentNodes |

	resultNodes := TLDrawableCollection new. "we start from the lowest visibles for performance"
	possibleNodes := self obtain compositeRecursively lowestVisibles nodes.
	providerParentNodes := TLDrawableCollection new. "here we will store the parent nodes of the providers"
	[ possibleNodes notEmpty ] whileTrue:
		[ providerEntities := node
			                    allClientsIn: possibleNodes entities asMooseGroup
			                    forModel: self model.
		providerNodes := providerEntities
			                 collect: [ :anEntityToBeConnected | possibleNodes detect: [ :aNode | aNode entity = anEntityToBeConnected ] ]
			                 as: TLDrawableCollection.
		resultNodes addAll: providerNodes.
		possibleNodes := possibleNodes parentNodes \ (providerParentNodes
			                  addAll: (self obtainHierarchyFrom: providerNodes);
			                  yourself)
		].
	^ resultNodes entities
]

{ #category : #dependencies }
CPPSCurrentArchitectureVisualization >> obtainHierarchyFrom: providerNodes [

	| parentNodes result |

	result := TLDrawableCollection withAll: (parentNodes := providerNodes parentNodes).
	[ parentNodes notEmpty ] whileTrue: [ result addAll: (parentNodes := parentNodes parentNodes) ].
	^ result
]
