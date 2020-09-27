Extension { #name : #CPPSSystemOverviewVisualization }

{ #category : #'*CPPS-Toolkit-Executive' }
CPPSSystemOverviewVisualization >> initializeFromExecutive: anExecutive [

	self
		mapEntities: anExecutive entitiesToDraw;
		callback:
			[ :aNode | 
			anExecutive
				displayBrowserClass: CPPSCodeAnalyzer
				onEntity: aNode entity
			]
]

{ #category : #'*CPPS-Toolkit-Executive' }
CPPSSystemOverviewVisualization class >> title [

	^ 'System Complexity' french: 'Complexité du Système'
]
