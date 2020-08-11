"
Description
--------------------

I am a comparator to be used by FQPropertyQuery subclasses to compare the value of an entity property to a value given by a user.

I use a regex to compare the values.

Public API and Key Messages
--------------------

- class>>#compare:to: 		Compare a value to another one.

"
Class {
	#name : #FQMatchesComparator,
	#superclass : #FQAbstractRegexComparator,
	#category : #'Famix-Queries-Model-Comparators'
}

{ #category : #accessing }
FQMatchesComparator class >> label [
	^ 'Matches (regex)'
]

{ #category : #accessing }
FQMatchesComparator class >> regexFrom: string [
	^ string asRegex
]
