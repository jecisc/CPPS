"
Description
--------------------

I am a leaf query. I do not need any other query to be executed. 

I follow the composite design pattern.
"
Class {
	#name : #FQLeafQuery,
	#superclass : #FQAbstractQuery,
	#category : #'Famix-Queries-Model-Leafs'
}

{ #category : #testing }
FQLeafQuery class >> isAbstract [
	^ self = FQLeafQuery
]

{ #category : #adding }
FQLeafQuery >> addQuery: aQuery [
	FQSequenceQuery new
		replace: self;
		addQuery: self;
		addQuery: aQuery
]

{ #category : #run }
FQLeafQuery >> runOn: aModel upTo: aQuery [
	super runOn: aModel upTo: aQuery.
	^ self runOn: aModel
]
