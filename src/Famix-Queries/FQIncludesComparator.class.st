"
Description
--------------------

I am a comparator to be used by FQPropertyQuery subclasses to compare the value of an entity property to a value given by a user.

I use #includesSubstring: to compare the values.

Public API and Key Messages
--------------------

- class>>#compare:to: 		Compare a value to another one.

"
Class {
	#name : #FQIncludesComparator,
	#superclass : #FQStringPropertyComparator,
	#category : #'Famix-Queries-Model-Comparators'
}

{ #category : #accessing }
FQIncludesComparator class >> compare: aValue to: anotherValue [
	^ aValue includesSubstring: anotherValue
]

{ #category : #accessing }
FQIncludesComparator class >> label [
	^ 'Includes'
]
