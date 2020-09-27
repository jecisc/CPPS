"
Description
--------------------

I am a browser that help the user to localize each duplication code detected. I should be improved.
"
Class {
	#name : #CPPSDuplicationBrowser,
	#superclass : #CPPSAbstractBrowser,
	#instVars : [
		'cloneFragmentsSelection',
		'clonesListComponent',
		'containersComponent',
		'displayerComponent'
	],
	#category : #'CPPS-Toolkit-Duplication'
}

{ #category : #accessing }
CPPSDuplicationBrowser class >> browserName [

	^ 'Duplication Browser' french: 'Explorateur de duplication'
]

{ #category : #testing }
CPPSDuplicationBrowser class >> isReleventFor: selectionOrEntity [

	^ selectionOrEntity asCollection
		  ifNotEmpty: [ :coll | coll anyOne isReplicatedFragment ]
		  ifEmpty: [ false ]
]

{ #category : #accessing }
CPPSDuplicationBrowser class >> priority [

	^ 50
]

{ #category : #accessing }
CPPSDuplicationBrowser >> cloneFragmentsSelection [

	^ cloneFragmentsSelection
]

{ #category : #accessing }
CPPSDuplicationBrowser >> cloneFragmentsSelection: anObject [

	cloneFragmentsSelection := anObject.
	self clonesListComponent elements: self clones.
	self clones ifNotEmpty: [ self selectClone: self clones first ]
]

{ #category : #accessing }
CPPSDuplicationBrowser >> clones [

	^ self cloneFragmentsSelection ifNil: [ self model allReplicatedFragments ]
]

{ #category : #accessing }
CPPSDuplicationBrowser >> clonesListComponent [

	^ clonesListComponent
]

{ #category : #accessing }
CPPSDuplicationBrowser >> clonesListComponent: aCollection [

	clonesListComponent := aCollection
]

{ #category : #modes }
CPPSDuplicationBrowser >> comparisonMode [

	self displayerComponent comparisonMode: true
]

{ #category : #accessing }
CPPSDuplicationBrowser >> containersComponent [

	^ containersComponent
]

{ #category : #accessing }
CPPSDuplicationBrowser >> containersComponent: anObject [

	containersComponent := anObject
]

{ #category : #components }
CPPSDuplicationBrowser >> defaultClonesListComponent [

	^ (MDLNestedList elements: [ self clones ])
		  actionBlock: [ :clone | self selectClone: clone ];
		  format: #fragmentName;
		  helpBlock:
			  [ :clone :html | 
			  [ self
				  renderTooltipOf: clone
				  on: html
			  ]
			  ];
		  beCompact;
		  addDecoration: (CPPSTitleDecoration entitled:
					   [ :html | 
					   self hasSelection
						   ifFalse:
							   [ html text: (self
										    english: 'Clones'
										    french: 'Clones')
							   ]
						   ifTrue:
							   [ | id |

							   html text: (self
										    english: 'Selected Clones'
										    french: 'Clones sélectionnés').
							   html anchor
								   id: (id := html nextId);
								   callback: [ self cloneFragmentsSelection: nil ];
								   with: [ html mdlIcon: #playlist_add ].
							   html
								   mdlLargeTooltipFor: id
								   with: (self
										    english: 'Show all fragments'
										    french: 'Montrer tous les fragments')
							   ]
					   ]);
		  addDecoration: (CPPSDivDecoration htmlClass: 'duplicated');
		  yourself
]

{ #category : #components }
CPPSDuplicationBrowser >> defaultContainerComponent [

	^ (CPPSCloneContainerComponent
		   owner: self
		   actionBlock: [ :entities | self selectedContainers: entities ])
		  addDecoration: (CPPSDivDecoration htmlClass: 'containers');
		  yourself
]

{ #category : #components }
CPPSDuplicationBrowser >> defaultDisplayerComponent [

	^ CPPSCloneDisplayerComponent graphCallback: [ :entity | self containersComponent selectedContainers: (OrderedCollection with: entity) ]
]

{ #category : #accessing }
CPPSDuplicationBrowser >> displayerComponent [

	^ displayerComponent
]

{ #category : #accessing }
CPPSDuplicationBrowser >> displayerComponent: anObject [

	displayerComponent := anObject
]

{ #category : #modes }
CPPSDuplicationBrowser >> graphMode [

	self displayerComponent comparisonMode: false
]

{ #category : #testing }
CPPSDuplicationBrowser >> hasSelection [

	^ self cloneFragmentsSelection isNotNil
]

{ #category : #initialization }
CPPSDuplicationBrowser >> initialize [

	super initialize.
	self clonesListComponent: self defaultClonesListComponent.
	self containersComponent: self defaultContainerComponent.
	self displayerComponent: self defaultDisplayerComponent.
	self clones ifNotEmpty: [ self selectClone: self clones first ]
]

{ #category : #rendering }
CPPSDuplicationBrowser >> renderContentOn: html [

	html div
		class: #duplication;
		with:
			[ self clones
				ifEmpty:
					[ html div
						class: #message;
						class: #'text-center';
						with:
							[ html text: (self
										 english: 'There is no duplicated fragment in this application.'
										 french: 'Il n''y a pas de fragment dupliqué dans cette application.')
							]
					]
				ifNotEmpty:
					[ self renderSelectionOn: html.
					html div
						id: #'duplication-content';
						beGrowing;
						with: [ self renderDuplicationContentOn: html ]
					]
			]
]

{ #category : #rendering }
CPPSDuplicationBrowser >> renderDuplicationContentOn: html [

	html render: self displayerComponent
]

{ #category : #rendering }
CPPSDuplicationBrowser >> renderSelectionOn: html [

	html leftPanel:
		[ html
			render: self clonesListComponent;
			render: self containersComponent;
			leftPanelResizer
		]
]

{ #category : #rendering }
CPPSDuplicationBrowser >> renderTooltipOf: clone on: html [

	| string content englishText frenchText |

	string := '<table>
	<thead>
		<tr>
			<th>{1}</th>
			<th>{2}</th>
			<th>{3}</th>
			<th>{4}</th>
		</tr>
	</thead>
	<tbody>
		{5}
	</tbody>
</table>'.
	content := String streamContents:
		           [ :s | 
		           clone replicas do:
			           [ :member | 
			           s
				           nextPutAll: '<tr><td>';
				           nextPutAll: member fileAnchor fileName;
				           nextPutAll: '</td><td>';
				           nextPutAll: member entity name;
				           nextPutAll: '</td><td>';
				           print: member startLine;
				           nextPutAll: '</td><td>';
				           print: member endLine;
				           nextPutAll: '</td></tr>'
			           ]
		           ].
	englishText := { 
		               'File'.
		               'Entity'.
		               'From line'.
		               'To line'.
		               content }.
	frenchText := { 
		              'Fichier'.
		              'Entité'.
		              'De la ligne'.
		              'À la ligne'.
		              content }.
	html html: (self
			 english: (string format: englishText)
			 french: (string format: frenchText))
]

{ #category : #accessing }
CPPSDuplicationBrowser >> selectClone: aClonedFragment [

	self clonesListComponent selectedEntity: aClonedFragment.
	self containersComponent containers: aClonedFragment replicas
]

{ #category : #accessing }
CPPSDuplicationBrowser >> selectedContainers: aCollection [

	self displayerComponent selectedContainers: aCollection
]

{ #category : #selection }
CPPSDuplicationBrowser >> selection: aCollectionOfFragments [

	self cloneFragmentsSelection: aCollectionOfFragments
]
