Class {
	#name : #CPPSPackage,
	#superclass : #CPPSContainerEntity,
	#traits : 'FamixTPackage + FamixTPackageable + FamixTWithFunctions',
	#classTraits : 'FamixTPackage classTrait + FamixTPackageable classTrait + FamixTWithFunctions classTrait',
	#category : #'CPPS-Entities-Entities'
}

{ #category : #meta }
CPPSPackage class >> annotation [

	<FMClass: #Package super: #CPPSContainerEntity>
	<package: #'CPPS-Entities'>
	<generated>
	^self
]
