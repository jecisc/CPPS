"
Description
--------------------

I am an abstract comparator to be used by FQNumericQuery subclasses to compare the value of an entity property to a value given by a user.

Public API and Key Messages
--------------------

- class>>#compare:to: 		Compare a value to another one.

"
Class {
	#name : #FQNumericPropertyComparator,
	#superclass : #FQPropertyComparator,
	#category : #'Famix-Queries-Model-Comparators'
}

{ #category : #testing }
FQNumericPropertyComparator class >> isAbstract [
	^ self = FQNumericPropertyComparator
]
