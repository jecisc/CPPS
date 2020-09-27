Class {
	#name : #CPPSAbstractArchitectureRightPanel,
	#superclass : #CPPSAbstractRightPanel,
	#instVars : [
		'tagListComponent',
		'selectedTag',
		'categories'
	],
	#category : #'CPPS-Toolkit-ArchitectureSimulation'
}

{ #category : #accessing }
CPPSAbstractArchitectureRightPanel >> categories [

	^ categories
]

{ #category : #accessing }
CPPSAbstractArchitectureRightPanel >> categories: anObject [

	categories := anObject
]

{ #category : #components }
CPPSAbstractArchitectureRightPanel >> categoryEditorComponent [

	^ CPPSCategoriesEditorComponent
		  categories: self categories
		  addCategoryBlock: [ :cat | self categories add: cat ]
		  removeCategoryBlock: [ :cat | self categories remove: cat ]
		  jQueryScriptBlock:
			  [ :canvas | 
			  (canvas jQuery: '#architecture-tags_select-list-component') load
				  html: [ :ajaxHtml | ajaxHtml render: self tagListComponent ];
				  onComplete: 'componentHandler.upgradeDom();'
			  ]
		  title: (self
				   english: 'Filters'
				   french: 'Filtres')
]

{ #category : #action }
CPPSAbstractArchitectureRightPanel >> createTagNamed: aName [

	self flag: #todo. "For now I set the ivar to not trigger the highlight of the tag in the visu because we refresh the page. When the new tag component will not refresh the page anymore I should use the setter!"
	^ selectedTag := (self tagModel tagNamed: (aName ifEmpty: [ 'unnamed' ]))
		                 categories: self categories;
		                 yourself
]

{ #category : #components }
CPPSAbstractArchitectureRightPanel >> defaultListComponent [

	^ (CPPSTagListComponent
		   tags: [ self filteredTags ]
		   actionBlock: [ :tag | self select: tag ]
		   actionTooltipBlock:
			   [ :tag | 
			   self
				   english: 'Select a tag to highlight'
				   french: 'Sélectionner un tag à mettre en évidence'
			   ])
		  actionLabelBlock: [ :tag | self labelFor: tag ];
		  successMessage: (self
				   english: 'Tag selected'
				   french: 'Tag selectionné');
		  refreshAllComponent;
		  yourself
]

{ #category : #accessing }
CPPSAbstractArchitectureRightPanel >> filteredTags [

	^ self subclassResponsibility
]

{ #category : #initialization }
CPPSAbstractArchitectureRightPanel >> initialize [

	super initialize.
	self tagListComponent: self defaultListComponent.
	self categories: OrderedCollection new
]

{ #category : #accessing }
CPPSAbstractArchitectureRightPanel >> labelFor: aTag [

	^ self selectedTag = aTag
		  ifTrue: [ #label ]
		  ifFalse: [ #label_outline ]
]

{ #category : #components }
CPPSAbstractArchitectureRightPanel >> newTagComponent [

	^ CPPSSimpleNewTagComponent
		  label: (self
				   english: 'New tag named'
				   french: 'Nouveau tag nommé')
		  creationBlock: [ :name | self createTagNamed: name ]
]

{ #category : #action }
CPPSAbstractArchitectureRightPanel >> select: aTag [

	^ self selectedTag: aTag
]

{ #category : #accessing }
CPPSAbstractArchitectureRightPanel >> selectedTag [

	^ selectedTag
]

{ #category : #accessing }
CPPSAbstractArchitectureRightPanel >> selectedTag: aTag [

	self owner selectedTag: aTag.
	selectedTag := aTag
]

{ #category : #accessing }
CPPSAbstractArchitectureRightPanel >> tagListComponent [

	^ tagListComponent
]

{ #category : #accessing }
CPPSAbstractArchitectureRightPanel >> tagListComponent: anObject [

	tagListComponent := anObject
]
