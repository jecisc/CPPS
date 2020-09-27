"
I am a browser the user should use to manage the tags of the model. 

Description
------------------

We use tags to make powerful tools. I am responsible of the tag management. 

I allow the user to create, edit, browse, split, merge, ... his tags.

Internal Representation and Key Implementation Points.
-----------------

    Instance Variables
	selectedTag:					<aTag>				I am a tag currently selected.
	tagList:						<aComponent>		I am a component use to display the actual list of tags.
	tagPanelsComponent:		<aComponent> 		I am a component use to display the components of the browser in a tab panel.
"
Class {
	#name : #CPPSTagBrowser,
	#superclass : #CPPSAbstractBrowser,
	#traits : 'TRightTabsPanelBrowser',
	#classTraits : 'TRightTabsPanelBrowser classTrait',
	#instVars : [
		'parentTag',
		'tagList',
		'tagPanelsComponent',
		'selectedTag',
		'toolbar',
		'rightPanel'
	],
	#category : #'CPPS-Toolkit-QueryBrowser-TagManager'
}

{ #category : #accessing }
CPPSTagBrowser class >> browserName [

	^ 'Concept Manipulator' french: 'Manipulateur de concepts'
]

{ #category : #testing }
CPPSTagBrowser class >> isReleventFor: selectionOrEntity [

	^ selectionOrEntity asCollection
		  ifNotEmpty: [ :coll | coll anyOne isTag ]
		  ifEmpty: [ false ]
]

{ #category : #accessing }
CPPSTagBrowser class >> priority [

	^ 34
]

{ #category : #accessing }
CPPSTagBrowser >> allRootTags [

	^ self tagModel allRootTags
]

{ #category : #accessing }
CPPSTagBrowser >> browserClass [

	^ #'tag-manager'
]

{ #category : #component }
CPPSTagBrowser >> defaultTagListComponent [

	^ (MDLNestedList
		   elements: self allRootTags asOrderedCollection
		   children: [ :tag | tag children asOrderedCollection ])
		  format: #name;
		  actionBlock:
			  [ :tag | 
			  self selectedTag: (tag = self selectedTag
						   ifTrue: [ nil ]
						   ifFalse: [ tag ])
			  ];
		  iconBlock:
			  [ :tag :html | 
			  self
				  renderIconFor: tag
				  on: html
			  ];
		  rightIconBlock:
			  [ :tag :html | 
			  self
				  renderArchitectureTransformationFor: tag
				  on: html
			  ];
		  selectedEntity: self selectedTag;
		  helpBlock: #description;
		  addDecoration: (CPPSDivDecoration htmlClass: 'tree');
		  dragAndDropBlock:
			  [ :tagA :tagB | 
			  [ tagA changeParentTagTo: tagB ]
				  on: FamixTagFailure
				  do: [ self pushErrorMessage: ('Impossible to move tag, you should use merge' french: 'Impossible de bouger le tag, vous devriez utiliser la fusion') ]
			  ];
		  yourself
]

{ #category : #component }
CPPSTagBrowser >> defaultTagPanelComponent [

	^ CPPSTabPanelComponent
		  tabStrategies: self tabPanelStrategies
		  owner: self
]

{ #category : #component }
CPPSTagBrowser >> defaultToolbar [

	^ MDLVerticalToolbar buttons: { 
			  ((MDLFoldButton for: '#' , self rightPanelId)
				   resetVisusOnFold;
				   fold;
				   yourself).
			  (self
				   switcherButton: (self
						    english: 'New Tag'
						    french: 'Nouveau')
				   perform: #setDefaultRightPanel).
			  (self
				   switcherButton: (self
						    english: 'Metrics'
						    french: 'Métriques')
				   perform: #setMetricsPanel) }
]

{ #category : #rendering }
CPPSTagBrowser >> fullTagVisualization [

	| visu |

	visu := CPPSTagVisualization
		        tags: self allRootTags
		        model: self model.
	^ (TLCytoscapeComponent visualization: visu)
		  withPNGExport;
		  yourself
]

{ #category : #initialization }
CPPSTagBrowser >> initialize [

	super initialize.
	self tagList: self defaultTagListComponent.
	self tagPanelsComponent: self defaultTagPanelComponent.
	self initializeRightPanel
]

{ #category : #javascript }
CPPSTagBrowser >> jsUpdateRightPanelOn: html [

	^ (html jQuery id: self rightPanelId) load
		  html: [ :r | html render: self rightPanel ];
		  onComplete: 'componentHandler.upgradeDom();' js
]

{ #category : #accessing }
CPPSTagBrowser >> parentTag [

	^ parentTag
]

{ #category : #accessing }
CPPSTagBrowser >> parentTag: aTag [

	parentTag := aTag
]

{ #category : #rendering }
CPPSTagBrowser >> renderArchitectureTransformationFor: aTag on: html [

	aTag isComposite ifTrue:
		[ html anchor
			style: 'flex-grow: 0; width: 40px;';
			callback:
				[ | architecture |

				architecture := CPPSArchitectureTagLayer fromTag: aTag.
				self addArchitecture: architecture.
				self openAdaptatedBrowserOn: architecture
				];
			with:
				[ html mdlIcon
					id: html nextId;
					with: #account_balance
				].
		html
			mdlLargeTooltipFor: html lastId
			with: (self
					 english: 'Transform in Architecture'
					 french: 'Transformer en Architecture')
		]
]

{ #category : #rendering }
CPPSTagBrowser >> renderContentOn: html [

	html div
		class: self browserClass;
		with:
			[ html leftPanel:
					[ html
						render: self defaultTagListComponent;
						leftPanelResizer
					].
			html div
				beGrowing;
				class: self browserClass , '-content';
				with:
					[ html render: (self selectedTag
								 ifNil: [ self fullTagVisualization ]
								 ifNotNil: [ self tagPanelsComponent ])
					].
			self renderRightPanelOn: html
			]
]

{ #category : #rendering }
CPPSTagBrowser >> renderIconFor: aTag on: html [

	html mdlIcon
		style: 'cursor: pointer;';
		onClick: (html jQuery this load html:
					 [ :ajaxHtml | 
					 aTag isHidden: aTag isHidden not.
					 ajaxHtml text: aTag visibilityIcon
					 ]);
		with: aTag visibilityIcon.
	html mdlIcon
		id: html nextId;
		style: 'color: #' , aTag color asHexString;
		with: (aTag isComposite
				 ifTrue: [ #dashboard ]
				 ifFalse: [ #label ]).
	html
		mdlLargeTooltipFor: html lastId
		with: (aTag isComposite
				 ifTrue:
					 [ self
						 english: 'Composite Tag'
						 french: 'Tag composite'
					 ]
				 ifFalse: [ 'Tag' ])
]

{ #category : #accessing }
CPPSTagBrowser >> rightPanel [

	^ rightPanel
]

{ #category : #accessing }
CPPSTagBrowser >> rightPanel: aComponent [

	rightPanel := aComponent
]

{ #category : #accessing }
CPPSTagBrowser >> selectedTag [

	^ selectedTag
]

{ #category : #accessing }
CPPSTagBrowser >> selectedTag: anObject [

	selectedTag := anObject.
	self tagList selectedEntity: anObject.
	self tagPanelsComponent tabStrategies do: [ :aStrategy | aStrategy component ifNotNil: [ :c | c selectedTag: self selectedTag ] ]
]

{ #category : #selection }
CPPSTagBrowser >> selection: aCollection [

	self
		assert: [ aCollection size = 1 ]
		description: 'The tag browser know only how to select one tag'.
	self selectedTag: aCollection first
]

{ #category : #initialization }
CPPSTagBrowser >> setDefaultRightPanel [

	self rightPanel: (CPPSCreateTagRightPanel owner: self)
]

{ #category : #initialization }
CPPSTagBrowser >> setMetricsPanel [

	self rightPanel: ((CPPSTagMetricsRightPanel owner: self)
			 addDecoration: (CPPSTitleDecoration entitled: (self
							   english: 'Metrics'
							   french: 'Métriques'));
			 addDecoration: (CPPSDivDecoration htmlClass: 'infoComponent');
			 yourself)
]

{ #category : #accessing }
CPPSTagBrowser >> tabPanelStrategies [

	^ OrderedCollection new
		  add: (CPPSPanelStrategy
				   id: #edit
				   icon: #create
				   label: ('Edit' french: 'Éditer')
				   componentClass: CPPSTagEditorComponent);
		  add: (CPPSPanelStrategy
				   id: #delete
				   icon: #delete_forever
				   label: ('Delete' french: 'Supprimer')
				   componentClass: CPPSDeleteTagComponent);
		  add: (CPPSPanelStrategy
				   id: #content
				   icon: #list
				   label: ('Entities' french: 'Entitées')
				   componentClass: CPPSTagContentComponent
				   shouldBeDisplayBlock: [ self taggedEntities isNotEmpty ]);
		  add: (CPPSPanelStrategy
				   id: #splitter
				   icon: #content_cut
				   label: ('Split' french: 'Diviser')
				   componentClass: CPPSTagSplitComponent
				   shouldBeDisplayBlock: [ self taggedEntities isNotEmpty or: [ self selectedTag isComposite ] ]);
		  add: (CPPSPanelStrategy
				   id: #merge
				   icon: #call_merge
				   label: ('Merge' french: 'Fusioner')
				   componentClass: CPPSTagMergeComponent
				   shouldBeDisplayBlock: [ self tagModel allTags size >= 2 ]);
		  add: (CPPSPanelStrategy
				   id: #vizualization
				   icon: #remove_red_eye
				   label: ('Visualize' french: 'Visualiser')
				   componentClass: CPPSTagVisualizationComponent
				   shouldBeDisplayBlock: [ self selectedTag isComposite or: [ (self selectedTag taggedEntitiesInModel: self model) isNotEmpty ] ]
				   onClick: 'setTimeout(function(){for(i=0;i<visus.length;i++)visus[i].visu.resize();for(i=0;i<visus.length;i++)visus[i].visu.fit();}, 400)' js);
		  yourself
]

{ #category : #accessing }
CPPSTagBrowser >> tagList [

	^ tagList
]

{ #category : #accessing }
CPPSTagBrowser >> tagList: anObject [

	tagList := anObject
]

{ #category : #accessing }
CPPSTagBrowser >> tagPanelsComponent [

	^ tagPanelsComponent
]

{ #category : #accessing }
CPPSTagBrowser >> tagPanelsComponent: anObject [

	tagPanelsComponent := anObject.
	tagPanelsComponent activeTabStrategy ifNotNil: [ tagPanelsComponent activeTab selectedTag: self selectedTag ]
]

{ #category : #accessing }
CPPSTagBrowser >> taggedEntities [

	"tagged entities with current user version"

	^ self selectedTag taggedEntitiesInModel: self model
]

{ #category : #accessing }
CPPSTagBrowser >> toolbar [

	^ toolbar
]

{ #category : #accessing }
CPPSTagBrowser >> toolbar: aComponent [

	toolbar := aComponent
]
