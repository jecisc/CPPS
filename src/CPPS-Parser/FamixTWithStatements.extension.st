Extension { #name : #FamixTWithStatements }

{ #category : #'*CPPS-Parser' }
FamixTWithStatements >> blocks [
	| result |
	result := self propertyNamed: #blocks ifAbsentPut: [ self computesBlocks ].
	^ result isPetitFailure
		ifFalse: [ result ]
		ifTrue: [ {} ]
]

{ #category : #'*CPPS-Parser' }
FamixTWithStatements >> computesBlocks [
	| res |
	self hasSourceAnchor ifFalse: [ ^ {} ].
	
	res := OrderedCollection new.
	self sourceAnchor allSourceAnchors
		select: [ :e | (e fileReference extension includes: $c) and: [ e sourceText isNotEmpty ] ]
		thenDo: [ :sa | 
			res
				addAll:
					(CPPSConditionalsParser new
						method: self;
						sourceAnchor: sa;
						parse) ].
	^ res
]
