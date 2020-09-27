"
Description
--------------------

I am a panel that display the code of the entity
"
Class {
	#name : #CPPSCodeDisplayPanelComponent,
	#superclass : #CPPSEntityCentricPanelComponent,
	#instVars : [
		'prismComponent',
		'sourceAnchor'
	],
	#category : #'CPPS-Toolkit-CodeAnalyzer-TabPanels'
}

{ #category : #'instance creation' }
CPPSCodeDisplayPanelComponent class >> newWithParent: aParent sourceAnchor: sourceAnchor [

	^ (self newWithParent: aParent)
		  sourceAnchor: sourceAnchor;
		  yourself
]

{ #category : #title }
CPPSCodeDisplayPanelComponent class >> panelTitle [

	^ 'Code' french: 'Code'
]

{ #category : #comparing }
CPPSCodeDisplayPanelComponent >> = anObject [

	^ super = anObject and:
		  [ (self entity hasSourceAnchor and: [ anObject entity hasSourceAnchor ])
			  ifTrue: [ self sourceAnchor = anObject sourceAnchor ]
			  ifFalse: [ self entity sourceText = anObject entity sourceText ]
		  ]
]

{ #category : #prism }
CPPSCodeDisplayPanelComponent >> backgroundColorCssFor: tags [

	^ String streamContents:
		  [ :s | 
		  s << 'style="'.
		  tags size > 1
			  ifTrue:
				  [ { '-webkit-'. '-o-'. '-moz-'. '' } do:
					  [ :vendor | 
					  s
						  << 'background-image: ';
						  << vendor;
						  << 'linear-gradient(left, ';
						  << (', ' join: (tags collect: [ :e | e color asRGBA: 0.5 ]));
						  << ');'
					  ]
				  ]
			  ifFalse:
				  [ s
					  << 'background-color: ';
					  << (tags anyOne color asRGBA: 0.5)
				  ].
		  s << '"; '
		  ]
]

{ #category : #testing }
CPPSCodeDisplayPanelComponent >> computeIsUseful [

	self entity ifNil: [ ^ false ].
	^ self entity hasSourceAnchor or: [ self entity sourceText isEmptyOrNil not ]
]

{ #category : #prism }
CPPSCodeDisplayPanelComponent >> currentSourceAnchor [

	^ self sourceAnchor ifNil: [ self entity sourceAnchor ]
]

{ #category : #components }
CPPSCodeDisplayPanelComponent >> defaultPrismComponent [

	^ (PrismComponent new
		   sourceCode: [ self sourceText ];
		   addStrategy: self prismIntervalTagsStrategy;
		   addStrategy: self prismAssociationsStrategy;
		   language: self strategy languageClass)
		  addMenu:
			  [ :html | 
			  html text: (self
					   english: 'Tag selection'
					   french: 'Tagger la selection')
			  ]
		  action: self prismTagMenuAction;
		  addMenu:
			  [ :html | 
			  html text: (self
					   english: 'Tag Remove'
					   french: 'Retirer un tag')
			  ]
		  action: self prismUntagMenuAction
		  if: [ self currentTag isNotNil ];
		  addMenu:
			  [ :html | 
			  html text: (self
					   english: 'Cancel'
					   french: 'Annuler')
			  ]
		  action: (PrismMenu new callback: [  ]);
		  withMinimap;
		  withMDLSearchBar;
		  yourself
]

{ #category : #accessing }
CPPSCodeDisplayPanelComponent >> displayDependenciesTags [

	^ self parent displayDependenciesTags
]

{ #category : #accessing }
CPPSCodeDisplayPanelComponent >> displayDependenciesTags: aBoolean [

	self parent displayDependenciesTags: aBoolean
]

{ #category : #accessing }
CPPSCodeDisplayPanelComponent >> displayTags [

	^ self parent displayTags
]

{ #category : #accessing }
CPPSCodeDisplayPanelComponent >> displayTags: aBoolean [

	self parent displayTags: aBoolean
]

{ #category : #prism }
CPPSCodeDisplayPanelComponent >> getAllOutgoingAssociationsForCurrentEntity [

	"We only select the associations with a source anchor and a tagged target."

	^ self sourceAnchor
		  ifNil: [ #(  ) ]
		  ifNotNil: [ self entity queryAllOutgoing select: [ :each | (each allTargets anySatisfy: #isTagged) and: [ each sourceAnchor isNotNil and: [ each sourceAnchor fileName = self currentSourceAnchor fileName ] ] ] ]
]

{ #category : #accessing }
CPPSCodeDisplayPanelComponent >> hasMultipleFiles [

	^ self entity hasSourceAnchor and: [ self entity sourceAnchor isMultiple ]
]

{ #category : #comparing }
CPPSCodeDisplayPanelComponent >> isSimilarTo: aEntityCentricPanelComponent [

	^ (super isSimilarTo: aEntityCentricPanelComponent) and:
		  [ [ self sourceAnchor fileReference extension = aEntityCentricPanelComponent sourceAnchor fileReference extension ]
			  on: MessageNotUnderstood
			  do: [ false "here we have an uninitialized source anchor that access to the multiple file" ]
		  ]
]

{ #category : #title }
CPPSCodeDisplayPanelComponent >> panelTitle [

	^ self hasMultipleFiles
		  ifTrue: [ 'Code of' french: 'Code de ' ]
		  ifFalse:
			  [ | name |

			  name := self sourceAnchor fileReference basename.
			  name french: name
			  ]
]

{ #category : #prism }
CPPSCodeDisplayPanelComponent >> prismAssociationsStrategy [

	^ PrismComponentStyleStrategy new
		  objects: [ self getAllOutgoingAssociationsForCurrentEntity ];
		  positionFunction: [ :access | self prismPositionForAssociation: access ];
		  style: [ :interval | self backgroundColorCssFor: (interval object allTargets flatCollectAsSet: #tags) ];
		  miniMapColor: [ :interval | "Maybe later this should be improved, but for now, in the minimap, we select the tag color of a random entity." FamixTagColorStrategy default colorFor: interval object allTargets anyOne ];
		  condition: [ self displayDependenciesTags ];
		  yourself
]

{ #category : #accessing }
CPPSCodeDisplayPanelComponent >> prismComponent [

	^ prismComponent ifNil: [ prismComponent := self defaultPrismComponent ]
]

{ #category : #accessing }
CPPSCodeDisplayPanelComponent >> prismComponent: anObject [

	prismComponent := anObject
]

{ #category : #prism }
CPPSCodeDisplayPanelComponent >> prismIntervalTagsStrategy [

	^ PrismComponentStyleStrategy new
		  objects: [ self entity codeTagAssociations select: [ :each | self sourceAnchor isNil or: [ each sourceAnchor = self sourceAnchor ] ] ];
		  positionFunction: [ :messageSent | { (messageSent start to: messageSent stop) } ];
		  style: [ :o | 'style="border-bottom: 3px solid ' , o object tag color asHTMLColor , '"' ];
		  miniMapColor: [ :object | object object tag color ];
		  condition: [ self displayTags ]
]

{ #category : #prism }
CPPSCodeDisplayPanelComponent >> prismPositionForAssociation: anAssociation [

	| offset |

	offset := self currentSourceAnchor startPos.
	^ { (anAssociation start - offset + 1 to: anAssociation stop - offset + 1) }
]

{ #category : #prism }
CPPSCodeDisplayPanelComponent >> prismTagMenuAction [

	^ self currentTag
		  ifNil:
			  [ PrismMenu new
				  callback:
					  [ :startPos :endPos :htm | 
					  self prismComponent resetCache.
					  self parent taggingInterval: (startPos to: endPos).
					  self parent renderTaggingPopupOn: htm
					  ];
				  drawHTMLOn: self rootDialogId;
				  drawCallback: MDLDialog jsInitializeAndOpenRootDialog
			  ]
		  ifNotNil:
			  [ PrismMenu new callback:
				  [ :startPos :endPos :htm | 
				  self prismComponent resetCache.
				  self parent taggingInterval: (startPos to: endPos).
				  self parent tagCurrentIntervalWith: self currentTag
				  ]
			  ]
]

{ #category : #prism }
CPPSCodeDisplayPanelComponent >> prismUntagMenuAction [

	^ PrismMenu new callback:
		  [ :startPos :endPos :htm | 
		  self prismComponent resetCache.
		  self parent taggingInterval: (startPos to: endPos).
		  self parent untagCurrentIntervalWith: self currentTag
		  ]
]

{ #category : #rendering }
CPPSCodeDisplayPanelComponent >> renderCheckboxDoing: aCallback checked: aBoolean label: aString style: anotherString tooltip: tooltip on: html [

	html mdlCheckboxContainer
		for: html nextId;
		id: 'checkbox' , html lastId asString;
		with:
			[ html mdlCheckbox
				id: html lastId;
				callback: aCallback;
				onClick: (html jQuery ajax
						 serializeThisWithHidden;
						 onComplete: ((html jQuery id: #'code-container') load
								  html: [ :r | self renderCodeOn: r ];
								  onComplete: 'initPrismComponents();initMinimaps();' js));
				value: aBoolean.
			html mdlCheckboxLabel
				style: anotherString;
				with: aString
			].
	html
		mdlLargeTooltipFor: 'checkbox' , html lastId asString
		with: [ html html: tooltip ]
]

{ #category : #rendering }
CPPSCodeDisplayPanelComponent >> renderCodeOn: html [

	html render: self prismComponent
]

{ #category : #rendering }
CPPSCodeDisplayPanelComponent >> renderContentOn: html [

	html div
		class: #'code-container-panel__options';
		shadow: 2;
		with: [ self renderOptionsOn: html ].
	html div
		id: #'code-container';
		with: [ self renderCodeOn: html ]
]

{ #category : #rendering }
CPPSCodeDisplayPanelComponent >> renderOptionsOn: html [

	self sourceAnchor ifNil: [ ^ self ].
	self
		renderCheckboxDoing: [ :c | self displayTags: c ]
		checked: self displayTags
		label: (self
				 english: 'Display internal tags'
				 french: 'Afficher les tags internes.')
		style: 'border-bottom: 2px solid black;'
		tooltip: (self
				 english: 'This option will highlight the internal tags of an entity.<br><br>Internal tags are lines of code tagged.<br><br>To add an internal tag, select a piece of code and select "tag selection" entry on the menu.'
				 french: 'Cette option va mettre en évidence les tags internes.<br><br>Les tags internes sont des tags sur des lignes de code d''une entité.<br><br>Pour ajouter un nouveau tag interne, veuillez sélectionnes un bout de code et cliquez sur l''entré de menu "tag selection".')
		on: html.
	self
		renderCheckboxDoing: [ :c | self displayDependenciesTags: c ]
		checked: self displayDependenciesTags
		label: (self
				 english: 'Display dependencies tags'
				 french: 'Afficher les tags des dépendances.')
		style: 'background-color: rgba(0,0,0,0.2);'
		tooltip: (self
				 english: 'This option will highlight the tagged dependencies of the entity.<br><br>For example if the entity reference a class tagged with a red tag, the reference will be highlighted in red in the code.'
				 french: 'Cette option permet de mettre en évidence les dépendances taggées de l''entité.<br><br>Par exemple si l''entité référence une classe taggée en rouge, la référence sera mise en évidence en rouge dans le code.')
		on: html
]

{ #category : #rendering }
CPPSCodeDisplayPanelComponent >> renderTabHeaderOf: aComponent on: html [

	self isUseful ifFalse: [ ^ self ].
	self hasMultipleFiles
		ifTrue:
			[ html form
				class: 'mdl-tabs__tab';
				class: 'is-active'
				if: aComponent currentTab = self;
				class: 'activeByHand'
				if: aComponent currentTab = self;
				class: #withSelect;
				with: ((MDLSelectWidget
						  possibilities: self entity sourceAnchor fileAnchors
						  inputLabel: (self translate: self panelTitle)
						  labelBlock: [ :sa | sa fileReference basename ]
						  callback:
							  [ :sa | 
							  self sourceAnchor: sa.
							  aComponent currentTab: self
							  ]
						  selectedObject: self sourceAnchor)
						 entryTooltip: #fileName;
						 beAutoSubmit;
						 yourself)
			]
		ifFalse:
			[ super
				renderTabHeaderOf: aComponent
				on: html.
			html
				mdlLargeTooltipFor: html lastId
				with: self sourceAnchor fileName
			]
]

{ #category : #accessing }
CPPSCodeDisplayPanelComponent >> sourceAnchor [

	^ sourceAnchor ifNil:
		  [ self entity sourceAnchor ifNotNil:
			  [ :sa | 
			  sa isMultiple
				  ifTrue: [ sa fileAnchors first ]
				  ifFalse: [ sa ]
			  ]
		  ]
]

{ #category : #accessing }
CPPSCodeDisplayPanelComponent >> sourceAnchor: anObject [

	sourceAnchor := anObject
]

{ #category : #accessing }
CPPSCodeDisplayPanelComponent >> sourceText [

	^ self currentSourceAnchor
		  ifNil: [ self entity sourceText ]
		  ifNotNil: [ :sa | sa sourceText ]
]
