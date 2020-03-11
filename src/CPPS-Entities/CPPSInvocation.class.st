Class {
	#name : #CPPSInvocation,
	#superclass : #MooseEntity,
	#traits : 'FamixTInvocation',
	#classTraits : 'FamixTInvocation classTrait',
	#category : #'CPPS-Entities-Entities'
}

{ #category : #meta }
CPPSInvocation class >> annotation [

	<FMClass: #Invocation super: #MooseEntity>
	<package: #'CPPS-Entities'>
	<generated>
	^self
]

{ #category : #meta }
CPPSInvocation class >> metamodel [

	<generated>
	^ CPPSModel metamodel
]

{ #category : #testing }
CPPSInvocation >> isAccess [

	<generated>
	^ false
]

{ #category : #testing }
CPPSInvocation >> isAssociation [

	<generated>
	^ false
]

{ #category : #testing }
CPPSInvocation >> isAttribute [

	<generated>
	^ false
]

{ #category : #testing }
CPPSInvocation >> isClass [

	<generated>
	^ false
]

{ #category : #testing }
CPPSInvocation >> isFunction [

	<generated>
	^ false
]

{ #category : #testing }
CPPSInvocation >> isInheritance [

	<generated>
	^ false
]

{ #category : #testing }
CPPSInvocation >> isMethod [

	<generated>
	^ false
]

{ #category : #testing }
CPPSInvocation >> isNamespace [

	<generated>
	^ false
]

{ #category : #testing }
CPPSInvocation >> isPackage [

	<generated>
	^ false
]

{ #category : #testing }
CPPSInvocation >> isStructuralEntity [

	<generated>
	^ false
]

{ #category : #testing }
CPPSInvocation >> isType [

	<generated>
	^ false
]
