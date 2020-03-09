Class {
	#name : #CPPSFunction,
	#superclass : #CPPSBehavioralEntity,
	#traits : 'FamixTFunction + FamixTHasSignature + FamixTTypedEntity',
	#classTraits : 'FamixTFunction classTrait + FamixTHasSignature classTrait + FamixTTypedEntity classTrait',
	#category : #'CPPS-Entities-Entities'
}

{ #category : #meta }
CPPSFunction class >> annotation [

	<FMClass: #Function super: #CPPSBehavioralEntity>
	<package: #'CPPS-Entities'>
	<generated>
	^self
]

{ #category : #printing }
CPPSFunction >> mooseNameOn: stream [
	| parent |
	parent := self functionOwner.
	parent
		ifNotNil: [ parent mooseNameOn: stream.
			stream nextPut: $. ].
	self signature ifNotNil: [ stream nextPutAll: self signature ] ifNil: [ self name ifNotNil: [ stream nextPutAll: self name ] ]
]
