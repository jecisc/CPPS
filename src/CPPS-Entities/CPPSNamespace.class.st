Class {
	#name : #CPPSNamespace,
	#superclass : #CPPSContainerEntity,
	#traits : 'FamixTNamespace + FamixTWithFunctions + FamixTWithGlobalVariables + FamixTWithTypes',
	#classTraits : 'FamixTNamespace classTrait + FamixTWithFunctions classTrait + FamixTWithGlobalVariables classTrait + FamixTWithTypes classTrait',
	#instVars : [
		'#childScopes => FMMany type: #CPPSNamespace opposite: #parentScope',
		'#parentScope => FMOne type: #CPPSNamespace opposite: #childScopes'
	],
	#category : #'CPPS-Entities-Entities'
}

{ #category : #meta }
CPPSNamespace class >> annotation [

	<FMClass: #Namespace super: #CPPSContainerEntity>
	<package: #'CPPS-Entities'>
	<generated>
	^self
]

{ #category : #adding }
CPPSNamespace >> addChildScope: anObject [
	<generated>
	^ self childScopes add: anObject
]

{ #category : #accessing }
CPPSNamespace >> childScopes [
	"Relation named: #childScopes type: #CPPSNamespace opposite: #parentScope"

	<generated>
	<FMComment: 'Child scopes embedded in this scope, if any.'>
	<derived>
	^ childScopes
]

{ #category : #accessing }
CPPSNamespace >> childScopes: anObject [

	<generated>
	childScopes value: anObject
]

{ #category : #accessing }
CPPSNamespace >> parentScope [
	"Relation named: #parentScope type: #CPPSNamespace opposite: #childScopes"

	<generated>
	<FMComment: 'Parent scope embedding this scope, if any.'>
	<container>
	^ parentScope
]

{ #category : #accessing }
CPPSNamespace >> parentScope: anObject [

	<generated>
	parentScope := anObject
]

{ #category : #navigation }
CPPSNamespace >> parentScopeGroup [
	<generated>
	<navigation: 'ParentScope'>
	^ MooseGroup with: self parentScope
]
