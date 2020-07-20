"
Description
--------------------

I an a simple object storing updates between two architectures.

I store additions, deletions and modifications.
"
Class {
	#name : #CPPSArchitectureUpdate,
	#superclass : #Object,
	#instVars : [
		'additions',
		'deletions',
		'modifications'
	],
	#category : #'CPPS-Architecture-Diff'
}

{ #category : #adding }
CPPSArchitectureUpdate >> addAddedNode: aArchitecturalElement [
	self additions add: aArchitecturalElement.
	self modifications addAll: aArchitecturalElement ancestors
]

{ #category : #adding }
CPPSArchitectureUpdate >> addDeletedNode: aArchitecturalElement [
	self deletions add: aArchitecturalElement.
	self modifications addAll: aArchitecturalElement ancestors
]

{ #category : #adding }
CPPSArchitectureUpdate >> addModifiedNode: aArchitecturalElement [
	self modifications add: aArchitecturalElement.
	self modifications addAll: aArchitecturalElement ancestors
]

{ #category : #accessing }
CPPSArchitectureUpdate >> additions [
	^ additions
]

{ #category : #accessing }
CPPSArchitectureUpdate >> colorFor: architectureElement [
	(self additions includes: architectureElement) ifTrue: [ ^ MDLColor green ].
	(self deletions anySatisfy: [ :entity | architectureElement mooseName = entity mooseName ]) ifTrue: [ ^ MDLColor red ].

	^ (self modifications includes: architectureElement)
		ifTrue: [ MDLColor orange ]
		ifFalse: [ MDLColor black ]
]

{ #category : #accessing }
CPPSArchitectureUpdate >> deletions [
	^ deletions
]

{ #category : #initialization }
CPPSArchitectureUpdate >> initialize [
	super initialize.
	additions := OrderedCollection new.
	deletions := OrderedCollection new.

	"To remove duplicates"
	modifications := Set new
]

{ #category : #accessing }
CPPSArchitectureUpdate >> modifications [
	^ modifications
]
