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
