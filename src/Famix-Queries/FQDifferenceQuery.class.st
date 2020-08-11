"
Description
--------------------

I am a composite query that will select the difference between the incoming entities and the result of each sub queries one by one.

Those, it will always select the complementary of the query. (Equivalent to a NOT)
"
Class {
	#name : #FQDifferenceQuery,
	#superclass : #FQCompositeQuery,
	#category : #'Famix-Queries-Model-Composites'
}

{ #category : #accessing }
FQDifferenceQuery class >> compositeName [
	^ 'NOT'
]

{ #category : #run }
FQDifferenceQuery >> runOn: aMooseGroup collect: aBlock [
	^ ((self childrenQueries collect: aBlock) fold: [ :a :b | a difference: b ]) asMooseGroup
]
