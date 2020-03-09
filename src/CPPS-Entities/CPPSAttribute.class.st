Class {
	#name : #CPPSAttribute,
	#superclass : #CPPSNamedEntity,
	#traits : 'FamixTAttribute + FamixTWithClassScope',
	#classTraits : 'FamixTAttribute classTrait + FamixTWithClassScope classTrait',
	#category : #'CPPS-Entities-Entities'
}

{ #category : #meta }
CPPSAttribute class >> annotation [

	<FMClass: #Attribute super: #CPPSNamedEntity>
	<package: #'CPPS-Entities'>
	<generated>
	^self
]
