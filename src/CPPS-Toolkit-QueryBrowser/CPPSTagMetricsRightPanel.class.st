Class {
	#name : #CPPSTagMetricsRightPanel,
	#superclass : #CPPSAbstractRightPanel,
	#category : #'CPPS-Toolkit-QueryBrowser-TagManager'
}

{ #category : #rendering }
CPPSTagMetricsRightPanel >> renderContentOn: html [

	self selectedTag
		ifNil: [ self renderEmptyScreenOn: html ]
		ifNotNil:
			[ :tag | 
			html mdlTable
				class: 'mdl-table-compact';
				with:
					[ self renderTableHeaderOn: html.
					self
						renderTableBodyOn: html
						forTag: tag
					]
			]
]

{ #category : #rendering }
CPPSTagMetricsRightPanel >> renderEmptyScreenOn: html [

	html div
		beCentered;
		with:
			[ html mdlAlert
				beInfo;
				with: (self
						 english: 'No tag selected'
						 french: 'Pas de tag sélectionné')
			]
]

{ #category : #rendering }
CPPSTagMetricsRightPanel >> renderTableBodyOn: html forTag: aTag [

	html tableBody:
		[ html tableRow:
			[ html mdlTableCell: (self
					 english: 'Number of lines of code'
					 french: 'Nombre de lignes de code').
			html tableData: (aTag numberOfLinesOfCodeForModel: self model)
			].
		html tableRow:
			[ html mdlTableCell: (self
					 english: 'Number of incoming Links'
					 french: 'Nombre de liens entrants').
			html tableData: (aTag numberOfClientsForModel: self model)
			].
		html tableRow:
			[ html mdlTableCell: (self
					 english: 'Number of outgoing links'
					 french: 'Nombre de liens sortants').
			html tableData: (aTag numberOfProvidersForModel: self model)
			]
		]
]

{ #category : #rendering }
CPPSTagMetricsRightPanel >> renderTableHeaderOn: html [

	html tableHead:
		[ html tableRow:
			[ html mdlTableHeading: (self
					 english: 'Metric'
					 french: 'Métrique').
			html mdlTableHeading: (self
					 english: 'Value'
					 french: 'Valeur')
			]
		]
]

{ #category : #accessing }
CPPSTagMetricsRightPanel >> selectedTag [

	^ self owner selectedTag
]
