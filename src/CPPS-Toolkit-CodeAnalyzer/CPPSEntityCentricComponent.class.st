"
Description
------------------

I am a Component to render everything for an entity depending on it. If the entity is sourced; it will have a tab to display code, if the entity is connected; it will have a tab to display a butterfly showing those connections. If the entity is a class, it will have a quickTagging visualization.

I generate the a Prism and a Cytoscape component from an entity. I an created to be use by a CPPSCodeAnalyzer.

Public API and Key Messages
------------------

- #entity: 		The way to update the components to display the new informations for a new entities.

Example
-----------------

	html render: (CPPSCodeAndVisualizationComponent new entity: anEntity)
 
Internal Representation and Key Implementation Points.
------------------

    Instance Variables
	codeDisplayer:			<aPrismComponent> 		I am a component in charge of the code displaying.
	displayCode:			<aBoolean> 					I am a boolean kept to know if I need to render the code or the visualisation.
	entity:					<anEntity> 					I am the entity needed to display informations.

For now the visualization cannot be store into an instance variable. This wight change in the futur but it will depend on the Telescope connector.
"
Class {
	#name : #CPPSEntityCentricComponent,
	#superclass : #CPPSComponent,
	#instVars : [
		'entity',
		'currentTab',
		'taggingInterval',
		'availablePanels',
		'displayTags',
		'displayDependenciesTags',
		'owner'
	],
	#category : #'CPPS-Toolkit-CodeAnalyzer-TabPanels'
}

{ #category : #'instance creation' }
CPPSEntityCentricComponent class >> owner: aComponent [

	^ self new
		  owner: aComponent;
		  yourself
]

{ #category : #accessing }
CPPSEntityCentricComponent >> announcer [

	^ self owner announcer
]

{ #category : #rendering }
CPPSEntityCentricComponent >> availablePanels [

	^ availablePanels ifNil: [ availablePanels := self defaultAvailablesPanels ]
]

{ #category : #panels }
CPPSEntityCentricComponent >> clearAvailablePanels [

	availablePanels := nil
]

{ #category : #accessing }
CPPSEntityCentricComponent >> currentTab [

	^ currentTab
]

{ #category : #accessing }
CPPSEntityCentricComponent >> currentTab: anObject [

	currentTab := anObject
]

{ #category : #rendering }
CPPSEntityCentricComponent >> defaultAvailablesPanels [

	^ { 
		  (CPPSCodeDisplayPanelComponent newWithParent: self).
		  (CPPSButterflyPanelComponent newWithParent: self).
		  (CPPSQuickTaggingPanelComponent newWithParent: self).
		  (CPPSBlockPanelComponent newWithParent: self) }
]

{ #category : #accessing }
CPPSEntityCentricComponent >> displayDependenciesTags [

	^ displayDependenciesTags
]

{ #category : #accessing }
CPPSEntityCentricComponent >> displayDependenciesTags: anObject [

	displayDependenciesTags := anObject
]

{ #category : #accessing }
CPPSEntityCentricComponent >> displayTags [

	^ displayTags
]

{ #category : #accessing }
CPPSEntityCentricComponent >> displayTags: anObject [

	displayTags := anObject
]

{ #category : #accessing }
CPPSEntityCentricComponent >> entity [

	^ entity
]

{ #category : #accessing }
CPPSEntityCentricComponent >> entity: anEntity [

	entity = anEntity ifFalse:
		[ entity := anEntity.
		self clearAvailablePanels.
		self currentTab: (self availablePanels
				 detect: [ :aPanel | aPanel isSimilarTo: self currentTab ]
				 ifNone:
					 [ self availablePanels
						 ifEmpty: nil
						 ifNotEmpty: [ :panels | panels first ]
					 ])
		]
]

{ #category : #initialization }
CPPSEntityCentricComponent >> initialize [

	super initialize.
	self displayTags: true.
	self displayDependenciesTags: false
]

{ #category : #'as yet unclassified' }
CPPSEntityCentricComponent >> mdlDialogContent: html [

	^ [ html render: self tagListComponent ]
]

{ #category : #accessing }
CPPSEntityCentricComponent >> owner [

	^ owner
]

{ #category : #accessing }
CPPSEntityCentricComponent >> owner: anObject [

	owner == anObject ifTrue: [ ^ self ].
	owner := anObject.
	self announcer
		when: CPPSCodeAnalyzerEntityUpdated
		send: #receiveEntityChangedAnnouncement:
		to: self
]

{ #category : #initialization }
CPPSEntityCentricComponent >> receiveEntityChangedAnnouncement: anAnnouncement [

	self entity: anAnnouncement newEntity
]

{ #category : #rendering }
CPPSEntityCentricComponent >> renderContentOn: html [

	self updatePanelToDisplay.
	html div
		class: #'code-container-panel';
		with:
			[ html mdlTabBar: [ self renderTabsHeaderOn: html ].
			self entity ifNotNil: [ self renderTabContentOn: html ]
			]
]

{ #category : #rendering }
CPPSEntityCentricComponent >> renderTabContentOn: html [

	html mdlTabsPanel
		class: #'code-container-panel__content';
		isActive;
		with:
			[ html render: (self currentTab ifNil:
							 [ self
								 english: 'No browser to display for this entity'
								 french: 'Pas d''affichage disponible pour cette entité'
							 ])
			]
]

{ #category : #rendering }
CPPSEntityCentricComponent >> renderTabsHeaderOn: html [

	self availablePanels do:
		[ :aPanel | 
		aPanel
			renderTabHeaderOf: self
			on: html
		]
]

{ #category : #rendering }
CPPSEntityCentricComponent >> renderTaggingPopupOn: html [

	html mdlDialogTitle: (self
			 english: 'Tag code selection'
			 french: 'Taggez le code selectionné').
	html mdlDialogContent: [ html render: self tagListComponent ].
	html mdlDialogActions:
		[ html mdlButton
			id: self rootDialogCloseId;
			onClick: (html jQuery ajax
					 callback: [ self taggingInterval: nil ];
					 onComplete: 'refreshPrism(document.getElementsByTagName("pre")[0])');
			with: (self
					 english: 'Finish'
					 french: 'Finir')
		]
]

{ #category : #'as yet unclassified' }
CPPSEntityCentricComponent >> tagCurrentIntervalWith: aTag [

	self taggingInterval ifNil: [ ^ self ].
	self entity
		tagWith: aTag
		interval: self taggingInterval
		sourceAnchor: self currentTab sourceAnchor
]

{ #category : #rendering }
CPPSEntityCentricComponent >> tagListComponent [

	^ (CPPSTagListWindowsManagerDecorator
		   tags: [ self tagModel rootTags ]
		   actionBlock: [ :tag | self tagCurrentIntervalWith: tag ]
		   actionTooltipBlock:
			   [ :tag | 
			   (self
				    english: 'Tag with : '
				    french: 'Taggez avec : ') , tag name
			   ]
		   actionLabelBlock:
			   [ :tag | 
			   (self model codeTagAssociations select: [ :assoc | assoc tag = tag and: [ assoc entity = self entity and: [ assoc start = self taggingInterval first and: [ assoc stop = self taggingInterval last ] ] ] ]) asOrderedCollection
				   ifEmpty: [ #label_outline ]
				   ifNotEmpty: [ #label ]
			   ])
		  addTagFilter;
		  addTextFilter;
		  addCreateTagButton
]

{ #category : #accessing }
CPPSEntityCentricComponent >> taggingInterval [

	^ taggingInterval
]

{ #category : #accessing }
CPPSEntityCentricComponent >> taggingInterval: anObject [

	taggingInterval := anObject
]

{ #category : #'as yet unclassified' }
CPPSEntityCentricComponent >> untagCurrentIntervalWith: aTag [

	self taggingInterval ifNil: [ ^ self ].
	entity codeTagAssociations do: [ :int | (aTag = int tag and: [ (int stop < taggingInterval first or: [ int start > taggingInterval last ]) not ]) ifTrue: [ int remove ] ]
]

{ #category : #rendering }
CPPSEntityCentricComponent >> updatePanelToDisplay [

	(self currentTab isNil or: [ self currentTab isUseful not ]) ifTrue:
		[ self currentTab: (self availablePanels
				 detect: [ :aPanel | aPanel isUseful ]
				 ifNone: [ nil ])
		]
]
