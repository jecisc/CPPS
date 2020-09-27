"
Description
--------------------

I am a component to display entity properties as a table.
"
Class {
	#name : #CPPSPropertiesComponent,
	#superclass : #CPPSEntityCentricInfoComponent,
	#category : #'CPPS-Toolkit-CodeAnalyzer-RightPanels'
}

{ #category : #rendering }
CPPSPropertiesComponent >> renderContentOn: html [

	html mdlTabsPanel
		class: 'properties';
		class: 'infoComponent';
		style: self customStyle;
		with:
			[ html mdlTable
				class: 'mdl-table-compact';
				with:
					[ self renderTableHeaderOn: html.
					self entity ifNotNil: [ self renderTableBodyOn: html ]
					]
			]
]

{ #category : #rendering }
CPPSPropertiesComponent >> renderTableBodyOn: html [

	html tableBody:
		[ ((self entity mooseDescription allPrimitiveProperties select: [ :prop | prop type isPrimitive and: [ prop isMultivalued not ] ]) sort: #name ascending) do:
			[ :prop | 
			| value |

			value := [ self entity perform: prop implementingSelector ]
				         on: Error
				         do:
					         [ ('Error during the computation of ' , prop printString , ' for ' , self entity printString) record.
					         MooseUnavailableMetric
					         ].
			(value isExistingMetricFor: self entity) ifTrue:
				[ "In case it is the not existing metric value, we reject it."
				html tableRow:
					[ html mdlTableCell
						id: html nextId;
						with: (' ' join: (prop name piecesCutWhereCamelCase collect: #asLowercase)) capitalized.
					html mdlTooltip large
						for: html lastId;
						with: prop comment.
					html tableData: value
					]
				]
			]
		]
]

{ #category : #rendering }
CPPSPropertiesComponent >> renderTableHeaderOn: html [

	html tableHead:
		[ html tableRow:
			[ html mdlTableHeading: (self
					 english: 'Property'
					 french: 'Propriétés').
			html mdlTableHeading: (self
					 english: 'Value'
					 french: 'Valeur')
			]
		]
]
