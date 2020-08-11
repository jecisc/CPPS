"
Description
--------------------

I am a comparator to be used by FQPropertyQuery subclasses to compare the value of an entity property to a value given by a user.

I use #beginsWith: to compare the values.

Public API and Key Messages
--------------------

- class>>#compare:to: 		Compare a value to another one.

"
Class {
	#name : #FQBeginsWithComparator,
	#superclass : #FQStringPropertyComparator,
	#category : #'Famix-Queries-Model-Comparators'
}

{ #category : #accessing }
FQBeginsWithComparator class >> compare: aValue to: anotherValue [
	^ aValue beginsWith: anotherValue
]

{ #category : #accessing }
FQBeginsWithComparator class >> label [
	^ 'Begins with'
]
