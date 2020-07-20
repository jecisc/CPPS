"
Description
--------------------

I am a leaf architecture component, i can represent a package, a class or any group of entities and i am the terminal element of an architecture.

I am not linked to any real entity such as a tag or a famix entity.

"
Class {
	#name : #CPPSArchitectureComponent,
	#superclass : #CPPSArchitectureEntity,
	#category : #'CPPS-Architecture-Model'
}

{ #category : #meta }
CPPSArchitectureComponent class >> annotation [
	<FMClass: #Component super: #CPPSArchitectureEntity >
	<package: #CPPS>
]
