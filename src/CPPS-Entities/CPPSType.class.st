Class {
	#name : #CPPSType,
	#superclass : #CPPSContainerEntity,
	#traits : 'FamixTClass + FamixTHasModifiers + FamixTWithTypes',
	#classTraits : 'FamixTClass classTrait + FamixTHasModifiers classTrait + FamixTWithTypes classTrait',
	#category : #'CPPS-Entities-Entities'
}

{ #category : #meta }
CPPSType class >> annotation [

	<FMClass: #Type super: #CPPSContainerEntity>
	<package: #'CPPS-Entities'>
	<generated>
	^self
]

{ #category : #deprecated }
CPPSType >> belongsTo [
	^ self parentPackage
]
