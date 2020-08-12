Class {
	#name : #CPPSContainerEntity,
	#superclass : #CPPSNamedEntity,
	#category : #'CPPS-Entities-Entities'
}

{ #category : #meta }
CPPSContainerEntity class >> annotation [

	<FMClass: #ContainerEntity super: #CPPSNamedEntity>
	<package: #'CPPS-Entities'>
	<generated>
	^self
]

{ #category : #display }
CPPSContainerEntity class >> priority [
	^ 300
]
