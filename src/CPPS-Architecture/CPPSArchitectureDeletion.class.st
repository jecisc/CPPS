"
Description
--------------------

I am used when we want to show a diff between two architecture and an element was removed from an architecture.
 
Internal Representation and Key Implementation Points.
--------------------

    Instance Variables
	deletedElement:		<anEntity>	Deleted entity
"
Class {
	#name : #CPPSArchitectureDeletion,
	#superclass : #CPPSArchitectureEntity,
	#instVars : [
		'deletedElement'
	],
	#category : #'CPPS-Architecture-Model'
}

{ #category : #meta }
CPPSArchitectureDeletion class >> annotation [
	<FMClass: #DeletedElement super: #CPPSArchitectureEntity >
	<package: #CPPS>
]

{ #category : #accessing }
CPPSArchitectureDeletion class >> backgroundColor [
	^ MDLColor tint: #red code: '200'
]

{ #category : #'instance creation' }
CPPSArchitectureDeletion class >> deletedElement: anElement [
	^ self new
		deletedElement: anElement;
		yourself
]

{ #category : #accessing }
CPPSArchitectureDeletion >> deletedElement [
	^ deletedElement
]

{ #category : #accessing }
CPPSArchitectureDeletion >> deletedElement: anObject [
	deletedElement := anObject.
	self
		name: anObject name;
		parent: anObject;
		linkTo: anObject modelEntity
]

{ #category : #accessing }
CPPSArchitectureDeletion >> parent: aParent [
	(self isAncestorOf: aParent) ifTrue: [ self error: 'The node is ancestor of the one you want to set as parent, it will create a cycle' ].
	parent := aParent
]
