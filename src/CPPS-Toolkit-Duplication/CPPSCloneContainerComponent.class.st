"
Description
--------------------

I am a component use to display a table with the containers of code clones. 
In the future it could be a good idea to make me generic in order to create selectionnable tables.

I am a component use by CPPSDuplicationBrowser only for now. If I become generic, every browser could use me.

The user can select some of my entities and click on a button in order  to trigger an action. 

Public API and Key Messages
--------------------

- #containers: aCollectionOfLocation 		This set the list of fragment location that should be display.
- #actionBlock: aBlockOrSymbol 			The action triggered by the button of the component
			
Internal Representation and Key Implementation Points.
--------------------

    Instance Variables
	actionBlock:				<aBlockOrSymbol>			A block with one parameter, the collection of selected locations, executed when the user trigger the button.
	containers:				<aCollectionOfLocations>		The list of clone locations to display.
	selectedContainers:		<aCollection>				The currently selected locations. I should not be an array.

"
Class {
	#name : #CPPSCloneContainerComponent,
	#superclass : #CPPSComponent,
	#instVars : [
		'containers',
		'actionBlock',
		'selectedContainers',
		'owner'
	],
	#category : #'CPPS-Toolkit-Duplication'
}

{ #category : #'instance creation' }
CPPSCloneContainerComponent class >> owner: aComponent actionBlock: aBlock [

	^ self new
		  owner: aComponent;
		  actionBlock: aBlock;
		  yourself
]

{ #category : #accessing }
CPPSCloneContainerComponent >> actionBlock [

	^ actionBlock
]

{ #category : #accessing }
CPPSCloneContainerComponent >> actionBlock: anObject [

	actionBlock := anObject
]

{ #category : #javascript }
CPPSCloneContainerComponent >> ajaxContentReloadingDoing: aBlock from: html [

	^ (html jQuery: '#duplication-content') load
		  html:
			  [ :ajaxHtml | 
			  aBlock value.
			  self owner renderDuplicationContentOn: ajaxHtml
			  ];
		  onComplete: 'componentHandler.upgradeDom();initPrismComponents();initMinimaps();'
]

{ #category : #javascript }
CPPSCloneContainerComponent >> ajaxUpdateOfMainSwitchFrom: html [

	^ (html jQuery id: 'duplication__table') load
		  html:
			  [ :ajaxHtml | 
			  self
				  toggleMainSwitch;
				  renderTableHeaderOn: ajaxHtml;
				  renderTableBodyOn: ajaxHtml
			  ];
		  onComplete: 'componentHandler.upgradeDom();'
]

{ #category : #accessing }
CPPSCloneContainerComponent >> containers [

	^ containers
]

{ #category : #accessing }
CPPSCloneContainerComponent >> containers: aCollection [

	containers := aCollection.
	self selectedContainers: (self defaultSelectionFrom: aCollection)
]

{ #category : #accessing }
CPPSCloneContainerComponent >> defaultSelectionFrom: aCollection [

	"We create a new collection to not point directly the collection from the model. If we point the model, when we will remove an element from the selection it will be removed from the model."

	^ OrderedCollection withAll: aCollection
]

{ #category : #initialization }
CPPSCloneContainerComponent >> initialize [

	super initialize.
	containers := OrderedCollection new "Do not use the accessor here since we don't have the action block yet."
]

{ #category : #accessing }
CPPSCloneContainerComponent >> owner [

	^ owner
]

{ #category : #accessing }
CPPSCloneContainerComponent >> owner: anObject [

	owner := anObject
]

{ #category : #rendering }
CPPSCloneContainerComponent >> renderContentOn: html [

	html mdlTable
		id: #duplication__table;
		with:
			[ self
				renderTableHeaderOn: html;
				renderTableBodyOn: html
			].
	self renderValidationButtonOn: html
]

{ #category : #rendering }
CPPSCloneContainerComponent >> renderHeaderSwitchOn: html [

	html mdlSwitchContainer
		for: html nextId;
		rippleEffect;
		with:
			[ html mdlSwitch
				id: html lastId;
				onClick: (self ajaxUpdateOfMainSwitchFrom: html);
				value: self selectedContainers size = self containers size
			]
]

{ #category : #rendering }
CPPSCloneContainerComponent >> renderSwitchFor: aContainer on: html [

	html mdlSwitchContainer
		for: html nextId;
		rippleEffect;
		with:
			[ html mdlSwitch
				id: html lastId;
				onClick: (html jQuery ajax callback: [ self toggleSelectionOf: aContainer ]);
				value: (self selectedContainers includes: aContainer)
			]
]

{ #category : #rendering }
CPPSCloneContainerComponent >> renderTableBodyOn: html [

	self containers do:
		[ :container | 
		html tableRow:
			[ { 
				[ self
					renderSwitchFor: container
					on: html
				].
				[ html span
					id: html nextId;
					with: container name
				].
				container startLine asString.
				container endLine asString } do: [ :elem | html mdlTableCell: elem ]
			].
		html
			mdlLargeTooltipFor: html lastId
			with: (container entity tooltipIn: self session language)
		]
]

{ #category : #rendering }
CPPSCloneContainerComponent >> renderTableHeaderOn: html [

	html tableHead:
		[ html tableRow:
			[ { 
				[ self renderHeaderSwitchOn: html ].
				(self
					 english: 'Container'
					 french: 'Contenant').
				(self
					 english: 'From'
					 french: 'Depuis').
				(self
					 english: 'To'
					 french: 'À') } do: [ :elem | html mdlTableHeading: elem ]
			]
		]
]

{ #category : #rendering }
CPPSCloneContainerComponent >> renderValidationButtonOn: html [

	self containers ifEmpty: [ ^ self ].
	html div
		class: #'duplication-actionButtons';
		with:
			[ html mdlMajorButton
				onClick: (self
						 ajaxContentReloadingDoing: [ self owner comparisonMode ]
						 from: html);
				with: (self
						 english: 'Compare'
						 french: 'Comparer').
			html mdlMajorButton
				onClick: (self
						 ajaxContentReloadingDoing: [ self owner graphMode ]
						 from: html);
				with: (self
						 english: 'Show graph'
						 french: 'Graphique')
			]
]

{ #category : #accessing }
CPPSCloneContainerComponent >> selectedContainers [

	^ selectedContainers
]

{ #category : #accessing }
CPPSCloneContainerComponent >> selectedContainers: anObject [

	selectedContainers := anObject.
	self validateSelection
]

{ #category : #action }
CPPSCloneContainerComponent >> toggleMainSwitch [

	self selectedContainers size = self containers size
		ifTrue:
			[ self selectedContainers: OrderedCollection new.
			self validateSelection
			]
		ifFalse: [ self selectedContainers: self containers copy ]
]

{ #category : #action }
CPPSCloneContainerComponent >> toggleSelectionOf: container [

	(self selectedContainers includes: container)
		ifTrue: [ self selectedContainers remove: container ]
		ifFalse: [ self selectedContainers add: container ].
	self validateSelection
]

{ #category : #action }
CPPSCloneContainerComponent >> validateSelection [

	(self actionBlock ifNil: [ self error: 'The action block of the clone location table should not be nil.' ]) value: self selectedContainers
]
