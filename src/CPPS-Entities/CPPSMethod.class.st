Class {
	#name : #CPPSMethod,
	#superclass : #CPPSBehavioralEntity,
	#traits : 'FamixTHasModifiers + FamixTMethod',
	#classTraits : 'FamixTHasModifiers classTrait + FamixTMethod classTrait',
	#category : #'CPPS-Entities-Entities'
}

{ #category : #meta }
CPPSMethod class >> annotation [

	<FMClass: #Method super: #CPPSBehavioralEntity>
	<package: #'CPPS-Entities'>
	<generated>
	^self
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
CPPSMethod >> isDestructor [
	^ self parentType ifNotNil: [ :type | self name = ('~' , type name) ]
]
