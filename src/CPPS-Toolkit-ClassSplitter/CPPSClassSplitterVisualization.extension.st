Extension { #name : #CPPSClassSplitterVisualization }

{ #category : #'*CPPS-Toolkit-ClassSplitter' }
CPPSClassSplitterVisualization class >> canPropagateTags [

	^ false
]

{ #category : #'*CPPS-Toolkit-ClassSplitter' }
CPPSClassSplitterVisualization class >> priority [

	^ self subclassResponsibility
]

{ #category : #'*CPPS-Toolkit-ClassSplitter' }
CPPSClassSplitterVisualization class >> title [

	^ self subclassResponsibility
]

{ #category : #'*CPPS-Toolkit-ClassSplitter' }
CPPSClassSplitterVisualization class >> visualizations [

	^ (self allSubclasses reject: #isAbstract) sorted: #priority descending
]
