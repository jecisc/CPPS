"
Description
--------------------

I am the Tree Explorer component, that allow you to visualize the impact of a modification and all my dependencies by an explorative way.

I hold a direction strategy the user can customize. This strategy will be used to determine if the visualization should display the clients or the providers of the selected entity.
"
Class {
	#name : #CPPSTreeExplorer,
	#superclass : #CPPSAbstractBrowser,
	#traits : 'TFilterBrowser + TRightTabsPanelBrowser',
	#classTraits : 'TFilterBrowser classTrait + TRightTabsPanelBrowser classTrait',
	#instVars : [
		'root',
		'toolbar',
		'rightPanel',
		'directionStrategy',
		'nodeColorStrategy'
	],
	#category : #'CPPS-Toolkit-Executive'
}

{ #category : #accessing }
CPPSTreeExplorer class >> browserName [

	^ 'Tree Explorer' french: 'Explorateur de dépendances'
]

{ #category : #accessing }
CPPSTreeExplorer class >> priority [

	^ 40
]

{ #category : #accessing }
CPPSTreeExplorer >> browserClass [

	"An html class to distinguish the browser for the css"

	^ #'tree-explorer'
]

{ #category : #components }
CPPSTreeExplorer >> defaultToolbar [

	^ MDLVerticalToolbar buttons: { 
			  ((MDLFoldButton for: '#' , self rightPanelId)
				   resetVisusOnFold;
				   fold;
				   yourself).
			  (self
				   switcherButton: 'Options'
				   tooltip: (self
						    english: 'This panel allows one to customize the visualization'
						    french: 'Ce panneau permet de propager automatiquement les tags des entités.')
				   perform: #setDefaultRightPanel) }
]

{ #category : #components }
CPPSTreeExplorer >> defaultTreeComponent [

	^ (MDLNestedList
		   elements: #(  )
		   children: [ :elem | elem sortedChildrenByPriority reject: [ :entity | entity allProviders isEmpty ] ])
		  withResearchField;
		  format: #name;
		  helpBlock: [ :entity | entity tooltipIn: self session language ];
		  actionBlock: [ :entity | self selectedEntity: entity ];
		  iconBlock: #iconComponent;
		  yourself
]

{ #category : #accessing }
CPPSTreeExplorer >> directionStrategy [

	^ directionStrategy
]

{ #category : #accessing }
CPPSTreeExplorer >> directionStrategy: anObject [

	directionStrategy := anObject
]

{ #category : #initialization }
CPPSTreeExplorer >> initialize [

	super initialize.
	self initializeFilterBrowser.
	self initializeRightPanel.
	directionStrategy := CPPSTreeExplorerDirectionStrategy defaultStrategy.
	nodeColorStrategy := FamixKindColorStrategy defaultStrategyWithFallback
]

{ #category : #accessing }
CPPSTreeExplorer >> nodeColorStrategy [

	^ nodeColorStrategy
]

{ #category : #accessing }
CPPSTreeExplorer >> nodeColorStrategy: anObject [

	nodeColorStrategy := anObject
]

{ #category : #rendering }
CPPSTreeExplorer >> renderBrowserContentOn: html [

	html div
		beGrowing;
		with:
			[ html render: ((TLCytoscapeComponent visualization: self treeExplorerVisu)
						 withPNGExport;
						 yourself)
			].
	self renderRightPanelOn: html.
	self
		bindNestedListKeysOfId: self filterBrowserTreeId
		on: html
]

{ #category : #accessing }
CPPSTreeExplorer >> rightPanel [

	^ rightPanel
]

{ #category : #accessing }
CPPSTreeExplorer >> rightPanel: aComponent [

	rightPanel := aComponent
]

{ #category : #accessing }
CPPSTreeExplorer >> root [

	^ root ifNil:
		  [ self tree elements: ((self strategy entitiesForTreeExplorerFrom: self model) reject: [ :entity | entity allProviders isEmpty ]) asOrderedCollection.
		  self selectedEntity: self tree elements anyOne.
		  root
		  ]
]

{ #category : #accessing }
CPPSTreeExplorer >> root: anObject [

	root := anObject
]

{ #category : #accessing }
CPPSTreeExplorer >> selectedEntity: anEntity [

	self tree selectedEntity: anEntity.
	self root: anEntity
]

{ #category : #components }
CPPSTreeExplorer >> setDefaultRightPanel [

	self rightPanel: (CPPSTreeExplorerOptionsRightPanel owner: self)
]

{ #category : #accessing }
CPPSTreeExplorer >> toolbar [

	^ toolbar
]

{ #category : #accessing }
CPPSTreeExplorer >> toolbar: aComponent [

	toolbar := aComponent
]

{ #category : #components }
CPPSTreeExplorer >> treeExplorerVisu [

	^ (CPPSTreeExplorerVisualization
		   root: self root
		   directionStrategy: self directionStrategy)
		  language: self session language;
		  nodeColorStrategy: self nodeColorStrategy;
		  addInteraction: (TLSeasideCallBackAction block:
					   [ :node | 
					   self session rootComponent
						   displayBrowserClass: CPPSCodeAnalyzer
						   withSelection: { node entity }
					   ]) onRightClick;
		  yourself
]
