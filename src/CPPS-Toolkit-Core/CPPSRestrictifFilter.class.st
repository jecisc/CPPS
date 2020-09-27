"
Description
--------------------

I am a restrictif filter.  My purpose is to remove entities to the collection I am filtering.

I keep a block that allow me to select entities from the collection I am filtering.

Example
--------------------
	
	(CPPSRestrictifFilter named: 'Test') 
		booleanBlock: [ :entity | entity isDead];
		filter: aCollectionOfEntity

Internal Representation and Key Implementation Points.
--------------------

    Instance Variables
	booleanBlock:		<aBlockOrSymbol> 	A block or a Symbol to be execute to select a subset of the collection I am filtering

"
Class {
	#name : #CPPSRestrictifFilter,
	#superclass : #CPPSAbstractFilter,
	#instVars : [
		'booleanBlock'
	],
	#category : #'CPPS-Toolkit-Core-Filters'
}

{ #category : #rendering }
CPPSRestrictifFilter class >> iconName [

	^ #remove_circle_outline
]

{ #category : #accessing }
CPPSRestrictifFilter class >> priority [

	^ 100
]

{ #category : #accessing }
CPPSRestrictifFilter >> booleanBlock [

	^ booleanBlock
]

{ #category : #accessing }
CPPSRestrictifFilter >> booleanBlock: anObject [

	booleanBlock := anObject
]

{ #category : #action }
CPPSRestrictifFilter >> filter: aCollection [

	^ aCollection select: self booleanBlock
]
