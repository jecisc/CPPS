"
Description
--------------------

I am an abstract query defining the concept of composite queries. 

Composite queries are composed of leaf or other composite queries and will build the query result from the result of those sub queries. 

Each of my subclass will define *how* to build this result.
 
Internal Representation and Key Implementation Points.
--------------------

    Instance Variables
	childrenQueries:		<aCollection>		List of sub queries

"
Class {
	#name : #FQCompositeQuery,
	#superclass : #FQAbstractQuery,
	#instVars : [
		'childrenQueries'
	],
	#category : #'Famix-Queries-Model-Composites'
}

{ #category : #accessing }
FQCompositeQuery class >> compositeName [
	^ 'Undefined'
]

{ #category : #testing }
FQCompositeQuery class >> isAbstract [
	^ self = FQCompositeQuery
]

{ #category : #creation }
FQCompositeQuery class >> with: aQuery [
	^ self new
		parentQuery: aQuery parentQuery;
		addQuery: aQuery;
		yourself
]

{ #category : #creation }
FQCompositeQuery class >> withAll: aCollectionOfQueries [
	| query |
	query := self new.
	aCollectionOfQueries do: [ :aQuery | query addQuery: aQuery ].
	^ query
]

{ #category : #comparing }
FQCompositeQuery >> = anObject [
	^ super = anObject and: [ self childrenQueries = anObject childrenQueries ]
]

{ #category : #adding }
FQCompositeQuery >> addQuery: aQuery [
	self childrenQueries add: aQuery.
	aQuery parentQuery: self
]

{ #category : #accessing }
FQCompositeQuery >> children [
	^ self childrenQueries
]

{ #category : #accessing }
FQCompositeQuery >> childrenQueries [
	^ childrenQueries ifNil: [ childrenQueries := OrderedCollection new ]
]

{ #category : #accessing }
FQCompositeQuery >> compositeName [
	^ self class compositeName
]

{ #category : #printing }
FQCompositeQuery >> displayName [
	^ String
		streamContents: [ :s | 
			s
				nextPutAll: self compositeName;
				nextPut: $-;
				nextPutAll: self description ]
]

{ #category : #copying }
FQCompositeQuery >> postCopy [
	childrenQueries := childrenQueries collect: #copy.
	childrenQueries do: [ :aChildQuery | aChildQuery parentQuery: self ]
]

{ #category : #removing }
FQCompositeQuery >> removeLast [
	self childrenQueries removeLast resetParent
]

{ #category : #removing }
FQCompositeQuery >> removeQuery: aQuery [
	self childrenQueries remove: aQuery.
	aQuery resetParent
]

{ #category : #composition }
FQCompositeQuery >> replace: aQuery [
	super replace: aQuery.
	self childrenQueries addAll: aQuery children
]

{ #category : #run }
FQCompositeQuery >> runOn: aMooseGroup [
	^ self runOn: aMooseGroup collect: [ :each | each runOn: aMooseGroup ]
]

{ #category : #run }
FQCompositeQuery >> runOn: aMooseGroup collect: aBlock [
	self subclassResponsibility
]

{ #category : #run }
FQCompositeQuery >> runOn: aMooseGroup upTo: aQuery [
	super runOn: aMooseGroup upTo: aQuery.
	^ self runOn: aMooseGroup collect: [ :each | each runOn: aMooseGroup upTo: aQuery ]
]

{ #category : #printing }
FQCompositeQuery >> storeOn: aStream [
	aStream
		nextPut: $(;
		nextPutAll: self className;
		nextPutAll: ' withAll: { '.
	childrenQueries do: [ :asso | asso storeOn: aStream ] separatedBy: [ aStream nextPutAll: ' . ' ].
	aStream nextPutAll: '})'
]

{ #category : #moving }
FQCompositeQuery >> useCombinator: aClass on: aQuery [
	self children at: (self childrenQueries indexOf: aQuery) put: (aClass with: aQuery)
]
