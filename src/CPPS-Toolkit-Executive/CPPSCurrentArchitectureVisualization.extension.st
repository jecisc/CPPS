Extension { #name : #CPPSCurrentArchitectureVisualization }

{ #category : #'*CPPS-Toolkit-Executive' }
CPPSCurrentArchitectureVisualization >> initializeFromExecutive: anExecutive [

	self
		model: anExecutive model;
		addInteraction: ((CPPSTagAction tag: anExecutive currentTag) withMenu: (anExecutive
						  translate: 'Tag with current tag'
						  french: 'Tagger avec le tag courant'))
]

{ #category : #'*CPPS-Toolkit-Executive' }
CPPSCurrentArchitectureVisualization class >> title [

	^ 'Native Technical Architecture' french: 'Architecture technique native'
]
