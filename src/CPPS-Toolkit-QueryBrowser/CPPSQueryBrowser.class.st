"
Description
-----------------

I am a browser allowing the user to make some queries of his applications's model and tag the result of those queries. Maybe in the future we will be able to do more than tagging. 

I am working with the query model available. The user should use me in two time. First he select the seed of the query (the seed know a kind of entity to begin with as a class or a function). This is done in the CPPSQuerySeedSelectionComponent. Second the user will build queries from that seed and see the result of the query step by step. This is done in the CPPSQueryManagementComponent.
 
Internal Representation and Key Implementation Points.
-----------------

    Instance Variables
	kindSelectionComponent:				<aComponent>		I am a component allowing the user to chose the seed of his query.
	queryManagementComponent:			<aComponent>		I am a component allowing the user to ake his queries and to tag them.
	queryPath:								<aComponent>		I am a component reminding the user where he is in his query. I allow him to cancel some steps.
	queryResult:								<aCollection>	I am a cache to not compute the queryResult all the time.
	selectedEntities:						<aCollection>	I am a collection containing a subset of the query result. The user can use this subset to tag only the interesting entities.

"
Class {
	#name : #CPPSQueryBrowser,
	#superclass : #CPPSAbstractBrowser,
	#instVars : [
		'queryPath',
		'kindSelectionComponent',
		'queryManagementComponent',
		'queryResult',
		'selectedEntities'
	],
	#category : #'CPPS-Toolkit-QueryBrowser-Core'
}

{ #category : #accessing }
CPPSQueryBrowser class >> browserName [

	^ 'Query Browser' french: 'Explorateur par requêtes'
]

{ #category : #accessing }
CPPSQueryBrowser class >> priority [

	^ 35
]

{ #category : #hooks }
CPPSQueryBrowser >> children [

	^ Array
		  with: self queryPath
		  with: self contentComponentToRender
]

{ #category : #action }
CPPSQueryBrowser >> combineFocusedQuery: aClassCombinatorQuery [

	self queryPath combineFocusedQuery: aClassCombinatorQuery
]

{ #category : #accessing }
CPPSQueryBrowser >> contentComponentToRender [

	^ self isAtRoot
		  ifTrue: [ self kindSelectionComponent ]
		  ifFalse: [ self queryManagementComponent ]
]

{ #category : #rendering }
CPPSQueryBrowser >> defaultKindSelectionComponent [

	^ CPPSQuerySeedSelectionComponent actionBlock: [ :aModelQuery | self setSeedQuery: aModelQuery ]
]

{ #category : #rendering }
CPPSQueryBrowser >> defaultQueryManagementComponent [

	^ CPPSQueryManagementComponent owner: self
]

{ #category : #components }
CPPSQueryBrowser >> defaultQueryPathComponent [

	^ CPPSQueryPathComponent refreshBlock: [ :queryRes | self queryResult: queryRes ]
]

{ #category : #action }
CPPSQueryBrowser >> deleteFocusedQuery [

	self queryPath deleteFocusedQuery
]

{ #category : #accessing }
CPPSQueryBrowser >> focusedQuery [

	^ self queryPath focusedQuery
]

{ #category : #initialization }
CPPSQueryBrowser >> initialize [

	super initialize.
	self queryPath: self defaultQueryPathComponent.
	self kindSelectionComponent: self defaultKindSelectionComponent.
	self queryManagementComponent: self defaultQueryManagementComponent
]

{ #category : #testing }
CPPSQueryBrowser >> isAtRoot [

	^ self queryPath isEmpty
]

{ #category : #accessing }
CPPSQueryBrowser >> kindSelectionComponent [

	^ kindSelectionComponent
]

{ #category : #accessing }
CPPSQueryBrowser >> kindSelectionComponent: anObject [

	kindSelectionComponent := anObject
]

{ #category : #accessing }
CPPSQueryBrowser >> modelQuery [

	^ self queryPath modelQuery
]

{ #category : #accessing }
CPPSQueryBrowser >> queryManagementComponent [

	^ queryManagementComponent
]

{ #category : #accessing }
CPPSQueryBrowser >> queryManagementComponent: anObject [

	queryManagementComponent := anObject
]

{ #category : #accessing }
CPPSQueryBrowser >> queryPath [

	^ queryPath
]

{ #category : #accessing }
CPPSQueryBrowser >> queryPath: anObject [

	queryPath := anObject
]

{ #category : #accessing }
CPPSQueryBrowser >> queryResult [

	^ queryResult
]

{ #category : #accessing }
CPPSQueryBrowser >> queryResult: anObject [

	queryResult := anObject.
	self selectedEntities: anObject asOrderedCollection
]

{ #category : #rendering }
CPPSQueryBrowser >> renderContentOn: html [

	html div
		class: #query;
		with:
			[ html div
				class: #'query-path';
				shadow: 2;
				with: [ html render: self queryPath ].
			html div
				class: #'query-content';
				with: [ html render: self contentComponentToRender ]
			]
]

{ #category : #accessing }
CPPSQueryBrowser >> selectedEntities [

	^ selectedEntities
]

{ #category : #accessing }
CPPSQueryBrowser >> selectedEntities: anObject [

	selectedEntities := anObject
]

{ #category : #'query-seed' }
CPPSQueryBrowser >> setSeedQuery: aModelQuery [

	self queryPath modelQuery: aModelQuery
]

{ #category : #action }
CPPSQueryBrowser >> useQuery: aQuery [

	self queryPath useQuery: aQuery
]
