"
Description
--------------------

I am a comparator to be used by FQPropertyQuery subclasses to compare the value of an entity property to a value given by a user.

I use a pseudo regex to compare the values.

Public API and Key Messages
--------------------

- class>>#compare:to: 		Compare a value to another one.

"
Class {
	#name : #FQEasyPatternComparator,
	#superclass : #FQAbstractRegexComparator,
	#category : #'Famix-Queries-Model-Comparators'
}

{ #category : #testing }
FQEasyPatternComparator class >> isDefault [
	^ true
]

{ #category : #accessing }
FQEasyPatternComparator class >> label [
	^ 'Pattern'
]

{ #category : #accessing }
FQEasyPatternComparator class >> regexFrom: string [
	^ (String
		streamContents: [ :s | 
			(string includes: $*) ifFalse: [ s << '.*' ].
			s << ('.*' join: ($* split: string)).
			(string includes: $*) ifFalse: [ s << '.*' ] ]) asRegexIgnoringCase
]
