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

{ #category : #initialization }
CPPSBlock >> getMyLocalsFrom: aCollection [
	"from aCollection of entities (or associations) with FileAnchors,
	 return those that are in the scope of receiver"

	^ aCollection select: [ :each | each sourceAnchor isNotNil and: [ each sourceAnchor isWithin: self sourceAnchor ] ]
]

{ #category : #testing }
CPPSBlock >> isCPPSBlock [

	<generated>
	^ true
]

{ #category : #initialization }
CPPSBlock >> localizeDefsAndRefs [
	(parentBlock isNotNil and: [ sourceAnchor isNotNil ]) ifFalse: [ ^ self ].
	self outgoingInvocations: (self getMyLocalsFrom: parentBlock outgoingInvocations).
	self accesses: (self getMyLocalsFrom: parentBlock accesses)
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
CPPSBlock >> parentBehavioural: anObject [
	parentBlock := anObject.
	self localizeDefsAndRefs
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

{ #category : #testing }
CPPSBlock >> shouldBeDisplayedBefore: anEntity [
	^ anEntity isCPPSBlock
		ifTrue: [ self start < anEntity start ]
		ifFalse: [ (anEntity shouldBeDisplayedBefore: self) not ]
]

{ #category : #accessing }
CPPSBlock >> sourceAnchor: aSourceAnchor [
	super sourceAnchor: aSourceAnchor.
	self localizeDefsAndRefs 
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
