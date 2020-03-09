Class {
	#name : #CPPSPackage,
	#superclass : #CPPSContainerEntity,
	#traits : 'FamixTPackage + FamixTWithFunctions',
	#classTraits : 'FamixTPackage classTrait + FamixTWithFunctions classTrait',
	#category : #'CPPS-Entities-Entities'
}

{ #category : #meta }
CPPSPackage class >> annotation [

	<FMClass: #Package super: #CPPSContainerEntity>
	<package: #'CPPS-Entities'>
	<generated>
	^self
]
