Class {
	#name : #CPPSType,
	#superclass : #CPPSContainerEntity,
	#traits : 'FamixTHasModifiers + FamixTPackageable + FamixTType + FamixTWithMethods',
	#classTraits : 'FamixTHasModifiers classTrait + FamixTPackageable classTrait + FamixTType classTrait + FamixTWithMethods classTrait',
	#category : #'CPPS-Entities-Entities'
}

{ #category : #meta }
CPPSType class >> annotation [

	<FMClass: #Type super: #CPPSContainerEntity>
	<package: #'CPPS-Entities'>
	<generated>
	^self
]
