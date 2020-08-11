"
Description
--------------------

I am an abstract query defining a query on an entity property.

I'll select entities whose value to the property matches my value via a comparator.	
 
Internal Representation and Key Implementation Points.
--------------------

    Instance Variables
	comparator:				<aComparator>	A FQPropertyComparator to use to compare the value of the property to my value.
	comparisonValue:		<anObject>		The value to compare the property of the entities to. The kind will depend on my subclasses.
	property:					<aSymbol>			A symbol representing the property of the entities to compare to my value.

"
Class {
	#name : #FQPropertyQuery,
	#superclass : #FQLeafQuery,
	#instVars : [
		'comparator',
		'property',
		'comparisonValue'
	],
	#category : #'Famix-Queries-Model-Leafs'
}

{ #category : #accessing }
FQPropertyQuery class >> availablePropertiesFor: aMooseGroup [
	^ (aMooseGroup allEntityTypes collect: [ :entity | entity famePropertiesOfType: self type ]) flatten collect: #implementingSelector
]

{ #category : #accessing }
FQPropertyQuery class >> comparatorClass [
	^ self subclassResponsibility
]

{ #category : #accessing }
FQPropertyQuery class >> comparators [
	^ self comparatorClass comparators
]

{ #category : #accessing }
FQPropertyQuery class >> defaultComparator [
	^ self comparatorClass defaultComparator
]

{ #category : #testing }
FQPropertyQuery class >> isAbstract [
	^ self = FQPropertyQuery
]

{ #category : #'instance creation' }
FQPropertyQuery class >> property: aSymbol comparator: aStrategy value: anObject [
	^ self new
		property: aSymbol;
		comparator: aStrategy;
		comparisonValue: anObject;
		yourself
]

{ #category : #'instance creation' }
FQPropertyQuery class >> property: aSelector description: aString [
	^ self new
		property: aSelector;
		description: aString;
		yourself
]

{ #category : #accessing }
FQPropertyQuery class >> type [
	^ self subclassResponsibility
]

{ #category : #comparing }
FQPropertyQuery >> = anObject [
	^ super = anObject
		and: [ self property = anObject property and: [ self comparator = anObject comparator and: [ self comparisonValue = anObject comparisonValue ] ] ]
]

{ #category : #accessing }
FQPropertyQuery >> comparator [
	^ comparator
]

{ #category : #accessing }
FQPropertyQuery >> comparator: anObject [
	comparator := anObject
]

{ #category : #accessing }
FQPropertyQuery >> comparators [
	^ self class comparators
]

{ #category : #accessing }
FQPropertyQuery >> comparisonValue [
	^ comparisonValue
]

{ #category : #accessing }
FQPropertyQuery >> comparisonValue: anObject [
	comparisonValue := anObject
]

{ #category : #initialization }
FQPropertyQuery >> defaultComparator [
	^ self class defaultComparator
]

{ #category : #printing }
FQPropertyQuery >> displayName [
	^ String
		streamContents: [ :s | 
			self description ifNotNil: [ :d | s nextPutAll: d ].
			self comparator
				ifNotNil: [ s
						space;
						nextPutAll: self comparator label ].
			self comparisonValue
				ifNotNil: [ s
						space;
						<< self comparisonValue asString ] ]
]

{ #category : #initialization }
FQPropertyQuery >> initialize [
	super initialize.
	comparator := self defaultComparator
]

{ #category : #accessing }
FQPropertyQuery >> property [
	
	^ property
]

{ #category : #accessing }
FQPropertyQuery >> property: anObject [
	
	property := anObject
]

{ #category : #run }
FQPropertyQuery >> runOn: aMooseGroup [
	^ aMooseGroup
		select: [ :e | 
			[ self comparator compare: (e perform: self property) to: self comparisonValue ]
				on: MessageNotUnderstood
				do: [ false ] ]
]

{ #category : #printing }
FQPropertyQuery >> storeOn: aStream [
	aStream
		nextPut: $(;
		nextPutAll: self className;
		nextPutAll: ' property: ';
		print: self property;
		nextPutAll: ' comparator: '.

	self comparator storeOn: aStream.

	aStream
		nextPutAll: ' value: ';
		print: self comparisonValue;
		nextPut: $)
]
