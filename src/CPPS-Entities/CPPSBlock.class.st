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

{ #category : #accessing }
CPPSBlock >> attributes [
	^ self accesses collectAsSet: #variable
]

{ #category : #accessing }
CPPSBlock >> belongsTo [
	^ self parentBlock
]

{ #category : #accessing }
CPPSBlock >> blocks [
	^ self innerBlocks
]

{ #category : #accessing }
CPPSBlock >> endLine [
	^ self sourceAnchor endLine
]

{ #category : #testing }
CPPSBlock >> isCPPSBlock [

	<generated>
	^ true
]

{ #category : #accessing }
CPPSBlock >> mooseModel [
	^ self privateState attributeAt: #mooseModel ifAbsent: [ parentBlock mooseModel ifNil: [ super mooseModel ] ]
]

{ #category : #accessing }
CPPSBlock >> name [
	^ String streamContents: [ :s | self printOn: s ]
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

{ #category : #printing }
CPPSBlock >> printOn: aStream [
	aStream
		nextPutAll: self class name;
		nextPut: $(;
		print: sourceAnchor startPos;
		nextPutAll: '@';
		print: sourceAnchor endPos;
		nextPut: $)
]

{ #category : #accessing }
CPPSBlock >> start [
	^ self sourceAnchor startPos
]

{ #category : #accessing }
CPPSBlock >> startLine [
	^ self sourceAnchor startLine
]

{ #category : #accessing }
CPPSBlock >> stop [
	^ self sourceAnchor endPos
]
