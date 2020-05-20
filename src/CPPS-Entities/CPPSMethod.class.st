Class {
	#name : #CPPSMethod,
	#superclass : #CPPSBehavioralEntity,
	#traits : 'FamixTHasModifiers + FamixTMethod + FamixTWithTypes',
	#classTraits : 'FamixTHasModifiers classTrait + FamixTMethod classTrait + FamixTWithTypes classTrait',
	#category : #'CPPS-Entities-Entities'
}

{ #category : #meta }
CPPSMethod class >> annotation [

	<FMClass: #Method super: #CPPSBehavioralEntity>
	<package: #'CPPS-Entities'>
	<generated>
	^self
]

{ #category : #accessing }
CPPSMethod >> clientTypes [
	<MSEProperty: #clientTypes type: #FamixTType>
	<multivalued>
	<derived>
	<MSEComment: 'All types that depend on the receiver'>
	^ (self queryAllIncoming atScope: FamixTType) withoutSelfLoops
]

{ #category : #testing }
CPPSMethod >> isConstructor [
	^ self parentType ifNotNil: [ :type | self name = type name ]
]

{ #category : #testing }
CPPSMethod >> isConstructor: aBoolean [
	"In this MM we should infer if a method is a constructor"

	self shouldNotImplement
]

{ #category : #testing }
CPPSMethod >> isDead [
	(self isConstructor or: [ self isDestructor ]) ifTrue: [ ^ false ].

	^ super isDead
]

{ #category : #testing }
CPPSMethod >> isDestructor [
	^ self parentType ifNotNil: [ :type | self name = ('~' , type name) ]
]
