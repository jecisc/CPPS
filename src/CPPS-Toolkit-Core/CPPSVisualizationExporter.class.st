Class {
	#name : #CPPSVisualizationExporter,
	#superclass : #CPPSComponent,
	#instVars : [
		'visu'
	],
	#category : #'CPPS-Toolkit-Core-Components'
}

{ #category : #adding }
CPPSVisualizationExporter class >> addCSVExportFrom: aTLvisu on: html [

	| interaction |

	interaction := TLCustomAction new
		               actionBlock:
			               [ :drawable | 
			               drawable isNode and:
					               [ drawable isComposite and:
							               [ drawable childrenNodes
								               ifEmpty: [ true ]
								               ifNotEmpty: [ drawable childrenNodes anySatisfy: [ :child | child isVisible not ] ]
							               ]
					               ]
			               ];
		               onExternalTrigger.
	html button
		onClick: (interaction externalTriggerForVisuId: aTLvisu id);
		with: 'Export as CSV'.
	^ interaction
]

{ #category : #export }
CPPSVisualizationExporter >> export [

	self requestContext respond:
		[ :response | 
		response
			contentType: (WAMimeType
					 main: 'text'
					 sub: 'json');
			document: (String streamContents:
						 [ :stream | 
						 stream nextPutAll: '{ "content":"'.
						 self exportVisualizationOn: stream.
						 stream
							 nextPutAll: '",';
							 lf;
							 nextPutAll: '"title": "';
							 nextPutAll: 'export';
							 nextPutAll: self visu title;
							 space;
							 nextPutAll: DateAndTime now asReadableFormat;
							 nextPutAll: '.csv"}'
						 ]);
			contents
		]
]

{ #category : #export }
CPPSVisualizationExporter >> exportVisualizationOn: aStream [

	self
		writeLine: { #level. #id. #name. #outgoingId }
		on: aStream.
	self visu obtain recursively visibles nodes do:
		[ :each | 
		self
			writeLine: ((OrderedCollection with: (self getLevelOfNode: each))
					 add: each entity mooseID;
					 add: each entity mooseName;
					 add: (#, join: (each outgoingAdjacentNodes collect: [ :node | node entity mooseID ]));
					 yourself)
			on: aStream
		]
]

{ #category : #export }
CPPSVisualizationExporter >> getLevelOfNode: node [

	| group index |

	index := 0.
	group := node.
	[ index = 0 ] whileTrue:
		[ group := group parent.
		index := self visu subGroups indexOf: group
		].
	^ index
]

{ #category : #rendering }
CPPSVisualizationExporter >> renderContentOn: html [

	html mdlButton
		class: 'export-button';
		onClick: (html jQuery ajax
				 callback: [ self export ];
				 onComplete: 'args= JSON.parse(arguments[0].responseText);
		saveAs(
        new Blob([args.content]
        , {type: "text/plain;charset=" + document.characterSet})
        , args.title + ".json"
    );');
		with:
			[ html text: 'CSV'.
			html mdlIcon with: #file_download
			]
]

{ #category : #accessing }
CPPSVisualizationExporter >> visu [

	^ visu
]

{ #category : #accessing }
CPPSVisualizationExporter >> visu: anObject [

	visu := anObject
]

{ #category : #export }
CPPSVisualizationExporter >> writeLine: aCollectionOfStrings on: aStream [

	aCollectionOfStrings
		do: [ :each | aStream nextPutAll: each ]
		separatedBy: [ aStream nextPut: $; ].
	aStream lf
]
