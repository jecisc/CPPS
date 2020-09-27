Trait {
	#name : #CPPSTQueryBrowserComponent,
	#instVars : [
		'owner'
	],
	#category : #'CPPS-Toolkit-QueryBrowser-Core'
}

{ #category : #accessing }
CPPSTQueryBrowserComponent classSide >> owner: aComponent [

	^ self new
		  owner: aComponent;
		  yourself
]

{ #category : #accessing }
CPPSTQueryBrowserComponent >> focusedQuery [

	^ self owner focusedQuery
]

{ #category : #accessing }
CPPSTQueryBrowserComponent >> modelQuery [

	^ self owner modelQuery
]

{ #category : #accessing }
CPPSTQueryBrowserComponent >> owner [

	^ owner
]

{ #category : #accessing }
CPPSTQueryBrowserComponent >> owner: aComponent [

	owner := aComponent
]

{ #category : #accessing }
CPPSTQueryBrowserComponent >> queryPath [

	^ self owner queryPath
]

{ #category : #accessing }
CPPSTQueryBrowserComponent >> queryResult [

	^ self owner queryResult
]

{ #category : #accessing }
CPPSTQueryBrowserComponent >> selectedEntities [

	^ self owner selectedEntities
]

{ #category : #accessing }
CPPSTQueryBrowserComponent >> selectedEntities: aCollection [

	^ self owner selectedEntities: aCollection
]

{ #category : #action }
CPPSTQueryBrowserComponent >> useQuery: aQuery [

	self owner useQuery: aQuery
]
