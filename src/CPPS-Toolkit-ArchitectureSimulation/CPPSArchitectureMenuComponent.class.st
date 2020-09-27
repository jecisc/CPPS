Class {
	#name : #CPPSArchitectureMenuComponent,
	#superclass : #CPPSComponent,
	#instVars : [
		'owner'
	],
	#category : #'CPPS-Toolkit-ArchitectureSimulation'
}

{ #category : #'instance creation' }
CPPSArchitectureMenuComponent class >> owner: aComponent [

	^ self new
		  owner: aComponent;
		  yourself
]

{ #category : #action }
CPPSArchitectureMenuComponent >> enableNewArchitectureCreation [

	self owner enableNewArchitectureCreation
]

{ #category : #accessing }
CPPSArchitectureMenuComponent >> owner [

	^ owner
]

{ #category : #accessing }
CPPSArchitectureMenuComponent >> owner: anObject [

	owner := anObject
]

{ #category : #rendering }
CPPSArchitectureMenuComponent >> renderArchitectureMenuForPosition: aPosition version: aVersion architecture: anArchitecture on: html [

	html div
		class: #'architecture-menu__selection-item';
		with:
			[ html form:
					[ html
						render: ((MDLSelectWidget
								  possibilities: self architectures
								  inputLabel: 'Architecture' , aPosition asString
								  labelBlock: #name
								  callback:
									  [ :architecture | 
									  self owner
										  defineArchitecture: architecture
										  forPosition: aPosition
									  ]
								  selectedObject: anArchitecture)
								 standardSorting;
								 beAutoSubmit;
								 yourself);
						space;
						render: ((MDLSelectWidget
								  possibilities: (self versions sort: [ :vers1 :vers2 | vers1 date < vers2 date ])
								  inputLabel: 'Version'
								  labelBlock: #separateDateAndTime
								  callback:
									  [ :version | 
									  self owner
										  defineVersion: version
										  forPosition: aPosition
									  ]
								  selectedObject: aVersion)
								 standardSorting;
								 beAutoSubmit;
								 yourself)
					].
			html space.
			self
				renderEditFor: anArchitecture
				on: html.
			self
				renderDeleteFor: anArchitecture
				on: html
			]
]

{ #category : #rendering }
CPPSArchitectureMenuComponent >> renderContentOn: html [

	html div
		class: #'architecture-menu';
		shadow: 2;
		with:
			[ self owner architecturesWithVersion doWithIndex:
					[ :anArchitectureWithVersion :i | 
					self
						renderArchitectureMenuForPosition: i
						version: anArchitectureWithVersion version
						architecture: anArchitectureWithVersion architecture
						on: html
					].
			html div
				class: #'architecture-menu__right';
				with:
					[ self
						renderNewArchitectureButton: html;
						renderModeSelector: html
					]
			]
]

{ #category : #rendering }
CPPSArchitectureMenuComponent >> renderDeleteFor: anArchitecture on: html [

	| idButtonOpen idButtonClose |

	html mdlIcon
		id: (idButtonOpen := html nextId);
		class: #delete;
		with: [ html mdlIcon: #delete ].
	html mdlDialog
		openButtonId: idButtonOpen;
		closeButtonId: (idButtonClose := html nextId);
		with:
			[ html mdlDialogTitle: (self
						 english: 'Delete Architecture'
						 french: 'Supprimez l''architecture').
			html mdlDialogContent:
					[ html text: (self
								 english: 'Are you sure to delete the architecture?'
								 french: 'Êtes-vous sûr de vouloir supprimer l''architecture ?')
					].
			html mdlDialogActions:
					[ html mdlButton
						id: idButtonClose;
						with: (self
								 english: 'Cancel'
								 french: 'Annuler').
					html mdlMajorAnchorButton
						callback:
							[ self project removeArchitecture: anArchitecture.
							self owner defineDefaultArchitectures.
							self owner clearVisus.
							self rootComponent browsersInstances: Dictionary new
							];
						class: #deleteButton;
						with: (self
								 english: 'Delete'
								 french: 'Supprimer')
					]
			]
]

{ #category : #rendering }
CPPSArchitectureMenuComponent >> renderEditFor: anArchitecture on: html [

	| idButtonOpen idButtonClose |

	html mdlIcon
		id: (idButtonOpen := html nextId);
		class: #defaultIconColor;
		with: [ html mdlIcon: #edit ].
	html mdlDialog
		openButtonId: idButtonOpen;
		closeButtonId: (idButtonClose := html nextId);
		with:
			[ html mdlDialogTitle: (self
						 english: 'Edit Architecture'
						 french: 'Éditez l''architecture').
			html mdlDialogContent:
					[ html form:
							[ html render: ((MDLTextFieldWidget
										  labeled: (self
												   english: 'Architecture Name'
												   french: 'Nom de l''architecture')
										  callback: [ :name | anArchitecture name: name ]
										  floatingLabel: true)
										 value: anArchitecture name;
										 yourself).
							html mdlSubmitButton: (self
									 english: 'Edit'
									 french: 'Éditer')
							]
					].
			html mdlDialogActions:
				[ html mdlButton
					id: idButtonClose;
					with: (self
							 english: 'Cancel'
							 french: 'Annuler')
				]
			]
]

{ #category : #rendering }
CPPSArchitectureMenuComponent >> renderModeSelector: html [

	"the mode selector is only rendered when two versions or two architectures are available"

	(self owner architectures size >= 2 or: [ self owner versions size >= 2 ]) ifFalse: [ ^ self ].
	html div
		class: #'architecture-menu__mode';
		with:
			[ html form:
					[ html
						render: (MDLSelectWidget
								 possibilities: self owner class possibleStates
								 inputLabel: 'Select mode'
								 labelBlock: [ :browserState | browserState label capitalized ]
								 callback: [ :state | self owner browserState: state ]
								 selectedObject: self owner browserState
								 tooltip:
									 [ :r | 
									 [ r
										 text: 'The mode of this browser influence the visualizations. ';
										 break;
										 break.
									 self owner class possibleStates do:
										 [ :state | 
										 r
											 big: state label capitalized;
											 break;
											 text: state description;
											 break;
											 break
										 ]
									 ]
									 ]) beAutoSubmit;
						yourself
					]
			]
]

{ #category : #rendering }
CPPSArchitectureMenuComponent >> renderNewArchitectureButton: html [

	| id |

	html anchor
		callback: [ self enableNewArchitectureCreation ];
		with:
			[ html mdlIcon
				id: (id := html nextId);
				class: #add;
				with: #add
			].
	html
		mdlLargeTooltipFor: id
		with: (self
				 english: 'Create new architecture'
				 french: 'Créer une nouvelle architecture')
]

{ #category : #accessing }
CPPSArchitectureMenuComponent >> versions [

	^ self owner versions
]
