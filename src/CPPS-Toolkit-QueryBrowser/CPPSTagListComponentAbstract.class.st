Class {
	#name : #CPPSTagListComponentAbstract,
	#superclass : #CPPSComponent,
	#instVars : [
		'elements'
	],
	#category : #'CPPS-Toolkit-QueryBrowser-TagManager'
}

{ #category : #accessing }
CPPSTagListComponentAbstract >> elements [

	^ elements value
]

{ #category : #accessing }
CPPSTagListComponentAbstract >> elements: elementsCollection [

	elements := elementsCollection
]

{ #category : #accessing }
CPPSTagListComponentAbstract >> elementsToDisplay: elementsCollection [

	self elements: elementsCollection
]

{ #category : #tools }
CPPSTagListComponentAbstract >> tools [

	self subclassResponsibility
]

{ #category : #rendering }
CPPSTagListComponentAbstract >> tools: toolsCollection [

	self subclassResponsibility
]
