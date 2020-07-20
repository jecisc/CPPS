"
Description
--------------------

This is to implement null pattern to avoid if nils. This is needed when the user has defined an architecture element but has not associated yet a model entity.
"
Class {
	#name : #CPPSArchitectureNullEntity,
	#superclass : #Object,
	#category : #'CPPS-Architecture-Model'
}

{ #category : #querying }
CPPSArchitectureNullEntity >> allClientsIn: aMooseGroup forModel: aMooseModel [
	"None there are no providers for null entity"
	^ #()
]

{ #category : #querying }
CPPSArchitectureNullEntity >> allProviders [
	^ #()
]

{ #category : #querying }
CPPSArchitectureNullEntity >> allProvidersIn: aMooseGroup forModel: aMooseModel [
	"None there are no providers for null entity"
	^ #()
]

{ #category : #compliance }
CPPSArchitectureNullEntity >> entity [
	^ nil
]

{ #category : #testing }
CPPSArchitectureNullEntity >> includesTag: aTag [
	^ false
]

{ #category : #testing }
CPPSArchitectureNullEntity >> isAssigned [
	^ false
]

{ #category : #accessing }
CPPSArchitectureNullEntity >> name [
	^ 'No concept assigned'
]

{ #category : #accessing }
CPPSArchitectureNullEntity >> tags [
	^ #()
]
