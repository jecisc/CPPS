"
Description
--------------------

I am a composite query that apply each query on the result of the previous query in my child query collection.
"
Class {
	#name : #FQSequenceQuery,
	#superclass : #FQCompositeQuery,
	#category : #'Famix-Queries-Model-Composites'
}

{ #category : #accessing }
FQSequenceQuery class >> compositeName [
	^ 'Sequence'
]

{ #category : #composition }
FQSequenceQuery >> , aQuery [
	^ self copy
		addQuery: aQuery;
		yourself
]

{ #category : #iterating }
FQSequenceQuery >> doWithIndex: aBlockClosure [
	self childrenQueries doWithIndex: aBlockClosure
]

{ #category : #run }
FQSequenceQuery >> runOn: aMooseGroup [
	^ (self childrenQueries inject: aMooseGroup into: [ :result :each | each runOn: result ]) asMooseGroup
]

{ #category : #run }
FQSequenceQuery >> runOn: aMooseGroup collect: aBlock [
	self shouldNotImplement
]

{ #category : #run }
FQSequenceQuery >> runOn: aMooseGroup upTo: aQuery [
	aQuery = self ifTrue: [ FQQueryReached signal: aMooseGroup ].
	^ (self childrenQueries inject: aMooseGroup into: [ :result :each | each runOn: result upTo: aQuery ]) asMooseGroup
]

{ #category : #run }
FQSequenceQuery >> runWithoutOmmissionOn: aGroup [
	^ self childrenQueries inject: aGroup into: [ :result :each | each runWithoutOmmissionOn: result ]
]
