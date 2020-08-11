"
Description
--------------------

I am a comparator to be used by FQPropertyQuery subclasses to compare the value of an entity property to a value given by a user.

I use #endsWith: to compare the values.

Public API and Key Messages
--------------------

- class>>#compare:to: 		Compare a value to another one.

"
Class {
	#name : #FQEndsWithComparator,
	#superclass : #FQStringPropertyComparator,
	#category : #'Famix-Queries-Model-Comparators'
}

{ #category : #accessing }
FQEndsWithComparator class >> compare: aValue to: anotherValue [
	^ aValue endsWith: anotherValue
]

{ #category : #accessing }
FQEndsWithComparator class >> label [
	^ 'Ends with'
]
