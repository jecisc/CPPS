Class {
	#name : #FQCorrelation,
	#superclass : #Object,
	#instVars : [
		'name',
		'columnsQuery',
		'linesQuery',
		'correlationQuery',
		'isCount',
		'caches'
	],
	#category : #'Famix-Queries-Model-Core'
}

{ #category : #accessing }
FQCorrelation >> columnsEntities [
	^ caches at: #columnsEntities
]

{ #category : #accessing }
FQCorrelation >> columnsQuery [
	^ columnsQuery
]

{ #category : #accessing }
FQCorrelation >> columnsQuery: anObject [
	columnsQuery := anObject
]

{ #category : #accessing }
FQCorrelation >> correlationQuery [
	^ correlationQuery
]

{ #category : #accessing }
FQCorrelation >> correlationQuery: anObject [
	correlationQuery := anObject
]

{ #category : #initialization }
FQCorrelation >> initialize [
	super initialize.
	columnsQuery := FQModelQuery new.
	linesQuery := FQModelQuery new.
	isCount := false.
	self resetCaches
]

{ #category : #accessing }
FQCorrelation >> initializeFor: aGroup [
	self resetCaches.
	caches at: #columnsEntities put: (self columnsQuery runOn: aGroup).
	caches at: #linesEntities put: (self linesQuery runOn: aGroup)
]

{ #category : #accessing }
FQCorrelation >> is: aColumnEntity correlatedTo: aLineEntity [
	^ (caches at: #columnEntitiesResults at: aColumnEntity ifAbsentPut: [ self correlationQuery runOn: aColumnEntity asMooseGroup ]) includes: aLineEntity
]

{ #category : #accessing }
FQCorrelation >> isCount [
	^ isCount
]

{ #category : #accessing }
FQCorrelation >> isCount: anObject [
	isCount := anObject
]

{ #category : #accessing }
FQCorrelation >> linesEntities [
	^ caches at: #linesEntities
]

{ #category : #accessing }
FQCorrelation >> linesQuery [
	^ linesQuery
]

{ #category : #accessing }
FQCorrelation >> linesQuery: anObject [
	linesQuery := anObject
]

{ #category : #accessing }
FQCorrelation >> name [
	^ name
]

{ #category : #accessing }
FQCorrelation >> name: anObject [
	name := anObject
]

{ #category : #accessing }
FQCorrelation >> numberOfMatchesFor: aColumnEntity correlatedTo: aLineEntity [
	self flag: #todo.	"Manage case where query end up in error"
	^ (caches at: #columnEntitiesResults at: aColumnEntity ifAbsentPut: [ self correlationQuery runWithoutOmmissionOn: aColumnEntity asMooseGroup ])
		occurrencesOf: aLineEntity
]

{ #category : #initialization }
FQCorrelation >> resetCaches [
	caches := Dictionary new.
	caches at: #columnEntitiesResults put: Dictionary new
]
