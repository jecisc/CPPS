Class {
	#name : #CPPSBehavioralEntity,
	#superclass : #CPPSContainerEntity,
	#traits : 'FamixTInvocable + FamixTWithAccesses + FamixTWithInvocations',
	#classTraits : 'FamixTInvocable classTrait + FamixTWithAccesses classTrait + FamixTWithInvocations classTrait',
	#category : #'CPPS-Entities-Entities'
}

{ #category : #meta }
CPPSBehavioralEntity class >> annotation [

	<FMClass: #BehavioralEntity super: #CPPSContainerEntity>
	<package: #'CPPS-Entities'>
	<generated>
	^self
]
