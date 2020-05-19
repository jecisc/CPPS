Class {
	#name : #CPPSBehavioralEntity,
	#superclass : #CPPSContainerEntity,
	#traits : 'FamixTInvocable + FamixTWithAccesses + FamixTWithInvocations + FamixTWithStatements',
	#classTraits : 'FamixTInvocable classTrait + FamixTWithAccesses classTrait + FamixTWithInvocations classTrait + FamixTWithStatements classTrait',
	#instVars : [
		'#innerBlocks => FMOne type: #CPPSBlock opposite: #parentBlock'
	],
	#category : #'CPPS-Entities-Entities'
}

{ #category : #meta }
CPPSBehavioralEntity class >> annotation [

	<FMClass: #BehavioralEntity super: #CPPSContainerEntity>
	<package: #'CPPS-Entities'>
	<generated>
	^self
]

{ #category : #accessing }
CPPSBehavioralEntity >> innerBlocks [
	"Relation named: #innerBlocks type: #CPPSBlock opposite: #parentBlock"

	<generated>
	<FMComment: 'Blocks declared in this behavioural'>
	^ innerBlocks
]

{ #category : #accessing }
CPPSBehavioralEntity >> innerBlocks: anObject [

	<generated>
	innerBlocks := anObject
]
