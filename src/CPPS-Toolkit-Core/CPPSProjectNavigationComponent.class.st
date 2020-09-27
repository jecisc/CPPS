"
Description
--------------------

I am a simple sub component of the CPPSNavigationComponent to display the entities as a project view

"
Class {
	#name : #CPPSProjectNavigationComponent,
	#superclass : #CPPSAbstractNavigationSubComponent,
	#category : #'CPPS-Toolkit-Core-Filters'
}

{ #category : #accessing }
CPPSProjectNavigationComponent class >> title [

	^ 'Project Navigation' french: 'Navigation Projet'
]

{ #category : #accessing }
CPPSProjectNavigationComponent >> owner: anObject [

	super owner: anObject.
	self updateWith: self model allRootContainers
]
