"
Description
--------------------

I am a property query specialize on string properties.
"
Class {
	#name : #FQStringQuery,
	#superclass : #FQPropertyQuery,
	#category : #'Famix-Queries-Model-Leafs'
}

{ #category : #accessing }
FQStringQuery class >> comparatorClass [
	^ FQStringPropertyComparator
]

{ #category : #'instance creation' }
FQStringQuery class >> nameMatches: aPattern [
	^ (self property: #name description: #Name)
		comparator: FQEasyPatternComparator;
		comparisonValue: aPattern;
		yourself
]

{ #category : #accessing }
FQStringQuery class >> type [
	^ FM3String
]
