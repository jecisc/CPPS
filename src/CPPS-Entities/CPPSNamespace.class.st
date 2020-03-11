Class {
	#name : #CPPSNamespace,
	#superclass : #CPPSContainerEntity,
	#traits : 'FamixTNamespace + FamixTScopingEntity + FamixTWithFunctions + FamixTWithGlobalVariables + FamixTWithTypes',
	#classTraits : 'FamixTNamespace classTrait + FamixTScopingEntity classTrait + FamixTWithFunctions classTrait + FamixTWithGlobalVariables classTrait + FamixTWithTypes classTrait',
	#category : #'CPPS-Entities-Entities'
}

{ #category : #meta }
CPPSNamespace class >> annotation [

	<FMClass: #Namespace super: #CPPSContainerEntity>
	<package: #'CPPS-Entities'>
	<generated>
	^self
]
