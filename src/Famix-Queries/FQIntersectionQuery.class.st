"
Description
--------------------

I am a composite query that will return a result containing the intersection of all the results of my sub queries. (Equivalent to AND)
"
Class {
	#name : #FQIntersectionQuery,
	#superclass : #FQCompositeQuery,
	#category : #'Famix-Queries-Model-Composites'
}

{ #category : #accessing }
FQIntersectionQuery class >> compositeName [
	^ 'AND'
]

{ #category : #run }
FQIntersectionQuery >> runOn: aMooseGroup collect: aBlock [
	^ ((self childrenQueries collect: aBlock) fold: [ :a :b | a intersection: b ]) asMooseGroup
]
