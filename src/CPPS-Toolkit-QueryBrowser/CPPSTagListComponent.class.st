"
Description
-------------------

I am a component to list a collection of tag and allow the user to apply an action to a tag.

I will display the tags and add an action. 
I will execute the action in ajax. The user can use javascript to update the page after the action succeded.
 
Internal Representation and Key Implementation Points.
--------------------

    Instance Variables
	actionBlock:					<aBlock>		A block taking in parameter a tag and executing an action.
	actionLabelBlock:			<aBlock>		A block taking in parameter a tag and returning a symbol representing the icon to use for the action.
	actionTooltipBlock:			<aBlock>		A block taking in parameter a tag and returning a tooltip for the action.
	shouldRefreshAllComponent	<aString>		A Boolean to know if the ajax refresh should be done only on the clicked label or all the component
	successMessage:				<aString>		A success message to show when the action was executed.
	tags:						<aCollection>	The list of tags to show. I can be a block returning the collection.
"
Class {
	#name : #CPPSTagListComponent,
	#superclass : #CPPSTagListComponentAbstract,
	#instVars : [
		'actionBlock',
		'actionLabelBlock',
		'actionTooltipBlock',
		'shouldRefreshAllComponent',
		'successMessage',
		'shouldRefreshPage'
	],
	#category : #'CPPS-Toolkit-QueryBrowser-TagManager'
}

{ #category : #'instance creation' }
CPPSTagListComponent class >> tags: aCollection actionBlock: aBlockOrSymbol [

	^ self new
		  elements: aCollection;
		  actionBlock: aBlockOrSymbol;
		  yourself
]

{ #category : #'instance creation' }
CPPSTagListComponent class >> tags: aCollection actionBlock: aBlockOrSymbol actionTooltipBlock: secondBlock [

	^ (self
		   tags: aCollection
		   actionBlock: aBlockOrSymbol)
		  actionTooltipBlock: secondBlock;
		  yourself
]

{ #category : #'instance creation' }
CPPSTagListComponent class >> tags: aCollection actionBlock: aBlockOrSymbol actionTooltipBlock: secondBlock actionLabelBlock: thirdBlock [

	^ (self
		   tags: aCollection
		   actionBlock: aBlockOrSymbol
		   actionTooltipBlock: secondBlock)
		  actionLabelBlock: thirdBlock;
		  yourself
]

{ #category : #accessing }
CPPSTagListComponent >> actionBlock [

	^ actionBlock
]

{ #category : #accessing }
CPPSTagListComponent >> actionBlock: anObject [

	actionBlock := anObject
]

{ #category : #accessing }
CPPSTagListComponent >> actionLabelBlock [

	^ actionLabelBlock ifNil: [ actionLabelBlock := [ :tag | #label_outline ] ]
]

{ #category : #accessing }
CPPSTagListComponent >> actionLabelBlock: anObject [

	actionLabelBlock := anObject
]

{ #category : #accessing }
CPPSTagListComponent >> actionTooltipBlock [

	^ actionTooltipBlock
]

{ #category : #accessing }
CPPSTagListComponent >> actionTooltipBlock: anObject [

	actionTooltipBlock := anObject
]

{ #category : #javascript }
CPPSTagListComponent >> ajaxOnSuccessFor: aTag id: lid from: html [

	^ html jQuery script:
		  [ :s | 
		  s
			  << (self refreshCurrentTagScriptFrom: html);
			  << ((self shouldRefreshAllComponent
					    ifTrue:
						    [ (html jQuery this parents: '.tag-list') load
							    html: [ :ajaxHtml | self renderTagsListOn: ajaxHtml ];
							    yourself
						    ]
					    ifFalse:
						    [ html jQuery this load
							    html:
								    [ :ajaxHtml | 
								    self
									    renderActionIconFor: aTag
									    id: lid
									    on: ajaxHtml
								    ];
							    yourself
						    ]) onComplete: 'componentHandler.upgradeDom();' js)
		  ]
]

{ #category : #accessing }
CPPSTagListComponent >> defaultTagListComponent [

	^ (MDLNestedList
		   elements: self elements
		   children: [ :tag | tag children asOrderedCollection ])
		  format: #name;
		  actionBlock: self actionBlock;
		  iconBlock:
			  [ :aTag :html | 
			  html mdlListIcon
				  style: 'color: #' , aTag color asHexString;
				  with: #label
			  ];
		  rightIconBlock:
			  [ :tag :html | 
			  self
				  renderItemActionFor: tag
				  on: html
			  ];
		  helpBlock: #description;
		  addDecoration: (CPPSDivDecoration htmlClass: 'tree');
		  "
		iconBlock: [ :tag :html | self renderArchitectureTransformationFor: tag on: html ];""selectedEntity: self selectedTag;"yourself
]

{ #category : #initialization }
CPPSTagListComponent >> initialize [

	super initialize.
	shouldRefreshPage := false
]

{ #category : #accessing }
CPPSTagListComponent >> refreshAllComponent [

	self shouldRefreshAllComponent: true
]

{ #category : #rendering }
CPPSTagListComponent >> renderActionIconFor: aTag id: anId on: html [

	self flag: #todo. "the snackbar does not work anymore :( I don't have time to fix it now"
	html div
		id: anId;
		style: 'cursor: pointer;';
		onClick: (html jQuery ajax
				 callback: [ self actionBlock value: aTag ];
				 context: (JSStream on: 'this');
				 onSuccess: (self shouldRefreshPage
						  ifTrue: [ 'location.reload();' ]
						  ifFalse:
							  [ self
								  ajaxOnSuccessFor: aTag
								  id: anId
								  from: html
							  ]));
		with: [ html mdlIcon: (self actionLabelBlock value: aTag) ]
]

{ #category : #rendering }
CPPSTagListComponent >> renderCategoriesOf: aTag on: html [

	| categories id |

	html mdlListItemSecondaryInfo
		id: (id := html nextId);
		with: (categories := ' - ' join: (aTag categories collect: #name)).
	html
		mdlLargeTooltipFor: id
		with: categories
]

{ #category : #rendering }
CPPSTagListComponent >> renderContentOn: html [

	html mdlList
		id: #'tag-list';
		class: #'tag-list';
		with: [ self renderTagsListOn: html ]
]

{ #category : #rendering }
CPPSTagListComponent >> renderItem: aTag on: html [

	html mdlListItem twoLine with:
		[ html mdlListPrimaryContent:
			[ html mdlListIcon
				style: 'color: #' , aTag color asHexString;
				with: #label.
			html text: aTag name.
			html mdlListItemSubTitle: aTag description
			].
		html mdlListSecondaryContent:
			[ self
				renderCategoriesOf: aTag
				on: html.
			self
				renderItemActionFor: aTag
				on: html
			]
		]
]

{ #category : #rendering }
CPPSTagListComponent >> renderItemActionFor: aTag on: html [

	| id |

	self
		renderActionIconFor: aTag
		id: (id := html nextId)
		on: html.
	self actionTooltipBlock ifNotNil:
		[ :blk | 
		html
			mdlLargeTooltipFor: id
			with: (blk value: aTag)
		]
]

{ #category : #rendering }
CPPSTagListComponent >> renderTagsListOn: html [

	html render: self defaultTagListComponent
]

{ #category : #accessing }
CPPSTagListComponent >> shouldRefreshAllComponent [

	^ shouldRefreshAllComponent ifNil: [ shouldRefreshAllComponent := false ]
]

{ #category : #accessing }
CPPSTagListComponent >> shouldRefreshAllComponent: anObject [

	shouldRefreshAllComponent := anObject
]

{ #category : #accessing }
CPPSTagListComponent >> shouldRefreshPage [

	^ shouldRefreshPage
]

{ #category : #accessing }
CPPSTagListComponent >> shouldRefreshPage: anObject [

	shouldRefreshPage := anObject
]

{ #category : #accessing }
CPPSTagListComponent >> successMessage [

	^ successMessage ifNil:
		  [ successMessage := self
			                    english: 'Entities tagged'
			                    french: 'Entités taggées'
		  ]
]

{ #category : #accessing }
CPPSTagListComponent >> successMessage: anObject [

	successMessage := anObject
]
