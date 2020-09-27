"
Description
--------------------

I am an abstract class for the CPPSNavigationComponent sub components.

Public API and Key Messages
--------------------

- #updateWith: 		Update the list of entities to show

Internal Representation and Key Implementation Points.
--------------------

    Instance Variables
	owner:		<aComponent>	The CPPSNavigationComponent that own me.

"
Class {
	#name : #CPPSAbstractNavigationSubComponent,
	#superclass : #CPPSComponent,
	#instVars : [
		'owner'
	],
	#category : #'CPPS-Toolkit-Core-Filters'
}

{ #category : #'instance creation' }
CPPSAbstractNavigationSubComponent class >> owner: aNavigationComponent [

	^ self new
		  owner: aNavigationComponent;
		  yourself
]

{ #category : #accessing }
CPPSAbstractNavigationSubComponent class >> title [

	"Should return the title of the component in a TranslatedText form."

	^ self subclassResponsibility
]

{ #category : #accessing }
CPPSAbstractNavigationSubComponent >> actionOnUpdate [

	^ self owner actionOnUpdate
]

{ #category : #accessing }
CPPSAbstractNavigationSubComponent >> owner [

	^ owner
]

{ #category : #accessing }
CPPSAbstractNavigationSubComponent >> owner: anObject [

	owner := anObject
]

{ #category : #accessing }
CPPSAbstractNavigationSubComponent >> title [

	^ self class title
]

{ #category : #accessing }
CPPSAbstractNavigationSubComponent >> updateWith: aCollectionOfEntities [

	self actionOnUpdate value: aCollectionOfEntities
]
