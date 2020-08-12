Extension { #name : #MooseEntity }

{ #category : #'*CPPS-Entities' }
MooseEntity >> hasPriorityOn: anEntity [
	"I most of the UI we display elements. This methods should return true if the receiver needs to be desplayed before the argument by default."
	
	"In case the two are of the same class, the order is determined by the name."
	self priority = anEntity priority ifTrue: [ ^ self name < anEntity name ].
	
	^ self priority > anEntity priority
]

{ #category : #'*CPPS-Entities' }
MooseEntity class >> multilanguageDisplayName [
	^ self englishName french: self frenchName
]

{ #category : #'*CPPS-Entities' }
MooseEntity >> multilanguageDisplayName [
	^ self class multilanguageDisplayName
]

{ #category : #'*CPPS-Entities' }
MooseEntity >> optionalDisplayInfo [
	"Return optional infos for display. Can be for example the visibility of an entity.
	Useful to display info to the users."

	^ nil
]

{ #category : #'*CPPS-Entities' }
MooseEntity >> priority [
	^ self class priority
]

{ #category : #'*CPPS-Entities' }
MooseEntity class >> priority [
	"Sometimes we want to sort entities and it is not easy to find a generic way of sorting that works fine with the workflow of our clients. For a class, the higher is the priority, the sooner it will be displayed."
	
	^ 200
]

{ #category : #'*CPPS-Entities' }
MooseEntity >> tooltipIn: aSymbol [
	^ String
		streamContents: [ :s | 
			s
				nextPut: $[;
				nextPutAll: (self multilanguageDisplayName into: aSymbol).
			self optionalDisplayInfo
				ifNotNil: [ :info | 
					s
						nextPutAll: ' | ';
						nextPutAll: info ].
			s
				nextPut: $];
				space;
				nextPutAll: ((self mooseName copyReplaceAll: '::' with: ' :: ') copyReplaceAll: '.' with: ' :: ') ]
]

{ #category : #'*CPPS-Entities' }
MooseEntity >> tooltipNameIn: aSymbol forModel: aMooseModel [
	^ self tooltipIn: aSymbol
]
