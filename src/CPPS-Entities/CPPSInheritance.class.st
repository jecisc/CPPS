Class {
	#name : #CPPSInheritance,
	#superclass : #MooseEntity,
	#traits : 'FamixTInheritance',
	#classTraits : 'FamixTInheritance classTrait',
	#category : #'CPPS-Entities-Entities'
}

{ #category : #meta }
CPPSInheritance class >> annotation [

	<FMClass: #Inheritance super: #MooseEntity>
	<package: #'CPPS-Entities'>
	<generated>
	^self
]

{ #category : #meta }
CPPSInheritance class >> metamodel [

	<generated>
	^ CPPSModel metamodel
]

{ #category : #testing }
CPPSInheritance >> isAccess [

	<generated>
	^ false
]

{ #category : #testing }
CPPSInheritance >> isAssociation [

	<generated>
	^ false
]

{ #category : #testing }
CPPSInheritance >> isAttribute [

	<generated>
	^ false
]

{ #category : #testing }
CPPSInheritance >> isClass [

	<generated>
	^ false
]

{ #category : #testing }
CPPSInheritance >> isFunction [

	<generated>
	^ false
]

{ #category : #testing }
CPPSInheritance >> isInvocation [

	<generated>
	^ false
]

{ #category : #testing }
CPPSInheritance >> isMethod [

	<generated>
	^ false
]

{ #category : #testing }
CPPSInheritance >> isNamespace [

	<generated>
	^ false
]

{ #category : #testing }
CPPSInheritance >> isPackage [

	<generated>
	^ false
]

{ #category : #testing }
CPPSInheritance >> isStructuralEntity [

	<generated>
	^ false
]

{ #category : #testing }
CPPSInheritance >> isType [

	<generated>
	^ false
]
