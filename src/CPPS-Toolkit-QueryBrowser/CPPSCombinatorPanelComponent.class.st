"
Description
----------------

I am a component allowing the user to edit combinatorQueries.
"
Class {
	#name : #CPPSCombinatorPanelComponent,
	#superclass : #CPPSQueryPanelComponent,
	#instVars : [
		'composeQueryComponent',
		'editCombinatorComponent'
	],
	#category : #'CPPS-Toolkit-QueryBrowser-Core'
}

{ #category : #hooks }
CPPSCombinatorPanelComponent >> children [

	^ Array
		  with: self composeQueryComponent
		  with: self editCombinatorComponent
]

{ #category : #accessing }
CPPSCombinatorPanelComponent >> composeQueryComponent [

	^ composeQueryComponent
]

{ #category : #accessing }
CPPSCombinatorPanelComponent >> composeQueryComponent: anObject [

	composeQueryComponent := anObject
]

{ #category : #accessing }
CPPSCombinatorPanelComponent >> editCombinatorComponent [

	^ editCombinatorComponent
]

{ #category : #accessing }
CPPSCombinatorPanelComponent >> editCombinatorComponent: anObject [

	editCombinatorComponent := anObject
]

{ #category : #initialization }
CPPSCombinatorPanelComponent >> initializeQueriesComponents [

	self composeQueryComponent: (CPPSCreateQueryCombinatorComponent owner: self).
	self editCombinatorComponent: (CPPSEditingQueryCombinatorComponent owner: self)
]

{ #category : #rendering }
CPPSCombinatorPanelComponent >> renderHeaderOn: html [

	super renderHeaderOn: html.
	self deleteQueryButton: html
]

{ #category : #accessing }
CPPSCombinatorPanelComponent >> title [

	^ self
		  english: 'Edit selected query'
		  french: 'Editer la requête selectionnée'
]
