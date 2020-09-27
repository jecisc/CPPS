Extension { #name : #CPPSModel }

{ #category : #'*CPPS-Toolkit-Core' }
CPPSModel class >> browserStrategy [

	^ CPPBrowserStrategy
]

{ #category : #'*CPPS-Toolkit-Core' }
CPPSModel >> cachesToBuild [

	^ super cachesToBuild
		  add: 'number of lines of codes for classes' -> [ self allModelClasses do: #numberOfLinesOfCode ];
		  add: 'all model functions' -> [ self allModelFunctions ];
		  yourself
]
