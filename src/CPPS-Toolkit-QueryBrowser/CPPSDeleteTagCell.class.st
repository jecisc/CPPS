Class {
	#name : #CPPSDeleteTagCell,
	#superclass : #CPPSAbstractEntityCell,
	#instVars : [
		'component'
	],
	#category : #'CPPS-Toolkit-QueryBrowser-TagManager'
}

{ #category : #'instance creation' }
CPPSDeleteTagCell class >> entity: anEntity from: aComponent [

	^ (self entity: anEntity)
		  component: aComponent;
		  yourself
]

{ #category : #comparing }
CPPSDeleteTagCell >> < aCell [

	^ true
]

{ #category : #accessing }
CPPSDeleteTagCell >> component [

	^ component
]

{ #category : #accessing }
CPPSDeleteTagCell >> component: anObject [

	component := anObject
]

{ #category : #rendering }
CPPSDeleteTagCell >> renderContentOn: html [

	html
		divClass: #'table-cell'
		with:
			[ html mdlIcon
				class: #remove;
				onClick: (html jQuery ajax
						 script:
							 [ :s | 
							 s
								 << ((html jQuery id: self component tableContenerId) load html:
											  [ :r | 
											  self entity removeTag: self component tag.
											  self component renderTableOn: r
											  ]);
								 << (self component jsUpdateRightPanelOn: html)
							 ];
						 onComplete: 'componentHandler.upgradeDom();');
				with: #clear
			]
]
