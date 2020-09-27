Extension { #name : #CPPSBrowserStrategy }

{ #category : #'*CPPS-Toolkit-CodeAnalyzer' }
CPPSBrowserStrategy class >> commonFilters [

	^ self subclassResponsibility
]

{ #category : #'*CPPS-Toolkit-CodeAnalyzer' }
CPPSBrowserStrategy class >> defaultCommonFilters [

	^ OrderedCollection new
		  add: ((CPPSRestrictifFilter named: ('Statically Dead' french: 'Statiquement mort'))
				   booleanBlock: [ :e | e isDead ];
				   yourself);
		  add: ((CPPSRestrictifFilter named: ('Contains duplication' french: 'Contenant duplication'))
				   booleanBlock: [ :e | e containsReplicas ];
				   yourself);
		  yourself
]
