Class {
	#name : #CPPSMethod,
	#superclass : #CPPSBehaviouralEntity,
	#traits : 'FamixTHasModifiers + FamixTMethod + FamixTWithTypes',
	#classTraits : 'FamixTHasModifiers classTrait + FamixTMethod classTrait + FamixTWithTypes classTrait',
	#category : #'CPPS-Entities-Entities'
}

{ #category : #meta }
CPPSMethod class >> annotation [

	<FMClass: #Method super: #CPPSBehaviouralEntity>
	<package: #'CPPS-Entities'>
	<generated>
	^self
]

{ #category : #accessing }
CPPSMethod >> clientTypes [
	<FMProperty: #clientTypes type: #FamixTType>
	<multivalued>
	<derived>
	<FMComment: 'All types that depend on the receiver'>
	^ (self queryAllIncoming atScope: FamixTType) withoutSelfLoops
]

{ #category : #testing }
CPPSMethod >> isConstructor [
	^ self parentType ifNotNil: [ :type | self name = type name ]
]

{ #category : #testing }
CPPSMethod >> isConstructor: aBoolean [
	"In this MM we should infer if a method is a constructor"

	self shouldNotImplement
]

{ #category : #testing }
CPPSMethod >> isDead [
	<FMProperty: #isDead type: #Boolean>
	<derived>
	<FMComment: 'Is the entity dead (not invoked in the system)'>
	(self isConstructor or: [ self isDestructor ]) ifTrue: [ ^ false ].

	^ self isContainerEntity
		ifTrue: [ self lookUpPropertyNamed: #isDead computedAs: [ self hasIncomingDependencies not or: [ self queryIncomingDependencies withoutSelfLoops isEmpty ] ] ]
		ifFalse: [ false ]
]

{ #category : #testing }
CPPSMethod >> isDestructor [
	^ self parentType ifNotNil: [ :type | self name = ('~' , type name) ]
]
