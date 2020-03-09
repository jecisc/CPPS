Class {
	#name : #CPPSNamedEntity,
	#superclass : #CPPSSourcedEntity,
	#traits : 'FamixTNamedEntity + TDependencyQueries + TEntityMetaLevelDependency',
	#classTraits : 'FamixTNamedEntity classTrait + TDependencyQueries classTrait + TEntityMetaLevelDependency classTrait',
	#category : #'CPPS-Entities-Entities'
}

{ #category : #meta }
CPPSNamedEntity class >> annotation [

	<FMClass: #NamedEntity super: #CPPSSourcedEntity>
	<package: #'CPPS-Entities'>
	<generated>
	^self
]
