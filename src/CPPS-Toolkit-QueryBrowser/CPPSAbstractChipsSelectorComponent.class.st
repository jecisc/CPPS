Class {
	#name : #CPPSAbstractChipsSelectorComponent,
	#superclass : #CPPSComponent,
	#instVars : [
		'inputCollection',
		'id',
		'jQueryScriptBlock',
		'addBlock',
		'removeBlock',
		'title'
	],
	#category : #'CPPS-Toolkit-QueryBrowser-TagManager'
}

{ #category : #'instance creation' }
CPPSAbstractChipsSelectorComponent class >> input: aCollection addBlock: aBlock removeBlock: aBlock2 [

	^ self
		  input: aCollection
		  addBlock: aBlock
		  removeBlock: aBlock2
		  jQueryScriptBlock: nil
		  title: nil
]

{ #category : #'instance creation' }
CPPSAbstractChipsSelectorComponent class >> input: aCollection addBlock: aBlock removeBlock: aBlock2 jQueryScriptBlock: aBlock3 title: aString [

	^ self new
		  inputCollection: aCollection;
		  addBlock: aBlock;
		  removeBlock: aBlock2;
		  jQueryScriptBlock: aBlock3;
		  title: aString;
		  yourself
]

{ #category : #accessing }
CPPSAbstractChipsSelectorComponent >> addBlock [

	^ addBlock
]

{ #category : #accessing }
CPPSAbstractChipsSelectorComponent >> addBlock: aBlock [

	addBlock := aBlock
]

{ #category : #accessing }
CPPSAbstractChipsSelectorComponent >> ajaxSuccessScriptFrom: html [

	^ html jQuery script:
		  [ :s | 
		  s
			  << (((html jQuery id: self id) children: '.chip-selector__content') load html: [ :ajaxHtml | self renderChipsOn: ajaxHtml ]);
			  << ((html jQuery id: self rootDialogId) load
					   html: [ :ajaxHtml | self renderDialogContentOn: ajaxHtml ];
					   onComplete: 'try {this.closest(".mdl-dialog").close();}catch(err){}; componentHandler.upgradeDom();');
			  << (self jQueryScriptBlock value: html)
		  ]
]

{ #category : #accessing }
CPPSAbstractChipsSelectorComponent >> defaultTitle [

	^ self subclassResponsibility
]

{ #category : #accessing }
CPPSAbstractChipsSelectorComponent >> elementsToDisplay [

	^ self inputCollection
]

{ #category : #accessing }
CPPSAbstractChipsSelectorComponent >> ensureId: html [

	self id ifNil: [ self id: html nextId ]
]

{ #category : #accessing }
CPPSAbstractChipsSelectorComponent >> formatedNameFor: anObject [

	^ self subclassResponsibility
]

{ #category : #accessing }
CPPSAbstractChipsSelectorComponent >> id [

	^ id
]

{ #category : #accessing }
CPPSAbstractChipsSelectorComponent >> id: aString [

	id := aString
]

{ #category : #accessing }
CPPSAbstractChipsSelectorComponent >> inputCollection [

	^ inputCollection value
]

{ #category : #accessing }
CPPSAbstractChipsSelectorComponent >> inputCollection: anObject [

	inputCollection := anObject
]

{ #category : #accessing }
CPPSAbstractChipsSelectorComponent >> jQueryScriptBlock [

	^ jQueryScriptBlock ifNil: [ jQueryScriptBlock := [ :c |  ] ]
]

{ #category : #accessing }
CPPSAbstractChipsSelectorComponent >> jQueryScriptBlock: anObject [

	jQueryScriptBlock := anObject
]

{ #category : #javascript }
CPPSAbstractChipsSelectorComponent >> javascriptSubmitAndRefreshComponentOn: html [

	^ html jQuery ajax
		  serializeForm;
		  context: 'this' js;
		  onComplete: (self ajaxSuccessScriptFrom: html)
]

{ #category : #accessing }
CPPSAbstractChipsSelectorComponent >> removeBlock [

	^ removeBlock
]

{ #category : #accessing }
CPPSAbstractChipsSelectorComponent >> removeBlock: aBlock [

	removeBlock := aBlock
]

{ #category : #rendering }
CPPSAbstractChipsSelectorComponent >> renderAddDialogOn: html [

	html div
		class: #'chip-selector__add';
		with:
			[ html mdlButton
				bePush;
				openDialogWithId: self rootDialogOpenId;
				onClickUpdateRootDialogWith: [ :r | self renderDialogContentOn: r ];
				rippleEffect;
				icon;
				with: [ html mdlIcon: #add ]
			]
]

{ #category : #rendering }
CPPSAbstractChipsSelectorComponent >> renderChipContentFor: anObject on: html [

	| name |

	html mdlChipContact
		hexColor: '#FF8A65';
		with: (name := self formatedNameFor: anObject) first asUppercase.
	name size > 20
		ifTrue:
			[ html mdlChipText
				id: html nextId;
				with: (name truncate: 20).
			html
				mdlLargeTooltipFor: html lastId
				with: name
			]
		ifFalse: [ html mdlChipText: name ]
]

{ #category : #rendering }
CPPSAbstractChipsSelectorComponent >> renderChipFor: anObject on: html [

	html mdlChip
		ajaxDeleteCallback: [ self removeBlock value: anObject ]
		successHook: (self ajaxSuccessScriptFrom: html);
		with:
			[ self
				renderChipContentFor: anObject
				on: html
			]
]

{ #category : #rendering }
CPPSAbstractChipsSelectorComponent >> renderChipsOn: html [

	self elementsToDisplay
		ifEmpty: [ self renderEmptyChipOn: html ]
		ifNotEmpty:
			[ :inputs | 
			inputs do:
				[ :each | 
				self
					renderChipFor: each
					on: html
				]
			]
]

{ #category : #rendering }
CPPSAbstractChipsSelectorComponent >> renderContentOn: html [

	self ensureId: html.
	html div
		class: #'chip-selector';
		id: self id;
		with:
			[ html div
				class: #'chip-selector__title';
				with: self title.
			html div
				class: #'chip-selector__content';
				with: [ self renderChipsOn: html ].
			self renderAddDialogOn: html
			]
]

{ #category : #rendering }
CPPSAbstractChipsSelectorComponent >> renderDialogContentOn: html [

	html mdlDialogTitle: (self renderSpecificDialogTitleOn: html).
	html mdlDialogContent: [ self renderSpecificDialogContentOn: html ].
	html mdlDialogActions:
		[ html mdlButton
			id: self rootDialogCloseId;
			with: (self
					 english: 'Cancel'
					 french: 'Annuler')
		]
]

{ #category : #rendering }
CPPSAbstractChipsSelectorComponent >> renderEmptyChipOn: html [

	html mdlChip:
		[ html mdlIcon
			chipIcon;
			with: #block.
		html mdlChipText: (self
				 english: 'None'
				 french: 'Aucune')
		]
]

{ #category : #rendering }
CPPSAbstractChipsSelectorComponent >> renderSpecificDialogContentOn: html [

	self subclassResponsibility
]

{ #category : #rendering }
CPPSAbstractChipsSelectorComponent >> renderSpecificDialogTitleOn: html [

	self subclassResponsibility
]

{ #category : #accessing }
CPPSAbstractChipsSelectorComponent >> title [

	^ title ifNil: [ title := self defaultTitle ]
]

{ #category : #accessing }
CPPSAbstractChipsSelectorComponent >> title: anObject [

	^ title := anObject
]
