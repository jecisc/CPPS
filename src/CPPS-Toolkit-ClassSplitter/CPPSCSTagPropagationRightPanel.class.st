Class {
	#name : #CPPSCSTagPropagationRightPanel,
	#superclass : #CPPSAbstractRightPanel,
	#instVars : [
		'ratioSplitter',
		'querySplitter'
	],
	#category : #'CPPS-Toolkit-ClassSplitter'
}

{ #category : #'as yet unclassified' }
CPPSCSTagPropagationRightPanel >> TODO [

	self flag: #TODO
	"
	- Do not hardcode the black color
	- Add documentation
	- Check todos
	- Add translations everywhere
	"
]

{ #category : #hooks }
CPPSCSTagPropagationRightPanel >> children [

	^ { 
		  ratioSplitter.
		  querySplitter }
]

{ #category : #accessing }
CPPSCSTagPropagationRightPanel >> classSplitter [

	^ self owner
]

{ #category : #initialization }
CPPSCSTagPropagationRightPanel >> initialize [

	super initialize.
	ratioSplitter := CPPSCSRatioTagPropagationComponent owner: self.
	querySplitter := CPPSCSQueryTagPropagationComponent owner: self
]

{ #category : #rendering }
CPPSCSTagPropagationRightPanel >> renderContentOn: html [

	html div
		class: #'class-splitter_tag-propagation';
		style: 'width: 90%;';
		marginAuto;
		with:
			[ self visualization class canPropagateTags
				ifTrue:
					[ html render: ratioSplitter.
					self flag: #todo. "This should be in the CSS."
					3 timesRepeat: [ html break ].
					html render: querySplitter
					]
				ifFalse:
					[ html mdlAlert
						beWarning;
						with: (self
								 english: 'Usupported by this visualization'
								 french: 'Non supporté par cette visualisation')
					]
			]
]

{ #category : #accessing }
CPPSCSTagPropagationRightPanel >> visualization [

	^ self classSplitter currentVisualization
]
