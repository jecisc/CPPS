Class {
	#name : #CPPSEntityNameCell,
	#superclass : #CPPSAbstractEntityCell,
	#category : #'CPPS-Toolkit-QueryBrowser-TagManager'
}

{ #category : #comparing }
CPPSEntityNameCell >> < aCell [

	^ self entity name < aCell entity name
]

{ #category : #rendering }
CPPSEntityNameCell >> printOn: aStream [

	super printOn: aStream.
	self entity name ifNotNil:
		[ :n | 
		aStream
			<< $[;
			<< n;
			<< $]
		]
]

{ #category : #rendering }
CPPSEntityNameCell >> renderContentOn: html [

	html
		divClass: #'table-cell'
		with:
			[ html anchor
				callback:
					[ self rootComponent
						displayBrowserClass: CPPSCodeAnalyzer
						onEntity: self entity
					];
				with: self entity name
			]
]
