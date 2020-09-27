Class {
	#name : #CPPSClassSplitter,
	#superclass : #CPPSAbstractBrowser,
	#traits : 'TFilterBrowser + TRightTabsPanelBrowser',
	#classTraits : 'TFilterBrowser classTrait + TRightTabsPanelBrowser classTrait',
	#instVars : [
		'selectedVisuClass',
		'rightPanel',
		'toolbar',
		'currentVisualization',
		'addedEntities'
	],
	#category : #'CPPS-Toolkit-ClassSplitter'
}

{ #category : #accessing }
CPPSClassSplitter class >> browserName [

	^ 'Class Splitter' french: 'Coupeur de Classes'
]

{ #category : #accessing }
CPPSClassSplitter class >> priority [

	^ 95
]

{ #category : #accessing }
CPPSClassSplitter >> addedEntities [

	^ addedEntities
]

{ #category : #accessing }
CPPSClassSplitter >> allVisusClasses [

	^ CPPSClassSplitterVisualization visualizations
]

{ #category : #accessing }
CPPSClassSplitter >> browserClass [

	"An html class to distinguish the browser for the css"

	^ 'class-splitter'
]

{ #category : #accessing }
CPPSClassSplitter >> currentVisualization [

	^ currentVisualization
]

{ #category : #accessing }
CPPSClassSplitter >> currentVisualization: anObject [

	currentVisualization := anObject
]

{ #category : #components }
CPPSClassSplitter >> defaultToolbar [

	^ MDLVerticalToolbar buttons: { 
			  ((MDLFoldButton for: '#' , self rightPanelId)
				   resetVisusOnFold;
				   fold;
				   yourself).
			  (self
				   switcherButton: 'Propagation'
				   tooltip: (self
						    english: 'This panel allows one to automatically propagate the tags of entities.'
						    french: 'Ce panneau permet de propager automatiquement les tags des entités.')
				   perform: #setDefaultRightPanel) }
]

{ #category : #initialization }
CPPSClassSplitter >> initialize [

	self flag: #todo. "We should filter the entities without any interesting property in the list. Since it will change for each visu we should ask to the visu to do the filtering."
	super initialize.
	self initializeFilterBrowser.
	self initializeRightPanel.
	self resetAddedEntities.
	self model announcer weak
		when: FamixTagModifiedAnnouncement
		send: #tagUpdated
		to: self
]

{ #category : #rendering }
CPPSClassSplitter >> renderAddButtonFor: entity on: html [

	html mdlButton
		accentColor;
		onClick: (html jQuery ajax callback:
					 [ self currentVisualization
						 addToVisible: entity;
						 update.
					 self addedEntities add: entity
					 ]);
		icon: #add_circle_outline
]

{ #category : #rendering }
CPPSClassSplitter >> renderBrowserContentOn: html [

	html div
		beGrowing;
		with:
			[ html mdlTabBar:
					[ self allVisusClasses do:
							[ :aVisuClass | 
							html mdlTab
								class: 'activeByHand'
								if: self selectedVisuClass = aVisuClass;
								callback: [ self selectedVisuClass: aVisuClass ];
								with: (self translate: aVisuClass title)
							]
					].
			self renderVisuOn: html
			].
	self renderRightPanelOn: html.
	self
		bindNestedListKeysOfId: self filterBrowserTreeId
		on: html
]

{ #category : #rendering }
CPPSClassSplitter >> renderVisuOn: html [

	self resetCurrentVisualization.
	html render: ((TLCytoscapeComponent visualization: self currentVisualization)
			 withPNGExport;
			 yourself)
]

{ #category : #initialization }
CPPSClassSplitter >> resetAddedEntities [

	addedEntities := Set new
]

{ #category : #initialization }
CPPSClassSplitter >> resetCurrentVisualization [

	"We need to hold the visualization to be able to propagate the tags later, but we need to reset it if the user change of entity or of tab.
	To not get complexe code, we just reset it a each rendering via this method."

	| userSession |

	userSession := self session.
	currentVisualization := (self selectedVisuClass
		                         entity: self selectedEntity
		                         subEntities: self addedEntities)
		                        language: self session language;
		                        model: self model;
		                        addInteraction: ((TLSeasideCallBackAction block:
					                          [ :aNode | 
					                          self
						                          displayBrowserClass: CPPSCodeAnalyzer
						                          onEntity: aNode entity
					                          ]) withMenu: 'Open the Code Analyzer on it') propagateToChildren;
		                        tagActionBlock:
			                        [ :aNode | 
			                        userSession currentTag ifNotNil:
					                        [ :tag | 
					                        (aNode entity isTaggedWith: tag)
						                        ifTrue: [ "means that the entity is already tagged with the current tag. actions is to untag the entity" aNode entity removeTags ]
						                        ifFalse:
							                        [ "means that the entity is not yet tagged with the current tag. actions is to tag the entity"
							                        aNode entity removeTags.
							                        aNode entity tagWith: tag
							                        ]
					                        ]
			                        ]
]

{ #category : #accessing }
CPPSClassSplitter >> rightPanel [

	^ rightPanel
]

{ #category : #accessing }
CPPSClassSplitter >> rightPanel: aComponent [

	rightPanel := aComponent
]

{ #category : #accessing }
CPPSClassSplitter >> selectedEntity: anEntity [

	self tree selectedEntity: anEntity.
	self resetAddedEntities.
	self addedEntities add: anEntity

	"This happen at the first rendering."
	"	self currentVisualization elementsToAnalyze ifEmpty: [ self visuComponent visualization elementsToAnalyze: self addedEntities ]"
]

{ #category : #accessing }
CPPSClassSplitter >> selectedVisuClass [

	^ selectedVisuClass ifNil: [ self allVisusClasses first ]
]

{ #category : #accessing }
CPPSClassSplitter >> selectedVisuClass: anObject [

	selectedVisuClass := anObject.
	self tree rightIconBlock: (selectedVisuClass supportMultipleEntities
			 ifTrue:
				 [ [ :ent :html | 
				 self
					 renderAddButtonFor: ent
					 on: html
				 ]
				 ]
			 ifFalse: [ nil ])
]

{ #category : #components }
CPPSClassSplitter >> setDefaultRightPanel [

	self rightPanel: (CPPSCSTagPropagationRightPanel owner: self)
]

{ #category : #update }
CPPSClassSplitter >> tagUpdated [

	[ self currentVisualization ifNotNil: #refreshOnTagUpdates ]
		on: KeyNotFound
		do: [ "This can happen if a visu was closed but still in the browser." ]
]

{ #category : #accessing }
CPPSClassSplitter >> toolbar [

	^ toolbar
]

{ #category : #accessing }
CPPSClassSplitter >> toolbar: aComponent [

	toolbar := aComponent
]
