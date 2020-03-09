Class {
	#name : #CPPSType,
	#superclass : #CPPSContainerEntity,
	#traits : 'FamixTHasModifiers + FamixTType',
	#classTraits : 'FamixTHasModifiers classTrait + FamixTType classTrait',
	#category : #'CPPS-Entities-Entities'
}

{ #category : #meta }
CPPSType class >> annotation [

	<FMClass: #Type super: #CPPSContainerEntity>
	<package: #'CPPS-Entities'>
	<generated>
	^self
]
