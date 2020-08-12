"
Description
--------------------

I am a visualization based on a central element and two groups of elements; one on left; one on right; and both are connected to the central element.

"
Class {
	#name : #CPPSButterflyVisualization,
	#superclass : #CPPSVisualization,
	#instVars : [
		'mainEntity',
		'leftEntities',
		'rightEntities',
		'cyclics',
		'tagActionBlock'
	],
	#category : #'CPPS-Visualizations-Visualizations'
}

{ #category : #'instance creation' }
CPPSButterflyVisualization class >> mainEntity: anEntity [

	^ self new
		  mainEntity: anEntity;
		  yourself
]

{ #category : #building }
CPPSButterflyVisualization >> backgroundColorStrategy [

	^ FamixTagColorStrategy defaultStrategyWithFallback
]

{ #category : #building }
CPPSButterflyVisualization >> borderColorStrategy [

	^ FamixColorStrategy stateThenKindStrategy
]

{ #category : #building }
CPPSButterflyVisualization >> buildInteractions [

	self addInteraction: ((TLCustomAction block: self tagActionBlock) withMenu: 'Tag/Untag with current tag') propagateToChildren
]

{ #category : #building }
CPPSButterflyVisualization >> buildLegend [

	self borderColorStrategy addBorderLegendToVisualization: self.
	self backgroundColorStrategy addBackgroundLegendToVisualization: self.
	self legend
		nodeShapeDescription: [ :ent | self translate: ('Cyclic dependencies' french: 'Dépendances cycliques') ]
		forNodes: [ self obtain recursively nodes select: [ :node | cyclics includes: node entity ] ]
]

{ #category : #building }
CPPSButterflyVisualization >> buildStyle [

	| borderStrategy backgroundStrategy |

	backgroundStrategy := self backgroundColorStrategy.
	borderStrategy := self borderColorStrategy.
	self styleSheet
		nodeLabel: #fullName;
		compositeExpandedByDefault: true;
		backgroundColor: [ :ent | backgroundStrategy colorFor: ent ];
		borderColor: [ :ent | borderStrategy colorFor: ent ];
		borderWidth: 4;
		shape:
			[ :ent | 
			(cyclics includes: ent)
				ifTrue: [ TLEllipse ]
				ifFalse: [ TLRectangle ]
			];
		width: 50;
		height: 30
]

{ #category : #building }
CPPSButterflyVisualization >> buildVisualization [

	| leftEntitiesValues rightEntitiesValues leftEntitiesParents rightEntitiesParents leftEntitiesWithoutParents rightEntitiesWithoutParents |

	leftEntitiesValues := (self
		                       obtain: self leftEntities
		                       on: self mainEntity) asSet.
	rightEntitiesValues := (self
		                        obtain: self rightEntities
		                        on: self mainEntity) asSet.
	cyclics := leftEntitiesValues intersection: rightEntitiesValues.
	leftEntitiesParents := (leftEntitiesValues select: [ :each | each isRoot not ]) groupedBy: #belongsTo.
	rightEntitiesParents := (rightEntitiesValues select: [ :each | each isRoot not ]) groupedBy: #belongsTo.
	leftEntitiesWithoutParents := leftEntitiesValues select: #isRoot.
	rightEntitiesWithoutParents := rightEntitiesValues select: #isRoot.
	(self > #left) nodeCreationStrategy compositeProperty:
		[ :anEntity | 
		leftEntitiesParents
			at: anEntity
			ifAbsent: [ #(  ) ]
		].
	(self > #left)
		addNodesFromEntities: leftEntitiesParents keys;
		addNodesFromEntities: leftEntitiesWithoutParents.
	self > #central addNodeFromEntity: self mainEntity.
	(self > #right) nodeCreationStrategy compositeProperty:
		[ :anEntity | 
		rightEntitiesParents
			at: anEntity
			ifAbsent: [ #(  ) ]
		].
	(self > #right)
		addNodesFromEntities: rightEntitiesParents keys;
		addNodesFromEntities: rightEntitiesWithoutParents.
	(self > #left) allChildrenNodes connectTo: self > #central.
	((self > #left) allNodes select: [ :each | each entity isRoot ]) connectTo: self > #central.
	self > #central connectTo: (self > #right) allChildrenNodes.
	self > #central connectTo: ((self > #right) allNodes select: [ :each | each entity isRoot ]).
	self configLabelPosition.
	(self > #right) allChildrenNodes , (self > #left) allChildrenNodes , (self > #central) nodes do: [ :node | node styleSheet nodeLabel: #name ].
	self buildInteractions.
	self buildStyle.
	self buildLegend
]

{ #category : #label }
CPPSButterflyVisualization >> configLabelPosition [

	((self > #left) styleSheet > #children)
		nodeLabelPosition: #left;
		labelSize: 15.
	((self > #right) styleSheet > #children)
		nodeLabelPosition: #right;
		labelSize: 15.
	self styleSheet
		nodeLabelPosition: #top;
		labelSize: 25
]

{ #category : #layout }
CPPSButterflyVisualization >> configLayout [

	self > #left layout: (TLLinearLayout topToBottom gap: 60).
	(self > #left) styleSheet childrenLayout: TLLinearLayout topToBottom.
	self > #central layout: (TLLinearLayout topToBottom gap: 60).
	self > #right layout: (TLLinearLayout topToBottom gap: 60).
	(self > #right) styleSheet childrenLayout: TLLinearLayout topToBottom.
	self layout: (TLLinearLayout gap: 250)
]

{ #category : #initialization }
CPPSButterflyVisualization >> initialize [

	super initialize.
	self
		leftEntities: [ :anEntity | anEntity allClients sorted: #name ascending ];
		rightEntities: [ :anEntity | anEntity allProviders sorted: #name ascending ]
]

{ #category : #accessing }
CPPSButterflyVisualization >> leftEntities [

	^ leftEntities
]

{ #category : #accessing }
CPPSButterflyVisualization >> leftEntities: anObject [

	leftEntities := anObject
]

{ #category : #accessing }
CPPSButterflyVisualization >> mainEntity [

	^ mainEntity
]

{ #category : #accessing }
CPPSButterflyVisualization >> mainEntity: anObject [

	mainEntity := anObject
]

{ #category : #accessing }
CPPSButterflyVisualization >> rightEntities [

	^ rightEntities
]

{ #category : #accessing }
CPPSButterflyVisualization >> rightEntities: anObject [

	rightEntities := anObject
]

{ #category : #accessing }
CPPSButterflyVisualization >> tagActionBlock [

	^ tagActionBlock
]

{ #category : #accessing }
CPPSButterflyVisualization >> tagActionBlock: anObject [

	tagActionBlock := anObject
]
