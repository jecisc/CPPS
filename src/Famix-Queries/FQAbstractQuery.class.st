"
Description
--------------------

I am an abstract class to define a query object. I have description, which is useful to remind of my purpose and a parent query because I use a Composite design pattern.	
 
Internal Representation and Key Implementation Points.
--------------------

    Instance Variables
	description:		<aString>					Description of the query.
	parentQuery:		<aCompositeQuery>		Parent query. If nil, this means I'm the root query.

"
Class {
	#name : #FQAbstractQuery,
	#superclass : #Object,
	#traits : 'RuTQuery',
	#classTraits : 'RuTQuery classTrait',
	#instVars : [
		'description',
		'parentQuery'
	],
	#category : #'Famix-Queries-Model-Core'
}

{ #category : #testing }
FQAbstractQuery class >> isAbstract [
	^ self = FQAbstractQuery
]

{ #category : #composition }
FQAbstractQuery >> , aQuery [
	^ FQSequenceQuery new
		addQuery: self;
		addQuery: aQuery;
		yourself
]

{ #category : #comparing }
FQAbstractQuery >> = anObject [
	anObject species = self species ifFalse: [ ^ false ].
	^ super = anObject or: [ self species = anObject species and: [ self description = anObject description ] ]
]

{ #category : #adding }
FQAbstractQuery >> addQuery: aQuery [
	self subclassResponsibility
]

{ #category : #accessing }
FQAbstractQuery >> children [
	^ #()
]

{ #category : #composition }
FQAbstractQuery >> delete [
	self parentQuery removeQuery: self
]

{ #category : #accessing }
FQAbstractQuery >> description [
	^ description ifNil: [ 'Query' ]
]

{ #category : #accessing }
FQAbstractQuery >> description: anObject [
	description := anObject
]

{ #category : #printing }
FQAbstractQuery >> displayName [
	^ 'Query'
]

{ #category : #accessing }
FQAbstractQuery >> explanation [
	^ self displayName
]

{ #category : #'instance creation' }
FQAbstractQuery >> named: aString [
	^ FQNamedQuery query: self named: aString 
]

{ #category : #accessing }
FQAbstractQuery >> parentQuery [
	^ parentQuery
]

{ #category : #accessing }
FQAbstractQuery >> parentQuery: anObject [
	parentQuery := anObject
]

{ #category : #printing }
FQAbstractQuery >> printOn: aStream [
	super printOn: aStream.
	self description
		ifNotNil: [ :desc | 
			aStream
				nextPut: $(;
				nextPutAll: desc;
				nextPut: $) ]
]

{ #category : #composition }
FQAbstractQuery >> replace: aCompositeQuery [
	self parentQuery: aCompositeQuery parentQuery.
	self parentQuery children at: (self parentQuery childrenQueries indexOf: aCompositeQuery) put: self
]

{ #category : #serialization }
FQAbstractQuery >> resetParent [
	self parentQuery: nil
]

{ #category : #run }
FQAbstractQuery >> runOn: aMooseGroup [
	^ self subclassResponsibility
]

{ #category : #run }
FQAbstractQuery >> runOn: aModel upTo: aQuery [
	aQuery = self ifTrue: [ FQQueryReached signal: aModel ]
]

{ #category : #run }
FQAbstractQuery >> runWithoutOmmissionOn: aGroup [ 
	^ self runOn: aGroup
]

{ #category : #serialization }
FQAbstractQuery >> useCombinator: aClass [
	self parentQuery useCombinator: aClass on: self
]

{ #category : #accessing }
FQAbstractQuery >> withAncestorsIncludes: aQuery [
	self == aQuery ifTrue: [ ^ true ].

	^ self parentQuery
		ifNil: [ false ]
		ifNotNil: [ :query | query withAncestorsIncludes: aQuery ]
]
