"
Description
--------------------

I am an abstract comparator adding a system of regex cache for performance reasons.

Public API and Key Messages
--------------------

- class>>#compare:to: 		Compare a value to another one.

"
Class {
	#name : #FQAbstractRegexComparator,
	#superclass : #FQStringPropertyComparator,
	#classVars : [
		'LastPattern'
	],
	#category : #'Famix-Queries-Model-Comparators'
}

{ #category : #accessing }
FQAbstractRegexComparator class >> compare: aValue to: pattern [
	^ (self regexFor: pattern) matches: aValue
]

{ #category : #testing }
FQAbstractRegexComparator class >> isAbstract [
	^ self = FQAbstractRegexComparator
]

{ #category : #accessing }
FQAbstractRegexComparator class >> regexFor: string [
	"For perf because it is colsty to manipulate the string and create the regex."

	(LastPattern isNil or: [ LastPattern key ~= string ]) ifTrue: [ LastPattern := string -> (self regexFrom: string) ].

	^ LastPattern value
]

{ #category : #accessing }
FQAbstractRegexComparator class >> regexFrom: string [
	^ self subclassResponsibility
]
