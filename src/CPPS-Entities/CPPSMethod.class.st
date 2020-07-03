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
	^ #constructor = self kind or: [ self parentType ifNotNil: [ :type | self name = type name ] ]
]

{ #category : #testing }
CPPSMethod >> isDead [
	<FMProperty: #isDead type: #Boolean>
	<derived>
	<FMComment: 'Is the entity dead (not invoked in the system)'>
	(self isConstructor or: [ self isDestructor ]) ifTrue: [ ^ false ].

	^ self isContainerEntity
		ifTrue: [ self lookUpPropertyNamed: #isDead computedAs: [ self hasIncomingDependencies not or: [ self queryAllIncoming withoutSelfLoops isEmpty ] ] ]
		ifFalse: [ false ]
]

{ #category : #testing }
CPPSMethod >> isDestructor [
	^ #destructor = self kind or: [ self parentType ifNotNil: [ :type | self name = ('~' , type name) ] ]
]

{ #category : #accessing }
CPPSMethod >> isDestructor: aBoolean [
	aBoolean
		ifTrue: [ self kind: #destructor ]
		ifFalse: [ self isDestructor
				ifTrue: [ self kind: nil ] ]
]
