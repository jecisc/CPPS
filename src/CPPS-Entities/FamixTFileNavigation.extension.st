Extension { #name : #FamixTFileNavigation }

{ #category : #'*CPPS-Entities' }
FamixTFileNavigation >> endsBefore: aFileAnchor [
	(self endLine isNil or: [ aFileAnchor endLine isNil ]) ifTrue: [ ^ false ].

	(self endColumn isNil or: [ aFileAnchor endColumn isNil ]) ifTrue: [ ^ self endLine <= aFileAnchor endLine ].

	^ self endLine < aFileAnchor endLine or: [ self endLine = aFileAnchor endLine and: [ self endColumn <= aFileAnchor endColumn ] ]
]

{ #category : #'*CPPS-Entities' }
FamixTFileNavigation >> isWithin: aFileAnchor [
	"test whether aSourceAnchor is contained within receiver"

	^ self fileName = aFileAnchor fileName and: [ (self startsAfter: aFileAnchor) and: [ self endsBefore: aFileAnchor ] ]
]

{ #category : #'*CPPS-Entities' }
FamixTFileNavigation >> startsAfter: aFileAnchor [
	 ^ aFileAnchor startBeforeFileAnchor: self
]
