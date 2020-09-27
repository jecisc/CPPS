"
Description
----------------

I am a component that should allow the user to export the entities he selected as CSV. He should be able to select what he can export.

/!\ AS I AM NOW I CANNOT  BE USED BECAUSE I AM BROKEN. WE NEED TO FIX ME ONE DAY. /!\
 
Internal Representation and Key Implementation Points.
---------------

    Instance Variables
	selectedQueries:		<aCollection>

"
Class {
	#name : #CPPSCSVExportComponent,
	#superclass : #CPPSComponent,
	#traits : 'CPPSTQueryBrowserComponent',
	#classTraits : 'CPPSTQueryBrowserComponent classTrait',
	#instVars : [
		'selectedQueries'
	],
	#category : #'CPPS-Toolkit-QueryBrowser-Core'
}

{ #category : #export }
CPPSCSVExportComponent >> export [

	self requestContext respond:
		[ :response | 
		| content |

		content := FQCSVExport
			           exportQueryBrowserResults: self selectedEntities
			           withProperties: selectedQueries.
		self selectedQueries removeAll.
		response
			contentType: (WAMimeType
					 main: 'text'
					 sub: 'csv');
			document: content;
			contents;
			attachmentWithFileName: 'exportQuery ' , DateAndTime now asReadableFormat , '.csv'
		]
]

{ #category : #initialization }
CPPSCSVExportComponent >> initialize [

	super initialize.
	self resetSelectedQueries
]

{ #category : #rendering }
CPPSCSVExportComponent >> renderButtonsOn: html [

	html div
		class: 'button-bar';
		with:
			[ html mdlSubmitButton
				callback: [ self export ];
				with: (self
						 english: 'Export'
						 french: 'Exporter').
			html space.
			html mdlButton
				bePush;
				onClick: (self owner
						 refreshRightPanelDoing: [ self answer ]
						 on: html);
				with: (self
						 english: 'Cancel'
						 french: 'Annuler')
			]
]

{ #category : #rendering }
CPPSCSVExportComponent >> renderCheckboxFor: queryFilter on: html [

	html mdlCell:
		[ html mdlCheckboxContainer
			for: html nextId;
			with:
				[ html mdlCheckbox
					id: html lastId;
					callback: [ :confirmation | confirmation ifTrue: [ self selectedQueries add: queryFilter ] ];
					value: false.
				html mdlCheckboxLabel: queryFilter displayName
				]
		]
]

{ #category : #rendering }
CPPSCSVExportComponent >> renderContentOn: html [

	html form
		style: 'width: 90%;margin: auto;max-width:1250px;';
		with:
			[ html headerContainer:
					[ html headline: (self
								 english: 'CSV Export - Filters'
								 french: 'Export CSV - Filtres')
					].
			html mdlGrid:
					[ (FQNumericQuery availablePropertiesFor: self queryResult)
						collect:
							[ :property | 
							FQNumericQuery
								property: property
								description: property
							]
						thenDo:
							[ :queryFilter | 
							self
								renderCheckboxFor: queryFilter
								on: html
							]
					].
			self renderButtonsOn: html
			]
]

{ #category : #initialization }
CPPSCSVExportComponent >> resetSelectedQueries [

	selectedQueries := OrderedCollection new
]

{ #category : #accessing }
CPPSCSVExportComponent >> selectedQueries [

	^ selectedQueries
]

{ #category : #accessing }
CPPSCSVExportComponent >> selectedQueries: anObject [

	selectedQueries := anObject
]
