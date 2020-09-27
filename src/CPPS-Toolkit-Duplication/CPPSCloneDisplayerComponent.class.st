Class {
	#name : #CPPSCloneDisplayerComponent,
	#superclass : #CPPSComponent,
	#instVars : [
		'clonesComponents',
		'selectedContainers',
		'graphCallback',
		'offset',
		'comparisonMode'
	],
	#category : #'CPPS-Toolkit-Duplication'
}

{ #category : #'instance creation' }
CPPSCloneDisplayerComponent class >> graphCallback: aBlock [

	^ self new
		  graphCallback: aBlock;
		  yourself
]

{ #category : #accessing }
CPPSCloneDisplayerComponent >> clonesComponents [

	^ clonesComponents
]

{ #category : #accessing }
CPPSCloneDisplayerComponent >> clonesComponents: anObject [

	clonesComponents := anObject
]

{ #category : #components }
CPPSCloneDisplayerComponent >> codeComponentFrom: clone [

	^ (PrismComponent new
		   id: clone mooseID;
		   sourceCode: clone entitySourceCode;
		   addStrategy: (PrismComponentStyleStrategy new
				    objects: { clone };
				    positionFunction: [ :o | { (o positionOfFirstCharacter to: o positionOfLastCharacter) } ];
				    style: [ :o | 'class="duplicated"' ];
				    miniMapColor: [ :object | MDLColor red ]);
		   language: self strategy languageClass)
		  withMinimap;
		  addDecoration: (CPPSDivDecoration htmlClass: 'code-container-panel__content');
		  addDecoration: (CPPSTitleDecoration
				   entitled: (self codeTitleFrom: clone)
				   tooltip: (clone fileAnchor fileName
						    copyReplaceAll: '::'
						    with: ' : '));
		  jsOnLoadHook: ('goToLine(' , clone startLine asString , ',minimapScrollableFor(document.getElementById("' , clone mooseID asString , '")).get(0));') js;
		  yourself
]

{ #category : #accessing }
CPPSCloneDisplayerComponent >> codeTitleFrom: aClone [

	^ String streamContents:
		  [ :stream | 
		  stream
			  nextPutAll: aClone name;
			  nextPutAll: ' (';
			  nextPutAll: (self
					   english: 'Duplicated from line '
					   french: 'Dupliqué depuis la ligne ');
			  nextPutAll: aClone startLine asString;
			  nextPutAll: (self
					   english: ' to '
					   french: ' à ');
			  nextPutAll: aClone endLine asString;
			  nextPut: $)
		  ]
]

{ #category : #accessing }
CPPSCloneDisplayerComponent >> comparisonMode [

	^ comparisonMode
]

{ #category : #accessing }
CPPSCloneDisplayerComponent >> comparisonMode: anObject [

	comparisonMode := anObject
]

{ #category : #components }
CPPSCloneDisplayerComponent >> currentFragmentCodeComponent [

	^ (PrismComponent new
		   sourceCode:
			   [ self selectedContainers
				   ifEmpty: [ '' ]
				   ifNotEmpty: [ :cs | cs anyOne codeText ]
			   ];
		   addStrategy: (PrismComponentLinkStrategy new
				    objects: {  };
				    positionFunction: [ :o |  ];
				    callback: [ :o |  ];
				    style: [ :o |  ]);
		   language: self strategy languageClass)
		  addDecoration: (CPPSDivDecoration htmlClass: 'code-container-panel__content');
		  addDecoration: (CPPSTitleDecoration entitled: 'Clone code (' , ([ self selectedContainers first codeText lineCount asString ]
					    on: SubscriptOutOfBounds
					    do: [ 'NA' ]) , ' lines)');
		  yourself
]

{ #category : #components }
CPPSCloneDisplayerComponent >> duplicationChart [

	^ (Chart2dData
		   xObjects: self selectedContainers
		   yObjects: (self selectedContainers collect: [ :clone | (100 / clone entity sourceText lineCount * clone length) rounded ]))
		  chartType: ChartBar;
		  keyDisplayBlock: #name;
		  dataSetsColors: { MDLColor orange };
		  title: (self
				   english: 'Diagram of the proportion of duplication caused by the selected clone by entity.'
				   french: 'Diagramme de la proportion de duplication causée par le clone selectionné par entité.');
		  singleValueTooltip: (self
				   english: '<key>: <value>% of duplication from this fragment.'
				   french: '<key>: <value>% de duplication à partir de ce fragment.');
		  yourself
]

{ #category : #accessing }
CPPSCloneDisplayerComponent >> graphCallback [

	^ graphCallback
]

{ #category : #accessing }
CPPSCloneDisplayerComponent >> graphCallback: anObject [

	graphCallback := anObject
]

{ #category : #initialization }
CPPSCloneDisplayerComponent >> initialize [

	super initialize.
	self clonesComponents: OrderedCollection new.
	self offset: 300.
	self comparisonMode: false
]

{ #category : #accessing }
CPPSCloneDisplayerComponent >> offset [

	^ offset
]

{ #category : #accessing }
CPPSCloneDisplayerComponent >> offset: aLinesNumber [

	offset := aLinesNumber
]

{ #category : #rendering }
CPPSCloneDisplayerComponent >> renderCodesOn: html [

	html div
		class: #'duplication-content__clones';
		with:
			[ self clonesComponents do:
					[ :comp | 
					self
						renderFragment: comp
						on: html
					]
			]
]

{ #category : #rendering }
CPPSCloneDisplayerComponent >> renderContentOn: html [

	self comparisonMode
		ifFalse: [ self renderManyClonesOn: html ]
		ifTrue: [ self renderCodesOn: html ]
]

{ #category : #rendering }
CPPSCloneDisplayerComponent >> renderFragment: comp on: html [

	html div
		class: #'code-container';
		with:
			[ html div
				class: #'code-container-panel';
				with: [ html render: comp ]
			]
]

{ #category : #rendering }
CPPSCloneDisplayerComponent >> renderManyClonesOn: html [

	html div
		class: #'duplication-content__visu-fragment';
		with:
			[ html script: 'Chart.defaults.global.omitXLabels = true;'.
			html render: (ChartJsComponent
						 data: self duplicationChart
						 callback: [ :value :entity | self graphCallback ifNotNil: [ :cb | cb value: entity ] ]).
			self
				renderFragment: self currentFragmentCodeComponent
				on: html
			]
]

{ #category : #accessing }
CPPSCloneDisplayerComponent >> selectedContainers [

	^ selectedContainers
]

{ #category : #accessing }
CPPSCloneDisplayerComponent >> selectedContainers: aCollection [

	selectedContainers := aCollection.
	self clonesComponents: ((aCollection size <= 2
			  ifTrue: [ aCollection ]
			  ifFalse: [ aCollection first: 2 ]) collect: [ :clone | self codeComponentFrom: clone ])
]
