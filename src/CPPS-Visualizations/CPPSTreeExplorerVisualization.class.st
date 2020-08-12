"
Description
--------------------

I am a visualization that show all the dependencies of a root with the depth i want.

I am using a strategy design pattern via the SYNTreeExplorerDirectionStrategy to define the behavior related to the direction of the dependencies. 
With this strategy I can display the clients or the providers of the root entity.
"
Class {
	#name : #CPPSTreeExplorerVisualization,
	#superclass : #CPPSVisualization,
	#instVars : [
		'root',
		'directionStrategy',
		'nodeColorStrategy'
	],
	#category : #'CPPS-Visualizations-Visualizations-TreeExplorer'
}

{ #category : #'magic number' }
CPPSTreeExplorerVisualization class >> limitNumberOfNodesToShowByDefault [

	^ 40
]

{ #category : #'instance creation' }
CPPSTreeExplorerVisualization class >> root: anEntity directionStrategy: aStrategy [

	^ self new
		  root: anEntity;
		  directionStrategy: aStrategy;
		  yourself
]

{ #category : #building }
CPPSTreeExplorerVisualization >> buildLegend [

	super buildLegend.
	self nodeColorStrategy addBackgroundLegendToVisualization: self.
	self
		addLegendForOutgoings;
		addLegendForIncomings
]

{ #category : #building }
CPPSTreeExplorerVisualization >> buildVisualization [

	| expandAction |

	self addNodeFromEntity: self root.
	self styleSheet
		noNodeLabel;
		nodeLabelPosition: #top;
		"Interactions can show node labels"width: [ :anEntity | (self directionStrategy childrenOf: anEntity) size * 3 + 5 ];
		backgroundColor: [ :entity | self nodeColorStrategy colorFor: entity ].
	self layout: self directionStrategy layout.
	expandAction := (TLExpandCollapseNodesAction property: [ :entity | self directionStrategy childrenOf: entity ])
		                expandToOrigin: self directionStrategy expandToOrigin;
		                yourself.
	self addInteraction: expandAction onClick.
	self addInteractions: self highlightConnectionsOnMouseOver.
	self initialDeepLevel timesRepeat: [ self allNodes do: [ :aNode | (self directionStrategy childrenOf: aNode entity) size > self limitNumberOfNodesToShowByDefault ifFalse: [ expandAction regularActionIfNecessaryOn: aNode ] ] ].
	self buildLegend
]

{ #category : #accessing }
CPPSTreeExplorerVisualization >> directionStrategy [

	^ directionStrategy
]

{ #category : #accessing }
CPPSTreeExplorerVisualization >> directionStrategy: anObject [

	directionStrategy := anObject
]

{ #category : #initialization }
CPPSTreeExplorerVisualization >> initialDeepLevel [

	^ 2
]

{ #category : #building }
CPPSTreeExplorerVisualization >> limitNumberOfNodesToShowByDefault [

	^ self class limitNumberOfNodesToShowByDefault
]

{ #category : #accessing }
CPPSTreeExplorerVisualization >> nodeColorStrategy [

	^ nodeColorStrategy
]

{ #category : #accessing }
CPPSTreeExplorerVisualization >> nodeColorStrategy: aColorStrategy [

	nodeColorStrategy := aColorStrategy
]

{ #category : #accessing }
CPPSTreeExplorerVisualization >> root [

	^ root
]

{ #category : #accessing }
CPPSTreeExplorerVisualization >> root: anObject [

	root := anObject
]
