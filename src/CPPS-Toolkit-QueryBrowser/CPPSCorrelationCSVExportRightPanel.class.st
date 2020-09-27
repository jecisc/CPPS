Class {
	#name : #CPPSCorrelationCSVExportRightPanel,
	#superclass : #CPPSCorrelationRightPanel,
	#category : #'CPPS-Toolkit-QueryBrowser-Correlation'
}

{ #category : #export }
CPPSCorrelationCSVExportRightPanel >> export [

	self requestContext respond:
		[ :response | 
		response
			contentType: (WAMimeType
					 main: 'text'
					 sub: 'csv');
			document: (FQCSVExport
					 exportCorrelation: self selectedCorrelation
					 forModel: self model);
			contents;
			attachmentWithFileName: 'correlation ' , self selectedCorrelation name , ' - ' , DateAndTime now asReadableFormat , '.csv'
		]
]

{ #category : #rendering }
CPPSCorrelationCSVExportRightPanel >> renderContentOn: html [

	self owner
		render:
			[ html form:
				[ html formContainer: [ html text: 'Export correlation content to CSV file.' ].
				html formContainer:
					[ html mdlSubmitButton
						callback: [ self export ];
						with: (self
								 english: 'Export'
								 french: 'Exporter')
					]
				]
			]
		ifCorrelationPresentOn: html
]
