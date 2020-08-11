"
Description
--------------------

I am a query directly applied on a model.

I first restrain the query types then apply the query I contain to the selected entities.
 
Internal Representation and Key Implementation Points.
--------------------

    Instance Variables
	entityTypes:		<aCollection>		List of types from the model to keep to apply the query.
	query:				<aQuery>				Query to apply on selected entities.

"
Class {
	#name : #FQModelQuery,
	#superclass : #FQAbstractQuery,
	#instVars : [
		'entityTypes',
		'query'
	],
	#category : #'Famix-Queries-Model-Core'
}

{ #category : #'instance creation' }
FQModelQuery class >> entityType: aMetaModelClass [
	^ self new
		entityType: aMetaModelClass;
		yourself
]

{ #category : #'instance creation' }
FQModelQuery class >> entityTypes: aCollection query: aComposableQuery [
	^ self new
		entityTypes: aCollection;
		query: aComposableQuery;
		yourself
]

{ #category : #comparing }
FQModelQuery >> = anObject [
	^ super = anObject and: [ self entityTypes = anObject entityTypes ]
]

{ #category : #adding }
FQModelQuery >> addQuery: aQuery [
	self
		query:
			(self query
				ifNil: [ FQSequenceQuery with: aQuery ]
				ifNotNil: [ :q | q , aQuery ])
]

{ #category : #converting }
FQModelQuery >> asRule [
	^ RuQueryRule from: self
]

{ #category : #accessing }
FQModelQuery >> childrenQueries [
	^ self query
		ifNil: [ #() ]
		ifNotNil: #childrenQueries
]

{ #category : #printing }
FQModelQuery >> displayName [
	^ String
		streamContents: [ :s | 
			s nextPutAll: 'All '.
			self entityTypes do: [ :entity | s nextPutAll: entity englishName asLowercase pluralize ] separatedBy: [ s space ] ]
]

{ #category : #accessing }
FQModelQuery >> entityType: anObject [
	entityTypes := OrderedCollection with: anObject
]

{ #category : #accessing }
FQModelQuery >> entityTypes [
	^ entityTypes
]

{ #category : #accessing }
FQModelQuery >> entityTypes: aSet [
	entityTypes := aSet
]

{ #category : #run }
FQModelQuery >> getEntytiesOn: aModel [
	"Before we were casting to a set, but it is not effective and should not be needed can an entity can only be of one kind at a time."

	^ self entityTypes asMooseGroup flatCollect: [ :each | aModel allWithTypeWithoutStub: each ]
]

{ #category : #testing }
FQModelQuery >> hasComposableQuery [
	^ self query isNotNil
]

{ #category : #initialization }
FQModelQuery >> initialize [
	super initialize.
	entityTypes := OrderedCollection new
]

{ #category : #copying }
FQModelQuery >> postCopy [
	"Needed for memento pattern of correlations"

	self entityTypes: self entityTypes copy.
	self query: self query copy
]

{ #category : #printing }
FQModelQuery >> printOn: aStream [
	super printOn: aStream.
	aStream nextPut: $(.
	entityTypes printElementsOn: aStream.
	aStream nextPut: $)
]

{ #category : #accessing }
FQModelQuery >> query [
	^ query
]

{ #category : #accessing }
FQModelQuery >> query: aComposableQuery [
	query := aComposableQuery
]

{ #category : #removing }
FQModelQuery >> removeComposableQuery [
	self query: nil
]

{ #category : #removing }
FQModelQuery >> removeLast [
	self query removeLast.
	self query children ifEmpty: [ self removeComposableQuery ]
]

{ #category : #run }
FQModelQuery >> runOn: aModel [
	| entities |
	entities := self getEntytiesOn: aModel.
	^ self query
		ifNil: [ entities ]
		ifNotNil: [ :q | q runOn: entities ]
]

{ #category : #run }
FQModelQuery >> runOn: aModel upTo: aQuery [
	| entities |
	entities := self getEntytiesOn: aModel.
	^ self query
		ifNil: [ entities ]
		ifNotNil: [ :query | 
			[ super runOn: aModel upTo: aQuery.
			query runOn: entities upTo: aQuery ]
				on: FQQueryReached
				do: [ :e | e result ] ]
]

{ #category : #run }
FQModelQuery >> runWithoutOmmissionOn: aGroup [
	^ self query runWithoutOmmissionOn: (self getEntytiesOn: aGroup)
]

{ #category : #printing }
FQModelQuery >> storeOn: aStream [
	aStream
		nextPut: $(;
		nextPutAll: self className;
		nextPutAll: ' entityTypes: { '.
	entityTypes do: [ :type | type storeOn: aStream ] separatedBy: [ aStream nextPutAll: ' . ' ].
	aStream nextPutAll: '} query: '.

	query storeOn: aStream.

	aStream nextPut: $)
]
