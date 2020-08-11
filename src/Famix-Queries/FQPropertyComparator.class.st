"
Description
--------------------

I am an abstract comparator to be used by FQPropertyQuery subclasses to compare the value of an entity property to a value given by a user.

Public API and Key Messages
--------------------

- class>>#compare:to: 		Compare a value to another one.

"
Class {
	#name : #FQPropertyComparator,
	#superclass : #Object,
	#category : #'Famix-Queries-Model-Comparators'
}

{ #category : #accessing }
FQPropertyComparator class >> comparators [
	^ self allSubclasses reject: #isAbstract
]

{ #category : #accessing }
FQPropertyComparator class >> compare: aValue to: anotherValue [
	^ self subclassResponsibility
]

{ #category : #accessing }
FQPropertyComparator class >> defaultComparator [
	^ self comparators detect: #isDefault
]

{ #category : #testing }
FQPropertyComparator class >> isAbstract [
	^ self = FQPropertyComparator
]

{ #category : #testing }
FQPropertyComparator class >> isDefault [
	^ false
]

{ #category : #accessing }
FQPropertyComparator class >> label [
	^ self subclassResponsibility
]
