"
Description
--------------------

I am a proxy object that points a real query. I am used by the CPPSQueryPathComponent when we are creating a new query.
"
Class {
	#name : #FQFakeCreationQuery,
	#superclass : #FQAbstractQuery,
	#category : #'CPPS-Toolkit-QueryBrowser-Util'
}

{ #category : #accessing }
FQFakeCreationQuery >> comparisonValue [

	^ ''
]

{ #category : #testing }
FQFakeCreationQuery >> isFakeQuery [

	^ true
]

{ #category : #accessing }
FQFakeCreationQuery >> propertyComponent [

	^ CPPSNewLeafQueryPanelComponent
]

{ #category : #testing }
FQFakeCreationQuery >> queryToRunToFor: aModelQuery [

	^ self parentQuery == aModelQuery query
		  ifFalse: [ self parentQuery ]
		  ifTrue: [ self ]
]

{ #category : #action }
FQFakeCreationQuery >> useQuery: aQuery [

	self parentQuery addQuery: aQuery
]
