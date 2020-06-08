Class {
	#name : #CPPSNamedEntity,
	#superclass : #CPPSSourcedEntity,
	#traits : 'FamixTHasModifiers + FamixTNamedEntity + TDependencyQueries + TEntityMetaLevelDependency',
	#classTraits : 'FamixTHasModifiers classTrait + FamixTNamedEntity classTrait + TDependencyQueries classTrait + TEntityMetaLevelDependency classTrait',
	#category : #'CPPS-Entities-Entities'
}

{ #category : #meta }
CPPSNamedEntity class >> annotation [

	<FMClass: #NamedEntity super: #CPPSSourcedEntity>
	<package: #'CPPS-Entities'>
	<generated>
	^self
]
