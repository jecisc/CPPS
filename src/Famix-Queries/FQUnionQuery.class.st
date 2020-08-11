"
Description
--------------------

I am a composite query that will return a result containing the union of all the results of my sub queries. (Equivalent to OR)
"
Class {
	#name : #FQUnionQuery,
	#superclass : #FQCompositeQuery,
	#category : #'Famix-Queries-Model-Composites'
}

{ #category : #accessing }
FQUnionQuery class >> compositeName [
	^ 'OR'
]

{ #category : #run }
FQUnionQuery >> runOn: aMooseGroup collect: aBlock [
	^ ((self childrenQueries collect: aBlock) fold: [ :a :b | a union: b ]) asMooseGroup
]
