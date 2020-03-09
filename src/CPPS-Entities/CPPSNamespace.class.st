Class {
	#name : #CPPSNamespace,
	#superclass : #CPPSContainerEntity,
	#traits : 'FamixTNamespace + FamixTWithFunctions',
	#classTraits : 'FamixTNamespace classTrait + FamixTWithFunctions classTrait',
	#category : #'CPPS-Entities-Entities'
}

{ #category : #meta }
CPPSNamespace class >> annotation [

	<FMClass: #Namespace super: #CPPSContainerEntity>
	<package: #'CPPS-Entities'>
	<generated>
	^self
]
