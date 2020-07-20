"
Description
--------------------

I am a bridge between a Famix entity and an architectural element.
"
Class {
	#name : #CPPSArchitectureEntityBridge,
	#superclass : #Object,
	#instVars : [
		'famixEntity',
		'architectureElement'
	],
	#category : #'CPPS-Architecture-Model'
}

{ #category : #'instance creation' }
CPPSArchitectureEntityBridge class >> from: anArchitecturalElement to: aFAMIXPackage [
	^ self new
		architectureElement: anArchitecturalElement;
		entity: aFAMIXPackage
]

{ #category : #accessing }
CPPSArchitectureEntityBridge >> architectureElement [
	^ architectureElement
]

{ #category : #accessing }
CPPSArchitectureEntityBridge >> architectureElement: anObject [
	architectureElement := anObject
]

{ #category : #accessing }
CPPSArchitectureEntityBridge >> entity [
	^ famixEntity
]

{ #category : #accessing }
CPPSArchitectureEntityBridge >> entity: anObject [
	self flag: 'Should not target really an entity'.
	famixEntity := anObject
]

{ #category : #testing }
CPPSArchitectureEntityBridge >> includesTag: aTag [
	^ (self entity tagsInModel: aTag mooseModel) includes: aTag
]

{ #category : #testing }
CPPSArchitectureEntityBridge >> isAssigned [
	^ self entity isNotNil
]

{ #category : #accessing }
CPPSArchitectureEntityBridge >> name [
	^ self entity mooseName
]
