Extension { #name : #FamixTag }

{ #category : #'*CPPS-Toolkit-QueryBrowser' }
FamixTag >> numberOfClientsForModel: aModel [

	^ (self
		   allEntitiesRecursivelyIn: aModel
		   flatCollect: #allClients) size
]

{ #category : #'*CPPS-Toolkit-QueryBrowser' }
FamixTag >> numberOfLinesOfCodeForModel: aModel [

	^ (self
		   allEntitiesRecursivelyIn: aModel
		   collect: #numberOfLinesOfCode)
		  ifEmpty: [ 0 ]
		  ifNotEmpty: #sum
]

{ #category : #'*CPPS-Toolkit-QueryBrowser' }
FamixTag >> numberOfProvidersForModel: aModel [

	^ (self
		   allEntitiesRecursivelyIn: aModel
		   flatCollect: #allProviders) size
]

{ #category : #'*CPPS-Toolkit-QueryBrowser' }
FamixTag >> visibilityIcon [

	^ self isHidden
		  ifTrue: [ #visibility_off ]
		  ifFalse: [ #visibility ]
]
