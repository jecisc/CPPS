Class {
	#name : #CPPSBlock,
	#superclass : #CPPSBehaviouralEntity,
	#instVars : [
		'#parentBlock => FMMany type: #CPPSBehaviouralEntity opposite: #innerBlocks'
	],
	#category : #'CPPS-Entities-Entities'
}

{ #category : #meta }
CPPSBlock class >> annotation [

	<FMClass: #Block super: #CPPSBehaviouralEntity>
	<package: #'CPPS-Entities'>
	<generated>
	^self
]

{ #category : #display }
CPPSBlock class >> color [
	^ MDLColor tint: #purple code: #'300'
]

{ #category : #display }
CPPSBlock class >> initialToDisplay [
	^ 'B'
]

{ #category : #display }
CPPSBlock class >> kindAbbreviation [
	^ 'B'
]

{ #category : #display }
CPPSBlock class >> nameTranslations [
	^ Dictionary
		with: #english -> 'Block'
		with: #french -> 'Bloc'
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
	"Relation named: #parentBlock type: #CPPSBehaviouralEntity opposite: #innerBlocks"

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
