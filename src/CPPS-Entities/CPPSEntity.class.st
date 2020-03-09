Class {
	#name : #CPPSEntity,
	#superclass : #MooseEntity,
	#category : #'CPPS-Entities-Entities'
}

{ #category : #meta }
CPPSEntity class >> annotation [

	<FMClass: #Entity super: #MooseEntity>
	<package: #'CPPS-Entities'>
	<generated>
	^self
]

{ #category : #meta }
CPPSEntity class >> metamodel [

	<generated>
	^ CPPSModel metamodel
]

{ #category : #testing }
CPPSEntity >> isAccess [

	<generated>
	^ false
]

{ #category : #testing }
CPPSEntity >> isAssociation [

	<generated>
	^ false
]

{ #category : #testing }
CPPSEntity >> isAttribute [

	<generated>
	^ false
]

{ #category : #testing }
CPPSEntity >> isFunction [

	<generated>
	^ false
]

{ #category : #testing }
CPPSEntity >> isInheritance [

	<generated>
	^ false
]

{ #category : #testing }
CPPSEntity >> isInvocation [

	<generated>
	^ false
]

{ #category : #testing }
CPPSEntity >> isMethod [

	<generated>
	^ false
]

{ #category : #testing }
CPPSEntity >> isNamespace [

	<generated>
	^ false
]

{ #category : #testing }
CPPSEntity >> isPackage [

	<generated>
	^ false
]

{ #category : #testing }
CPPSEntity >> isStructuralEntity [

	<generated>
	^ false
]

{ #category : #testing }
CPPSEntity >> isType [

	<generated>
	^ false
]
