Class {
	#name : #CPPSCategoriesEditorComponent,
	#superclass : #CPPSAbstractChipsSelectorComponent,
	#category : #'CPPS-Toolkit-QueryBrowser-TagManager'
}

{ #category : #'instance creation' }
CPPSCategoriesEditorComponent class >> categories: aCollection addCategoryBlock: aBlock removeCategoryBlock: aBlock2 [

	^ self
		  input: aCollection
		  addBlock: aBlock
		  removeBlock: aBlock2
]

{ #category : #'instance creation' }
CPPSCategoriesEditorComponent class >> categories: aCollection addCategoryBlock: aBlock removeCategoryBlock: aBlock2 jQueryScriptBlock: aBlock3 title: aString [

	^ self
		  input: aCollection
		  addBlock: aBlock
		  removeBlock: aBlock2
		  jQueryScriptBlock: aBlock3
		  title: aString
]

{ #category : #accessing }
CPPSCategoriesEditorComponent >> categories [

	^ self inputCollection
]

{ #category : #components }
CPPSCategoriesEditorComponent >> createNewCategoryWidget [

	^ (MDLTextFieldWidget
		   labeled: (self
				    english: 'New category'
				    french: 'Nouvelle categories')
		   callback: [ :cat | cat size > 2 ifTrue: [ self addBlock value: (self model tagCategoryNamed: cat) ] ]
		   floatingLabel: true)
		  pattern: '.{3,}'
		  errorMessage: 'Category name should have at least 3 characters';
		  yourself
]

{ #category : #accessing }
CPPSCategoriesEditorComponent >> defaultTitle [

	^ 'Categories'
]

{ #category : #accessing }
CPPSCategoriesEditorComponent >> formatedNameFor: anObject [

	^ anObject name
]

{ #category : #accessing }
CPPSCategoriesEditorComponent >> possibleCategories [

	^ self model allTagCategories asOrderedCollection \ self categories
]

{ #category : #rendering }
CPPSCategoriesEditorComponent >> renderCreateNewCategoryOn: html [

	html form:
		[ html render: self createNewCategoryWidget.
		self
			renderSubmitButtonLabeled: (self
					 english: 'Create'
					 french: 'Créer')
			on: html
		]
]

{ #category : #rendering }
CPPSCategoriesEditorComponent >> renderSelectNewCategoryOn: html [

	self possibleCategories ifEmpty: [ ^ self ].
	html form:
		[ html render: self selectNewCategoryWidget.
		self
			renderSubmitButtonLabeled: (self
					 english: 'Add'
					 french: 'Ajouter')
			on: html
		]
]

{ #category : #rendering }
CPPSCategoriesEditorComponent >> renderSpecificDialogContentOn: html [

	self renderSelectNewCategoryOn: html.
	self renderCreateNewCategoryOn: html
]

{ #category : #rendering }
CPPSCategoriesEditorComponent >> renderSpecificDialogTitleOn: html [

	^ self
		  english: 'Add a category'
		  french: 'Ajoutez une categorie'
]

{ #category : #rendireng }
CPPSCategoriesEditorComponent >> renderSubmitButtonLabeled: aString on: html [

	html mdlMajorButton
		bePush;
		onClick: (html jQuery ajax
				 serializeForm;
				 context: 'this' js;
				 onComplete: (self ajaxSuccessScriptFrom: html));
		with: aString
]

{ #category : #components }
CPPSCategoriesEditorComponent >> selectNewCategoryWidget [

	^ (MDLSelectWidget
		   possibilities: self possibleCategories
		   inputLabel: (self
				    english: 'Select category'
				    french: 'Selectionnez la catégorie')
		   labelBlock: #name
		   callback: [ :cat | self addBlock value: cat ])
		  standardSorting;
		  yourself
]
