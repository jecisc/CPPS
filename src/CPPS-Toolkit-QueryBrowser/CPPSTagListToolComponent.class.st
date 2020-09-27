Class {
	#name : #CPPSTagListToolComponent,
	#superclass : #CPPSTagListComponentAbstract,
	#instVars : [
		'tagListComponent'
	],
	#category : #'CPPS-Toolkit-QueryBrowser-TagManager'
}

{ #category : #accessing }
CPPSTagListToolComponent class >> tagList: aTagListComponent [

	^ self new
		  tagListComponent: aTagListComponent;
		  elements: aTagListComponent elements;
		  addTool;
		  yourself
]

{ #category : #adding }
CPPSTagListToolComponent >> addTool [

	self tagListComponent addTool: self componentTool
]

{ #category : #adding }
CPPSTagListToolComponent >> addTool: aComponent [

	self tagListComponent addTool: aComponent
]

{ #category : #accessing }
CPPSTagListToolComponent >> elements: elementsCollection [

	elements := elementsCollection.
	self tagListComponent elementsToDisplay: self elements
]

{ #category : #tools }
CPPSTagListToolComponent >> elementsToDisplay [

	^ self elements
]

{ #category : #rendering }
CPPSTagListToolComponent >> renderContentOn: html [

	html render: self tagListComponent
]

{ #category : #accessing }
CPPSTagListToolComponent >> renderOnlyListOn: html [

	self tagListComponent renderOnlyListOn: html
]

{ #category : #accessing }
CPPSTagListToolComponent >> synchElements [

	self tagListComponent elements: self elements
]

{ #category : #accessing }
CPPSTagListToolComponent >> tagListComponent [

	^ tagListComponent
]

{ #category : #accessing }
CPPSTagListToolComponent >> tagListComponent: aTagListComponent [

	tagListComponent := aTagListComponent
]

{ #category : #tools }
CPPSTagListToolComponent >> tools [

	^ self tagListComponent tools
]

{ #category : #rendering }
CPPSTagListToolComponent >> tools: aCollection [

	self tagListComponent tools: aCollection
]
