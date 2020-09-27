Class {
	#name : #CPPSQueryBooleanFilterComponent,
	#superclass : #CPPSQueryFilterComponent,
	#category : #'CPPS-Toolkit-QueryBrowser-Core'
}

{ #category : #accessing }
CPPSQueryBooleanFilterComponent class >> englishName [

	^ 'Boolean properties filter'
]

{ #category : #accessing }
CPPSQueryBooleanFilterComponent class >> frenchName [

	^ 'Filtre de propriétées booléennes'
]

{ #category : #accessing }
CPPSQueryBooleanFilterComponent class >> priority [

	^ 20
]

{ #category : #accessing }
CPPSQueryBooleanFilterComponent >> modelClass [

	^ FQBooleanQuery
]

{ #category : #rendering }
CPPSQueryBooleanFilterComponent >> renderComparaisonValueFieldOn: html [

	"Nothing, the comparaison value will alwsay be true"

	
]
