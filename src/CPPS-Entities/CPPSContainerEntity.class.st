Class {
	#name : #CPPSContainerEntity,
	#superclass : #CPPSNamedEntity,
	#category : #'CPPS-Entities-Entities'
}

{ #category : #meta }
CPPSContainerEntity class >> annotation [

	<FMClass: #ContainerEntity super: #CPPSNamedEntity>
	<package: #'CPPS-Entities'>
	<generated>
	^self
]

{ #category : #'as yet unclassified' }
CPPSContainerEntity >> allClients [
	^ self lookUpPropertyNamed: #allClients computedAs: [ super allClients ]
]

{ #category : #'as yet unclassified' }
CPPSContainerEntity >> allProviders [
	^ self lookUpPropertyNamed: #allProviders computedAs: [ super allProviders ]
]
