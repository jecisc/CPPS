Class {
	#name : #CPPSTagSelectionPanel,
	#superclass : #CPPSAbstractRightPanel,
	#instVars : [
		'tagListComponent'
	],
	#category : #'CPPS-Toolkit-ArchitectureSimulation'
}

{ #category : #hooks }
CPPSTagSelectionPanel >> children [

	^ Array with: self tagListComponent
]

{ #category : #rendering }
CPPSTagSelectionPanel >> renderContentOn: html [

	html headerContainer:
		[ html headline: (self
				 english: 'Select a tag to highlight'
				 french: 'Selectionner un tag à détecter')
		].
	html render: self tagListComponent
]

{ #category : #accessing }
CPPSTagSelectionPanel >> selectedTag [

	^ self tagListComponent selectedTag
]

{ #category : #accessing }
CPPSTagSelectionPanel >> selectedTag: aTag [

	self owner selectedTag: aTag
]

{ #category : #accessing }
CPPSTagSelectionPanel >> tagListComponent [

	^ tagListComponent ifNil: [ tagListComponent := CPPSSelectTagComponent owner: self ]
]
