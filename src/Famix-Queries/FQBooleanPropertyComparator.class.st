"
Description
--------------------

I am an abstract comparator to be used by FQBooleanQuery subclasses to compare the value of an entity property to a value given by a user.

Public API and Key Messages
--------------------

- class>>#compare:to: 		Compare a value to another one.

"
Class {
	#name : #FQBooleanPropertyComparator,
	#superclass : #FQPropertyComparator,
	#category : #'Famix-Queries-Model-Comparators'
}

{ #category : #accessing }
FQBooleanPropertyComparator class >> displayName [
	^ self subclassResponsibility
]

{ #category : #testing }
FQBooleanPropertyComparator class >> isAbstract [
	^ self = FQBooleanPropertyComparator
]
