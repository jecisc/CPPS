Class {
	#name : #CPPSType,
	#superclass : #CPPSContainerEntity,
	#traits : 'FamixTHasModifiers + FamixTType + FamixTWithMethods',
	#classTraits : 'FamixTHasModifiers classTrait + FamixTType classTrait + FamixTWithMethods classTrait',
	#category : #'CPPS-Entities-Entities'
}

{ #category : #meta }
CPPSType class >> annotation [

	<FMClass: #Type super: #CPPSContainerEntity>
	<package: #'CPPS-Entities'>
	<generated>
	^self
]
