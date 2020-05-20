Class {
	#name : #CPPSBlock,
	#superclass : #CPPSBehavioralEntity,
	#instVars : [
		'#parentBlock => FMMany type: #CPPSBehavioralEntity opposite: #innerBlocks'
	],
	#category : #'CPPS-Entities-Entities'
}

{ #category : #meta }
CPPSBlock class >> annotation [

	<FMClass: #Block super: #CPPSBehavioralEntity>
	<package: #'CPPS-Entities'>
	<generated>
	^self
]

{ #category : #adding }
CPPSBlock >> addParentBlock: anObject [
	<generated>
	^ self parentBlock add: anObject
]

{ #category : #testing }
CPPSBlock >> isCPPSBlock [

	<generated>
	^ true
]

{ #category : #accessing }
CPPSBlock >> parentBlock [
	"Relation named: #parentBlock type: #CPPSBehavioralEntity opposite: #innerBlocks"

	<generated>
	<FMComment: '"Block" containing this block. belongsTo implementation'>
	<derived>
	^ parentBlock
]

{ #category : #accessing }
CPPSBlock >> parentBlock: anObject [

	<generated>
	parentBlock value: anObject
]
