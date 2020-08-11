"
Description
--------------------

I am a property query specialize on numeric properties.
"
Class {
	#name : #FQNumericQuery,
	#superclass : #FQPropertyQuery,
	#category : #'Famix-Queries-Model-Leafs'
}

{ #category : #accessing }
FQNumericQuery class >> comparatorClass [
	^ FQNumericPropertyComparator
]

{ #category : #accessing }
FQNumericQuery class >> type [
	^ FM3Number
]
