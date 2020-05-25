Class {
	#name : #CPPSBehaviouralEntity,
	#superclass : #CPPSContainerEntity,
	#traits : 'FamixTInvocable + FamixTWithAccesses + FamixTWithInvocations + FamixTWithStatements',
	#classTraits : 'FamixTInvocable classTrait + FamixTWithAccesses classTrait + FamixTWithInvocations classTrait + FamixTWithStatements classTrait',
	#instVars : [
		'#innerBlocks => FMOne type: #CPPSBlock opposite: #parentBlock'
	],
	#category : #'CPPS-Entities-Entities'
}

{ #category : #meta }
CPPSBehaviouralEntity class >> annotation [

	<FMClass: #BehaviouralEntity super: #CPPSContainerEntity>
	<package: #'CPPS-Entities'>
	<generated>
	^self
]

{ #category : #accessing }
CPPSBehaviouralEntity >> innerBlocks [
	"Relation named: #innerBlocks type: #CPPSBlock opposite: #parentBlock"

	<generated>
	<FMComment: 'Blocks declared in this behavioural'>
	^ innerBlocks
]

{ #category : #accessing }
CPPSBehaviouralEntity >> innerBlocks: anObject [

	<generated>
	innerBlocks := anObject
]
