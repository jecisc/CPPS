"
Description
--------------------

I am an abstract class representing visualizations used to help a user to split a god entity.

Those visualization are used to group the children of the entity by groups to extract.
Each of my subclasses will use a different way to group.
For exemple, by doing correlations on the state of the god entity or on the use of the god entity.

 
Internal Representation and Key Implementation Points.
--------------------

    Instance Variables
	allClassChildrenNodesCache:		<aCollection>		I am a cache containing the list of all children nodes in the visualization. I am reseted at each building.
	classToAnalyze:						<aFamixEntity>		I am the main famix entity to analyze. In general I am a Class since most god entities are god classes.
	tagActionBlock:						<aBlock>				I am an action to launch to tag an entity.

"
Class {
	#name : #CPPSSimpleClassSplitterVisualization,
	#superclass : #CPPSClassSplitterVisualization,
	#instVars : [
		'classToAnalyze',
		'allClassChildrenNodesCache'
	],
	#category : #'CPPS-Visualizations-Visualizations-ClassSplitter'
}

{ #category : #'instance creation' }
CPPSSimpleClassSplitterVisualization class >> entity: aClass [

	^ self new
		  classToAnalyze: aClass;
		  yourself
]

{ #category : #'instance creation' }
CPPSSimpleClassSplitterVisualization class >> entity: aClass subEntities: _ [

	^ self entity: aClass
]

{ #category : #testing }
CPPSSimpleClassSplitterVisualization class >> isAbstract [

	^ self = CPPSSimpleClassSplitterVisualization
]

{ #category : #building }
CPPSSimpleClassSplitterVisualization >> allClassChildrenNodes [

	^ allClassChildrenNodesCache ifNil: [ allClassChildrenNodesCache := (self > #class) allChildrenNodes ]
]

{ #category : #building }
CPPSSimpleClassSplitterVisualization >> buildInteractions [

	(self > #class)
		addInteraction: ((TLCustomAction block: [ :node | node entity removeTags ]) withMenu: 'Detag') propagateToChildren;
		addInteraction: (TLCustomAction block: self tagActionBlock) onClick propagateToChildren.
	self allClassChildrenNodes
		addInteraction: (TLStyleCustomizationAction
				 custom:
					 [ :style | 
					 style
						 borderColor: MDLColor orange;
						 borderWidth: 5
					 ]
				 target: [ :aDrawable | self allClassChildrenNodes select: [ :node | node entity = aDrawable entity ] ]) onMouseOver;
		addInteraction: (TLPopUpAction text:
				 [ :child :node | 
				 self
					 popUpTextForNode: node
					 withChild: child
				 ]) onMouseOver
]

{ #category : #building }
CPPSSimpleClassSplitterVisualization >> buildLegend [

	super buildLegend.
	self backgroundColorStrategy addBackgroundLegendToVisualization: self
]

{ #category : #building }
CPPSSimpleClassSplitterVisualization >> buildVisualization [

	super buildVisualization.
	allClassChildrenNodesCache := nil. "Invalidate caches at each building"
	(self > #class)
		childrenProperty: [ :ent | self containedEntitiesOf: ent ];
		addNodesFromEntities: (self entitiesToShow sorted: [ :a :b | (self containedEntitiesOf: a) size > (self containedEntitiesOf: b) size ]).
	(self > #class) styleSheet
		expandCompositeNodes;
		nodeLabel: #name
		position: #top;
		layout: (TLLinearLayout
				 gap: 100
				 ratio: 4 / 3);
		backgroundColor: [ :anEntity | self backgroundColorStrategy colorFor: anEntity ].
	((self > #class) styleSheet > #children)
		noNodeLabel;
		layout: (TLLinearLayout ratio: 4 / 3).
	self buildInteractions
]

{ #category : #accessing }
CPPSSimpleClassSplitterVisualization >> classToAnalyze [

	^ classToAnalyze
]

{ #category : #accessing }
CPPSSimpleClassSplitterVisualization >> classToAnalyze: anObject [

	classToAnalyze := anObject
]

{ #category : #accessing }
CPPSSimpleClassSplitterVisualization >> containedEntitiesOf: anEntity [

	"I get as parameter the entity represented by the nodes at the first depth level of the visualization and I should return the entities that should be contained by this entity."

	^ self subclassResponsibility
]

{ #category : #accessing }
CPPSSimpleClassSplitterVisualization >> entitiesToShow [

	"I should return the list of entities to show at the first depth level of the visualization."

	^ self subclassResponsibility
]

{ #category : #accessing }
CPPSSimpleClassSplitterVisualization >> popUpTextForNode: aNode withChild: aChild [

	"I should return the content of the popup that will show when the user will mouse over the nodes at the second depth level."

	^ self subclassResponsibility
]

{ #category : #interaction }
CPPSSimpleClassSplitterVisualization >> refreshOnTagUpdates [

	self > #class allNodesRecursivelyDo: [ :aMethodNode | aMethodNode requireUpdate ].
	self update
]
