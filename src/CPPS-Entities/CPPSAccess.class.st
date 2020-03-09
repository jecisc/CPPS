Class {
	#name : #CPPSAccess,
	#superclass : #MooseEntity,
	#traits : 'FamixTAccess',
	#classTraits : 'FamixTAccess classTrait',
	#category : #'CPPS-Entities-Entities'
}

{ #category : #meta }
CPPSAccess class >> annotation [

	<FMClass: #Access super: #MooseEntity>
	<package: #'CPPS-Entities'>
	<generated>
	^self
]

{ #category : #meta }
CPPSAccess class >> metamodel [

	<generated>
	^ CPPSModel metamodel
]

{ #category : #testing }
CPPSAccess >> isAssociation [

	<generated>
	^ false
]

{ #category : #testing }
CPPSAccess >> isAttribute [

	<generated>
	^ false
]

{ #category : #testing }
CPPSAccess >> isFunction [

	<generated>
	^ false
]

{ #category : #testing }
CPPSAccess >> isInheritance [

	<generated>
	^ false
]

{ #category : #testing }
CPPSAccess >> isInvocation [

	<generated>
	^ false
]

{ #category : #testing }
CPPSAccess >> isMethod [

	<generated>
	^ false
]

{ #category : #testing }
CPPSAccess >> isNamespace [

	<generated>
	^ false
]

{ #category : #testing }
CPPSAccess >> isPackage [

	<generated>
	^ false
]

{ #category : #testing }
CPPSAccess >> isStructuralEntity [

	<generated>
	^ false
]

{ #category : #testing }
CPPSAccess >> isType [

	<generated>
	^ false
]
