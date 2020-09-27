"
Description
--------------------

I am an abstract class to define an entity filter. 

My subclasses should be use by a CPPSFilterComponent in order to manage a list of entities. 

I have a name that the component can display.

Public API and Key Messages
--------------------

- class>> #named: aString 		This is my constructor
- class>> #priority 				The value return by this method allow to sort the filters to know in which order apply them. This is important because additif filters should be use before restrictifs ones.
- #filter: aCollection 				This method is the one that should be use in order to filter a Collection. 
- #isDefault 						This method will make the filter be apply by default if we do not set specific filter by hand in the filter component.
			
Example
--------------------
 
	See my subclasses because I am abstract

Internal Representation and Key Implementation Points.
--------------------

    Instance Variables
	name:		<aString> 	The name of the filter that should be display to the user
	default: 		<aBoolean> 	This is a boolean to know if the filter should be enable by default
"
Class {
	#name : #CPPSAbstractFilter,
	#superclass : #Object,
	#instVars : [
		'name',
		'default',
		'priority'
	],
	#category : #'CPPS-Toolkit-Core-Filters'
}

{ #category : #rendering }
CPPSAbstractFilter class >> iconName [

	^ self subclassResponsibility
]

{ #category : #testing }
CPPSAbstractFilter class >> isAbstract [

	^ self = CPPSAbstractFilter
]

{ #category : #'instance creation' }
CPPSAbstractFilter class >> named: aString [

	^ self new
		  name: aString;
		  yourself
]

{ #category : #accessing }
CPPSAbstractFilter class >> priority [

	^ self subclassResponsibility
]

{ #category : #accessing }
CPPSAbstractFilter >> default [

	^ default
]

{ #category : #action }
CPPSAbstractFilter >> filter: aCollection [

	^ self subclassResponsibility
]

{ #category : #rendering }
CPPSAbstractFilter >> iconName [

	^ self class iconName
]

{ #category : #initialization }
CPPSAbstractFilter >> initialize [

	super initialize.
	default := false
]

{ #category : #accessing }
CPPSAbstractFilter >> isDefault [

	default := true
]

{ #category : #accessing }
CPPSAbstractFilter >> model: aModel [
	"do nothing"
]

{ #category : #accessing }
CPPSAbstractFilter >> name [

	^ name
]

{ #category : #accessing }
CPPSAbstractFilter >> name: anObject [

	name := anObject
]

{ #category : #accessing }
CPPSAbstractFilter >> priority [

	^ priority ifNil: [ self class priority ]
]

{ #category : #accessing }
CPPSAbstractFilter >> priority: anInteger [

	priority := anInteger
]
