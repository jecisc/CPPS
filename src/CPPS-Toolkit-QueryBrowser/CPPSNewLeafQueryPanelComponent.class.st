"
Description
----------------

I am a component allowing the user to create and apply queries. Each kind of query is handled by a subclass of CPPSQueryComponent.
"
Class {
	#name : #CPPSNewLeafQueryPanelComponent,
	#superclass : #CPPSQueryPanelComponent,
	#instVars : [
		'components'
	],
	#category : #'CPPS-Toolkit-QueryBrowser-Core'
}

{ #category : #hooks }
CPPSNewLeafQueryPanelComponent >> children [

	^ self components
]

{ #category : #accessing }
CPPSNewLeafQueryPanelComponent >> components [

	^ components
]

{ #category : #accessing }
CPPSNewLeafQueryPanelComponent >> components: anObject [

	components := anObject
]

{ #category : #initialization }
CPPSNewLeafQueryPanelComponent >> defaultQueriesComponentsClasses [

	^ CPPSQueryComponent components
]

{ #category : #initialization }
CPPSNewLeafQueryPanelComponent >> initializeQueriesComponents [

	self components: (self defaultQueriesComponentsClasses collect: [ :aComponentClass | aComponentClass owner: self ])
]

{ #category : #accessing }
CPPSNewLeafQueryPanelComponent >> title [

	^ self
		  english: 'Apply new query'
		  french: 'Appliquer une nouvelle requête'
]
