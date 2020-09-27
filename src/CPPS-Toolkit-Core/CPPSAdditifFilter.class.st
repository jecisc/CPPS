"
Description
--------------------

I am an additif filter.  My purpose is to add entities to the collection I am filtering.

I keep a model and a block that allow me to add entities to the collection I am filtering.

Example
--------------------
	
	(CPPSAdditifFilter named: 'Test') 
		model: aModel;
		modelQueryBlock: [ :model | model allClasses ];
		filter: #()

Internal Representation and Key Implementation Points.
--------------------

    Instance Variables
	model:					<aModel>			A model that will be use to execute the block
	modelQueryBlock:		<aValuable>			A block or a Symbol to be execute to get a collection of entities to add.

"
Class {
	#name : #CPPSAdditifFilter,
	#superclass : #CPPSAbstractFilter,
	#instVars : [
		'model',
		'modelQueryBlock'
	],
	#category : #'CPPS-Toolkit-Core-Filters'
}

{ #category : #rendering }
CPPSAdditifFilter class >> iconName [

	^ #add_circle_outline
]

{ #category : #accessing }
CPPSAdditifFilter class >> priority [

	^ 200
]

{ #category : #action }
CPPSAdditifFilter >> filter: aCollection [

	^ aCollection union: (self modelQueryBlock value: self model)
]

{ #category : #accessing }
CPPSAdditifFilter >> model [

	^ model value
]

{ #category : #accessing }
CPPSAdditifFilter >> model: aModel [

	model := aModel
]

{ #category : #accessing }
CPPSAdditifFilter >> modelQueryBlock [

	^ modelQueryBlock
]

{ #category : #accessing }
CPPSAdditifFilter >> modelQueryBlock: anObject [

	modelQueryBlock := anObject
]
