Class {
	#name : #CPPSTagListTagFilterDecorator,
	#superclass : #CPPSTagListComponentFilter,
	#instVars : [
		'categories'
	],
	#category : #'CPPS-Toolkit-QueryBrowser-TagManager'
}

{ #category : #adding }
CPPSTagListTagFilterDecorator >> addCategorie: cat [

	self categories add: cat.
	self synchElements
]

{ #category : #private }
CPPSTagListTagFilterDecorator >> applyFilter [

	^ self categories
		  ifEmpty: [ self elements ]
		  ifNotEmpty: [ self elements select: [ :el | self categories anySatisfy: [ :cat | el hasCategory: cat ] ] ]
]

{ #category : #accessing }
CPPSTagListTagFilterDecorator >> categories [

	^ categories
]

{ #category : #accessing }
CPPSTagListTagFilterDecorator >> categories: anObject [

	categories := anObject
]

{ #category : #rendering }
CPPSTagListTagFilterDecorator >> componentTool [

	^ CPPSCategoriesEditorComponent
		  categories: self categories
		  addCategoryBlock: [ :cat | self addCategorie: cat ]
		  removeCategoryBlock: [ :cat | self removeCategorie: cat ]
		  jQueryScriptBlock:
			  [ :canvas | 
			  self flag: 'regarder pour faire plus de chose en js (comme telescope) pour virer tous ces parents'.
			  (canvas jQuery: '#tagListContainer') load
				  html: [ :htm | self renderOnlyListOn: htm ];
				  onComplete: 'componentHandler.upgradeDom()'
			  ]
		  title: (self
				   english: 'Filters'
				   french: 'Filtres')
]

{ #category : #initialization }
CPPSTagListTagFilterDecorator >> initialize [

	super initialize.
	self categories: OrderedCollection new
]

{ #category : #removing }
CPPSTagListTagFilterDecorator >> removeCategorie: cat [

	self categories remove: cat.
	self synchElements
]
