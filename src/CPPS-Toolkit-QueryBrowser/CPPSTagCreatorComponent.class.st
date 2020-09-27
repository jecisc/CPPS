"
Description
-------------------

I am a component to let the user create a new tag.

The user will be able to create a new tag and also to create new categories of tags.

Internal Representation and Key Implementation Points.
------------------

    Instance Variables
	category:			<aTagCategory>		The category of the tag to create.
	errorMessage:		<aString>			An error message to display if there is a problem.
	parentTag:			<aTag>				A Tag that should be the parent of the tag to create. Let it to nil if the tag has no parent.
	temporaryTag:		<aTag>				A temporary tag. It will be use to create the tag if there is no error during the creation.
"
Class {
	#name : #CPPSTagCreatorComponent,
	#superclass : #CPPSTagBrowserComponent,
	#instVars : [
		'temporaryTag',
		'parentTag',
		'errorMessage',
		'categoryComponent',
		'ajaxSubmitBlock',
		'customButtonBlock'
	],
	#category : #'CPPS-Toolkit-QueryBrowser-TagManager'
}

{ #category : #accessing }
CPPSTagCreatorComponent >> ajaxSubmitBlock [

	^ ajaxSubmitBlock
]

{ #category : #accessing }
CPPSTagCreatorComponent >> ajaxSubmitBlock: anObject [

	ajaxSubmitBlock := anObject
]

{ #category : #accessing }
CPPSTagCreatorComponent >> categoryComponent [

	^ categoryComponent
]

{ #category : #accessing }
CPPSTagCreatorComponent >> categoryComponent: anObject [

	categoryComponent := anObject
]

{ #category : #action }
CPPSTagCreatorComponent >> createTag [

	[ | newTag |

	newTag := self parentTag
		          ifNotNil: [ self parentTag createSubTagNamed: self temporaryTag name ]
		          ifNil: [ self tagModel createTagNamed: self temporaryTag name ].
	newTag description: self temporaryTag description.
	newTag categories: self temporaryTag categories.
	newTag color: self temporaryTag color.
	self currentTag: newTag.
	self resetVariables
	]
		on: FamixAlreadyExistTagFailure
		do:
			[ self errorMessage: (self
					 english: 'This tag already exist'
					 french: 'Ce tag existe déjà')
			]
]

{ #category : #accessing }
CPPSTagCreatorComponent >> customButtonBlock [

	^ customButtonBlock
]

{ #category : #accessing }
CPPSTagCreatorComponent >> customButtonBlock: anObject [

	customButtonBlock := anObject
]

{ #category : #components }
CPPSTagCreatorComponent >> defaultCategoriesComponent [

	^ CPPSCategoriesEditorComponent
		  categories: [ self temporaryTag categories ]
		  addCategoryBlock: [ :cat | self temporaryTag addCategory: cat ]
		  removeCategoryBlock: [ :cat | self temporaryTag removeCategory: cat ]
]

{ #category : #accessing }
CPPSTagCreatorComponent >> errorMessage [

	^ errorMessage
]

{ #category : #accessing }
CPPSTagCreatorComponent >> errorMessage: anObject [

	errorMessage := anObject
]

{ #category : #components }
CPPSTagCreatorComponent >> helpComponent [

	^ CPPSHelpComponent message: (self
			   english: 'Be careful, all the tag you creates will not be automaticaly persisted if you close the server. To ensure the persistance of your tags, you can save them in the Project Manager. This operation can take several minutes.'
			   french: 'Attention, tous vos tags ne sont pas sauvés automatiquement si vous fermez le serveur. Pour assurer la persistance de vos tags, vous pouvez les sauver via le Gestionnaire de projet. Cette opération peut prendre plusieurs minutes.')
]

{ #category : #initialization }
CPPSTagCreatorComponent >> initialize [

	super initialize.
	self categoryComponent: self defaultCategoriesComponent.
	self resetVariables
]

{ #category : #accessing }
CPPSTagCreatorComponent >> parentTag [

	^ parentTag
]

{ #category : #accessing }
CPPSTagCreatorComponent >> parentTag: anObject [

	parentTag := anObject
]

{ #category : #rendering }
CPPSTagCreatorComponent >> renderColorPickerOn: html [

	| id |

	id := html nextId.
	html colorInput
		callback: [ :color | self temporaryTag color: (Color fromHexString: color allButFirst) ];
		value: '#' , temporaryTag color asHexString;
		id: id.
	html label
		for: id;
		class: #label;
		with: (self
				 english: 'Choose a color'
				 french: 'Selectionnez une couleur').
	html break
]

{ #category : #rendering }
CPPSTagCreatorComponent >> renderComponentOn: html [

	self resetVariables.
	html div
		class: #form;
		style: 'text-align: center;';
		with:
			[ self renderWarningOn: html.
			html render: self categoryComponent.
			html form
				style: 'padding-top: 0;';
				with: [ self renderFormOn: html ]
			]
]

{ #category : #rendering }
CPPSTagCreatorComponent >> renderDescriptionInputOn: html [

	html mdlTextFieldContainer:
		[ | id |

		id := html nextId.
		html mdlTextArea
			rows: 2;
			callback: [ :description | self temporaryTag description: description ];
			value: temporaryTag description;
			id: id.
		html mdlTextFieldLabel
			for: id;
			with: 'Description'
		].
	html break
]

{ #category : #rendering }
CPPSTagCreatorComponent >> renderFormOn: html [

	self
		renderTagParentOn: html;
		renderTagNameInputOn: html;
		renderDescriptionInputOn: html;
		renderColorPickerOn: html;
		renderSubmitOn: html
]

{ #category : #rendering }
CPPSTagCreatorComponent >> renderSubmitOn: html [

	| button |

	button := html mdlMajorButton.
	self ajaxSubmitBlock
		ifNil:
			[ button
				beSubmit;
				callback: [ self createTag ]
			]
		ifNotNil:
			[ :blk | 
			button
				bePush;
				onClick: (html jQuery ajax
						 serializeForm;
						 callback: [ self createTag ];
						 onComplete: (blk value: html))
			].
	button with: (self translate: ('Create' french: 'Créer')).
	self customButtonBlock ifNotNil: [ :blk | blk value: html ].
	html render: self helpComponent
]

{ #category : #rendering }
CPPSTagCreatorComponent >> renderTagNameInputOn: html [

	html render: ((MDLTextFieldWidget
			  labeled: (self
					   english: 'Tag name'
					   french: 'Nom du tag')
			  callback: [ :name | self temporaryTag name: (name ifEmpty: [ 'unnamed' ]) ]
			  floatingLabel: true)
			 style: 'top: 20px;';
			 id: #'tag-name-input';
			 propertiesAt: #attributeAt:put:
			 put: #( 'autofocus' true );
			 yourself).
	html break
]

{ #category : #rendering }
CPPSTagCreatorComponent >> renderTagParentOn: html [

	html
		break;
		render: ((MDLSelectWidget
				  possibilities: ((self tagModel tags asOrderedCollection sorted: #name ascending)
						   addFirst: nil;
						   yourself)
				  inputLabel: (self
						   english: 'Select parent tag'
						   french: 'Sélectionnez le tag parent')
				  labelBlock:
					  [ :tag | 
					  tag
						  ifNil:
							  [ self
								  english: 'No parent (default)'
								  french: 'Pas de parent (default)'
							  ]
						  ifNotNil: [ tag name ]
					  ]
				  callback: [ :tag | self parentTag: tag ]
				  selectedObject: self parentTag
				  tooltip: (self
						   english: 'A tag can be a composite tag and contain other tags. If your new tag should be into a composite tag you can select it here.'
						   french: 'Un tag peut être un tag composite et contenir d''autres tags. Si votre nouveau tag devrait être à l''intérieur d''un tag composite vous avez la possibilité de le selectionner ici.')
				  sortBlock: [ :a :b | (a value isNil or: [ b value isNotNil ]) or: [ a <= b ] ])
				 entryTooltip: [ :tag | tag ifNotNil: #mooseName ];
				 yourself);
		break
]

{ #category : #rendering }
CPPSTagCreatorComponent >> renderWarningOn: html [

	self errorMessage ifNotNil:
		[ :warn | 
		html mdlAlert
			beDanger;
			with: warn.
		self errorMessage: nil
		]
]

{ #category : #action }
CPPSTagCreatorComponent >> resetVariables [

	self temporaryTag: FamixTag new.
	self parentTag: nil
]

{ #category : #selection }
CPPSTagCreatorComponent >> selectedTag: aTag [

	self parentTag: aTag
]

{ #category : #accessing }
CPPSTagCreatorComponent >> temporaryTag [

	^ temporaryTag
]

{ #category : #accessing }
CPPSTagCreatorComponent >> temporaryTag: anObject [

	temporaryTag := anObject
]

{ #category : #accessing }
CPPSTagCreatorComponent >> title [

	^ self
		  english: 'Create a new Tag'
		  french: 'Créer un nouveau tag'
]
