Class {
	#name : #CPPSTagListComponentFilter,
	#superclass : #CPPSTagListToolComponent,
	#category : #'CPPS-Toolkit-QueryBrowser-TagManager'
}

{ #category : #private }
CPPSTagListComponentFilter >> applyFilter [

	self subclassResponsibility
]

{ #category : #accessing }
CPPSTagListComponentFilter >> elements: elementsCollection [

	elements := elementsCollection.
	self tagListComponent elementsToDisplay: self applyFilter
]

{ #category : #accessing }
CPPSTagListComponentFilter >> elementsToDisplay [

	^ self applyFilter
]

{ #category : #accessing }
CPPSTagListComponentFilter >> synchElements [

	self tagListComponent elementsToDisplay: self applyFilter
]
