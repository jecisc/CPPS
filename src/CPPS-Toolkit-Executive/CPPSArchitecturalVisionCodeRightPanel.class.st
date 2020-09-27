Class {
	#name : #CPPSArchitecturalVisionCodeRightPanel,
	#superclass : #CPPSAbstractRightPanel,
	#instVars : [
		'entity'
	],
	#category : #'CPPS-Toolkit-Executive'
}

{ #category : #rendering }
CPPSArchitecturalVisionCodeRightPanel >> codeDisplayer [

	^ PrismComponent new
		  sourceCode: (self entity sourceAnchor
				   ifNil: [ '' ]
				   ifNotNil: #sourceText);
		  language: self strategy languageClass;
		  withMDLSearchBar;
		  withMinimap;
		  yourself
]

{ #category : #accessing }
CPPSArchitecturalVisionCodeRightPanel >> entity [

	^ entity
]

{ #category : #accessing }
CPPSArchitecturalVisionCodeRightPanel >> entity: anObject [

	entity := anObject
]

{ #category : #rendering }
CPPSArchitecturalVisionCodeRightPanel >> renderContentOn: html [

	self entity
		ifNil:
			[ html div
				marginAuto;
				style: 'width: 80%;';
				with:
					[ html mdlAlert
						beInfo;
						with: (self
								 english: 'Select an entity to display via a right click on a visualization node'
								 french: 'Sélectionnez une entité à affichier via un clique droit sur un nœud de la visualisation')
					]
			]
		ifNotNil: [ html render: self codeDisplayer ]
]
