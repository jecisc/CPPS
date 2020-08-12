Extension { #name : #FamixTag }

{ #category : #'*CPPS-Entities' }
FamixTag class >> priority [
	^ 10
]

{ #category : #'*CPPS-Entities' }
FamixTag >> tooltipNameIn: aSymbol forModel: aModel [
	^ String
		streamContents: [ :s | 
			s
				nextPutAll: (super tooltipNameIn: aSymbol forModel: aModel);
				nextPutAll: '<br/><br/>'.
			((self taggedEntitiesInModel: aModel) groupedBy: #class)
				keysAndValuesDo: [ :type :entities | 
					s
						nextPutAll: (type multilanguageDisplayName into: aSymbol);
						nextPutAll: '<br/><br/>'.
					entities
						do: [ :ent | 
							s
								nextPutAll: '- ';
								nextPutAll: ent name ]
						separatedBy: [ s nextPutAll: '<br/>' ].
					s nextPutAll: '<br/><br/>' ] ]
]
