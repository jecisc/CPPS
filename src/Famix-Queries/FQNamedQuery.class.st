"
Description
--------------------

I am a query decoration adding a name to a query. 

I am mostly used to save queries in a user friendly way.
 
Internal Representation and Key Implementation Points.
--------------------

    Instance Variables
	name:		<aString>		The name of the query.
	query:		<aQuery>		The decorated query.

"
Class {
	#name : #FQNamedQuery,
	#superclass : #FQLeafQuery,
	#instVars : [
		'name',
		'query'
	],
	#category : #'Famix-Queries-Model-Leafs'
}

{ #category : #'instance creation' }
FQNamedQuery class >> query: aQuery named: aName [
	^ self new
		query: aQuery;
		name: aName;
		yourself
]

{ #category : #comparing }
FQNamedQuery >> = anObject [
	^ super = anObject and: [ self name = anObject name and: [ self query = anObject query ] ]
]

{ #category : #printing }
FQNamedQuery >> displayName [
	^ self name
]

{ #category : #accessing }
FQNamedQuery >> name [
	^ name
]

{ #category : #accessing }
FQNamedQuery >> name: anObject [
	name := anObject
]

{ #category : #accessing }
FQNamedQuery >> query [
	^ query
]

{ #category : #accessing }
FQNamedQuery >> query: aComposableQuery [
	query := aComposableQuery
]

{ #category : #run }
FQNamedQuery >> runOn: aMooseGroup [
	^ self query runOn: aMooseGroup
]

{ #category : #run }
FQNamedQuery >> runWithoutOmmissionOn: aGroup [
	^ self query runWithoutOmmissionOn: aGroup
]

{ #category : #printing }
FQNamedQuery >> storeOn: aStream [
	aStream
		nextPut: $(;
		nextPutAll: self className;
		nextPutAll: ' query: '.
	query storeOn: aStream.
	aStream
		nextPutAll: ' named: ';
		nextPutAll: name;
		nextPut: $)
]
