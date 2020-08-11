"
Description
--------------------

I am an exception called when runOn:upTo: on a query find the query search.

I signal the resultat of the query runOn:.
"
Class {
	#name : #FQQueryReached,
	#superclass : #Exception,
	#instVars : [
		'result'
	],
	#category : #'Famix-Queries-Model-Core'
}

{ #category : #exceptioninstantiator }
FQQueryReached class >> signal: aResult [
	self new
		result: aResult;
		signal
]

{ #category : #accessing }
FQQueryReached >> result [
	^ result
]

{ #category : #accessing }
FQQueryReached >> result: anObject [
	result := anObject
]
