Extension { #name : #CPPSTreeExplorerDirectionStrategy }

{ #category : #'*CPPS-Toolkit-Executive' }
CPPSTreeExplorerDirectionStrategy class >> defaultStrategy [

	^ self strategies first
]

{ #category : #'*CPPS-Toolkit-Executive' }
CPPSTreeExplorerDirectionStrategy class >> label [

	^ self subclassResponsibility
]

{ #category : #'*CPPS-Toolkit-Executive' }
CPPSTreeExplorerDirectionStrategy class >> priority [

	^ self subclassResponsibility
]

{ #category : #'*CPPS-Toolkit-Executive' }
CPPSTreeExplorerDirectionStrategy class >> strategies [

	^ (self allSubclasses reject: #isAbstract) sorted: #priority descending
]
