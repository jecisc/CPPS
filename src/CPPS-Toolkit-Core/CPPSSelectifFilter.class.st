"
Description
--------------------

I am a restrictif filter.  My purpose is to select only a certain subset of the collection I take in input.

I keep a collection of entities. During the filering I will keep only the entities of the input collection that are on those entities.

Example
--------------------
	
	(CPPSSelectifFilter named: 'Test') 
		entities:  aCollectionOfEntitiesToSelect;
		filter: aCollectionOfEntity

Internal Representation and Key Implementation Points.
--------------------

    Instance Variables
	entities:		<aCollectionOfEntities> 	A collection of entities that can be use in order to filter the collection I get as input

"
Class {
	#name : #CPPSSelectifFilter,
	#superclass : #CPPSAbstractFilter,
	#instVars : [
		'entities'
	],
	#category : #'CPPS-Toolkit-Core-Filters'
}

{ #category : #rendering }
CPPSSelectifFilter class >> iconName [

	^ #select_all
]

{ #category : #accessing }
CPPSSelectifFilter class >> priority [

	^ 150
]

{ #category : #accessing }
CPPSSelectifFilter >> entities [

	^ entities
]

{ #category : #accessing }
CPPSSelectifFilter >> entities: anObject [

	entities := anObject
]

{ #category : #action }
CPPSSelectifFilter >> filter: aCollection [

	^ aCollection union: self entities
]

{ #category : #initialization }
CPPSSelectifFilter >> initialize [

	super initialize.
	self name: ('Selection' french: 'Sélection')
]
