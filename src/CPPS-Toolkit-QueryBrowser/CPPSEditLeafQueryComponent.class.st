"
Description
----------------

I am a component allowing the user to edit queries. Each kind of query is handled by a subclass of CPPSQueryComponent.
"
Class {
	#name : #CPPSEditLeafQueryComponent,
	#superclass : #CPPSNewLeafQueryPanelComponent,
	#category : #'CPPS-Toolkit-QueryBrowser-Core'
}

{ #category : #initialization }
CPPSEditLeafQueryComponent >> defaultQueriesComponentsClasses [

	^ { CPPSCreateQueryCombinatorComponent } , super defaultQueriesComponentsClasses
]

{ #category : #rendering }
CPPSEditLeafQueryComponent >> renderHeaderOn: html [

	super renderHeaderOn: html.
	self deleteQueryButton: html
]

{ #category : #accessing }
CPPSEditLeafQueryComponent >> title [

	^ self
		  english: 'Edit selected query'
		  french: 'Editer la requête selectionnée'
]
