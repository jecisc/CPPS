"
Description
--------------------

I am a comparator to be used by FQPropertyQuery subclasses to compare the value of an entity property to a value given by a user.

I use #< to compare the values.

Public API and Key Messages
--------------------

- class>>#compare:to: 		Compare a value to another one.

"
Class {
	#name : #FQLessThanComparator,
	#superclass : #FQNumericPropertyComparator,
	#category : #'Famix-Queries-Model-Comparators'
}

{ #category : #accessing }
FQLessThanComparator class >> compare: aValue to: anotherValue [
	^ aValue < anotherValue
]

{ #category : #accessing }
FQLessThanComparator class >> label [
	^ #<
]
