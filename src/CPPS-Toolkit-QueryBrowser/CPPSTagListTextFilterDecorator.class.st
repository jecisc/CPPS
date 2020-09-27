Class {
	#name : #CPPSTagListTextFilterDecorator,
	#superclass : #CPPSTagListComponentFilter,
	#instVars : [
		'id',
		'displayResearchFilter',
		'format'
	],
	#category : #'CPPS-Toolkit-QueryBrowser-TagManager'
}

{ #category : #filtering }
CPPSTagListTextFilterDecorator >> applyFilter [

	^ self displayResearchFilter isEmptyOrNil
		  ifTrue: [ self elements ]
		  ifFalse:
			  [ self elements select:
				  [ :element | 
				  ((self format value: element)
					   findString: self displayResearchFilter
					   startingAt: 1
					   caseSensitive: false) > 0
				  ]
			  ]
]

{ #category : #rendering }
CPPSTagListTextFilterDecorator >> componentTool [

	^ CPPSTextFilterComponent withOnChange:
		  [ :html | 
		  html jQuery ajax
			  callback: [ :filter | self displayResearchFilter: filter ]
			  value: (JSStream on: 'event.target.value');
			  onComplete: ((html jQuery: '#tagListContainer') load
					   html: [ :htm | self renderOnlyListOn: htm ];
					   onComplete: 'componentHandler.upgradeDom()')
		  ]
]

{ #category : #filtering }
CPPSTagListTextFilterDecorator >> displayResearchFilter [

	^ displayResearchFilter
]

{ #category : #filtering }
CPPSTagListTextFilterDecorator >> displayResearchFilter: aFilter [

	displayResearchFilter := aFilter.
	self synchElements
]

{ #category : #filtering }
CPPSTagListTextFilterDecorator >> format [

	^ format ifNil: [ #asString ]
]

{ #category : #filtering }
CPPSTagListTextFilterDecorator >> format: anObject [

	format := anObject
]

{ #category : #accessing }
CPPSTagListTextFilterDecorator >> id [

	^ id ifNil: [ '' ]
]

{ #category : #accessing }
CPPSTagListTextFilterDecorator >> id: aString [

	id := aString self tagListComponent id: (self idFor: #tagList)
]
