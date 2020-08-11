"
Description
--------------------

I am a property query specialize on boolean properties.
"
Class {
	#name : #FQBooleanQuery,
	#superclass : #FQPropertyQuery,
	#category : #'Famix-Queries-Model-Leafs'
}

{ #category : #accessing }
FQBooleanQuery class >> comparatorClass [
	^ FQBooleanPropertyComparator
]

{ #category : #accessing }
FQBooleanQuery class >> type [
	^ FM3Boolean
]

{ #category : #printing }
FQBooleanQuery >> displayName [
	^ String
		streamContents: [ :s | 
			s << comparator displayName.
			self description ifNotNil: [ :d | s << d ] ]
]

{ #category : #initialization }
FQBooleanQuery >> initialize [
	super initialize.
	comparisonValue := true
]
