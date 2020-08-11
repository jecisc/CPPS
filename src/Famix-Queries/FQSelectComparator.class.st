"
Description
--------------------

I am a comparator to be used by FQPropertyQuery subclasses to compare the value of an entity property to a value given by a user.

I use #= to compare the values.

Public API and Key Messages
--------------------

- class>>#compare:to: 		Compare a value to another one.

"
Class {
	#name : #FQSelectComparator,
	#superclass : #FQBooleanPropertyComparator,
	#category : #'Famix-Queries-Model-Comparators'
}

{ #category : #accessing }
FQSelectComparator class >> compare: aValue to: anotherValue [
	^ aValue = anotherValue
]

{ #category : #accessing }
FQSelectComparator class >> displayName [
	^ 'w/'
]

{ #category : #testing }
FQSelectComparator class >> isDefault [
	^ true
]

{ #category : #accessing }
FQSelectComparator class >> label [
	^ 'Select entities matching'
]
