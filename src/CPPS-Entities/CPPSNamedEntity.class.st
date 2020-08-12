Class {
	#name : #CPPSNamedEntity,
	#superclass : #CPPSSourcedEntity,
	#traits : 'FamixTHasModifiers + FamixTNamedEntity + TEntityMetaLevelDependency',
	#classTraits : 'FamixTHasModifiers classTrait + FamixTNamedEntity classTrait + TEntityMetaLevelDependency classTrait',
	#category : #'CPPS-Entities-Entities'
}

{ #category : #meta }
CPPSNamedEntity class >> annotation [

	<FMClass: #NamedEntity super: #CPPSSourcedEntity>
	<package: #'CPPS-Entities'>
	<generated>
	^self
]

{ #category : #display }
CPPSNamedEntity >> priority [
	"Group public entities, protected entities, private entities and unknown modifier entities."
	
	self isPublic ifTrue: [ ^ self class priority + 3 ].
	
	self isProtected ifTrue: [ ^ self class priority + 2 ].
	
	self isPrivate ifTrue: [ ^ self class priority + 1 ].
	
	^ self class priority.
]
