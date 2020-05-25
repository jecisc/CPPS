Class {
	#name : #CPPSFunction,
	#superclass : #CPPSBehaviouralEntity,
	#traits : 'FamixTFunction',
	#classTraits : 'FamixTFunction classTrait',
	#category : #'CPPS-Entities-Entities'
}

{ #category : #meta }
CPPSFunction class >> annotation [

	<FMClass: #Function super: #CPPSBehaviouralEntity>
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
