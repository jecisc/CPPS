"
Description
--------------------

I am a visualization to show all the tags of the users and I allow to drill down in those tags to show subtags and tagged entities.
"
Class {
	#name : #CPPSTagVisualization,
	#superclass : #CPPSVisualization,
	#instVars : [
		'tags',
		'model'
	],
	#category : #'CPPS-Visualizations-Visualizations'
}

{ #category : #'magic number' }
CPPSTagVisualization class >> limitNumberOfNodesToShowByDefault [

	^ 40
]

{ #category : #scripting }
CPPSTagVisualization class >> tags: aCollection [

	^ self new
		  tags: aCollection;
		  yourself
]

{ #category : #scripting }
CPPSTagVisualization class >> tags: aCollection model: aBlock [

	^ self new
		  tags: aCollection;
		  model: aBlock;
		  yourself
]

{ #category : #scripting }
CPPSTagVisualization class >> tags: aCollection model: aBlock language: aLang [

	^ self new
		  tags: aCollection;
		  model: aBlock;
		  language: aLang;
		  yourself
]

{ #category : #building }
CPPSTagVisualization >> buildLegend [

	super buildLegend.
	self legend
		description: (self translate: ('Composite tag' french: 'Tag composite'))
		forBorderShape: TLDashedLineStyle;
		backgroundDescription: [ :entity | entity class englishName ]
		forNodes: [ self obtain recursively nodes select: [ :node | node isVisible and: [ node entity isTag not ] ] ];
		nodeShapeDescription:
			[ :entity | 
			entity isTag
				ifTrue: [ 'Tag' ]
				ifFalse: [ 'Entity' ]
			]
		forNodes: [ self obtain recursively nodes select: #isVisible ]
]

{ #category : #building }
CPPSTagVisualization >> buildVisualization [

	| expandAction |

	self addNodesFromEntities: self tags.
	self styleSheet
		nodeLabel: #name;
		labelSize: [ :entity | self class dynamicFontSizeFor: entity name ];
		nodeLabelPosition: #top;
		width: 90;
		height:
			[ :entity | 
			entity isTag
				ifTrue: [ 45 ]
				ifFalse: [ 90 ]
			];
		backgroundColor:
			[ :entity | 
			entity isTag
				ifTrue: [ entity color ]
				ifFalse: [ FamixKindColorStrategy default colorFor: entity ]
			];
		shape: #cytoscapeShape;
		borderStyle:
			[ :tag | 
			(tag isTag and: [ tag isComposite ])
				ifTrue: [ TLDashedLineStyle ]
				ifFalse: [ TLSolidLineStyle ]
			].
	self styleSheet > #connection width: 5.
	self layout: (TLTreeLayout new
			 useOutgoingLinks;
			 leavesGap: 150;
			 levelGap: 200;
			 yourself).
	expandAction := TLExpandCollapseNodesAction property: [ :entity | self childrenOf: entity ].
	self addAllInteractions: { 
			expandAction onClick.
			(TLPopUpAction text: [ :e | e tooltipIn: self language ]) onMouseOver }.
	self initialDeepLevel timesRepeat: [ self allNodes do: [ :aNode | (self childrenOf: aNode entity) size > self limitNumberOfNodesToShowByDefault ifFalse: [ expandAction regularActionIfNecessaryOn: aNode ] ] ].
	self buildLegend
]

{ #category : #building }
CPPSTagVisualization >> childrenOf: anEntity [

	^ anEntity isTag
		  ifTrue: [ anEntity subTags , (anEntity taggedEntitiesInModel: self model) ]
		  ifFalse: [ anEntity children ]
]

{ #category : #initialization }
CPPSTagVisualization >> initialDeepLevel [

	^ 2
]

{ #category : #'magic number' }
CPPSTagVisualization >> limitNumberOfNodesToShowByDefault [

	^ self class limitNumberOfNodesToShowByDefault
]

{ #category : #accessing }
CPPSTagVisualization >> model [

	^ model value
]

{ #category : #accessing }
CPPSTagVisualization >> model: anObject [

	model := anObject
]

{ #category : #accessing }
CPPSTagVisualization >> tags [

	^ tags
]

{ #category : #accessing }
CPPSTagVisualization >> tags: anObject [

	tags := anObject
]
