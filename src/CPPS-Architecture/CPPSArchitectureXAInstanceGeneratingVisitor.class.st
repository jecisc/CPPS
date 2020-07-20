Class {
	#name : #CPPSArchitectureXAInstanceGeneratingVisitor,
	#superclass : #XAInstanceGeneratingVisitor,
	#category : #'CPPS-Architecture-Importer'
}

{ #category : #visiting }
CPPSArchitectureXAInstanceGeneratingVisitor class >> visit: umlModel with: aGenerator [
	^ self new
		generator: aGenerator;
		visit: umlModel
]

{ #category : #visiting }
CPPSArchitectureXAInstanceGeneratingVisitor >> visitElement: anElement [
	| previousArchitectureElement return |
	previousArchitectureElement := self generator currentComponent.
	return := super visitElement: anElement.
	self generator currentComponent: previousArchitectureElement.
	^ return
]
