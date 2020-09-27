"
Description
--------------------

I am the browser to manipulate architectures. I also allow to manage the relation with the tags
"
Class {
	#name : #CPPSArchitectureBrowser,
	#superclass : #CPPSAbstractBrowser,
	#traits : 'TRightTabsPanelBrowser',
	#classTraits : 'TRightTabsPanelBrowser classTrait',
	#instVars : [
		'architecturesWithVersion',
		'createNewArchitecture',
		'menuComponent',
		'visus',
		'browserState',
		'rightPanel',
		'toolbar'
	],
	#classInstVars : [
		'possibleStates'
	],
	#category : #'CPPS-Toolkit-ArchitectureSimulation'
}

{ #category : #accessing }
CPPSArchitectureBrowser class >> browserName [

	^ 'Architecture simulator' french: 'Simulateur d''Architectures'
]

{ #category : #testing }
CPPSArchitectureBrowser class >> isReleventFor: selectionOrEntity [

	^ selectionOrEntity isCollection
		  ifTrue: [ false ]
		  ifFalse: [ selectionOrEntity isMooseEntity and: [ selectionOrEntity isArchitecturalElement ] ]
]

{ #category : #accessing }
CPPSArchitectureBrowser class >> possibleStates [

	^ possibleStates ifNil:
		  [ possibleStates := { 
			                    (CPPSArchitectureBrowserState
				                     named: 'simple'
				                     description: 'I am a simple mode to dig into an unique architecture.'
				                     initializationBlock:
					                     [ :browser | 
					                     browser unfoldRightPanel.
					                     browser architecturesWithVersion first: 1
					                     ]
				                     initializationVisusBlock: [ :visus :browser | visus do: [ :visu | browser setBorderForTagsIn: visu ] ]).
			                    (CPPSArchitectureBrowserState
				                     named: 'distribution'
				                     description: 'I am a comparison mode allowing to see the repartition of elements between two architectures.'
				                     initializationBlock:
					                     [ :browser | 
					                     browser foldRightPanel.
					                     browser defaultArchitecturesForComparisonMode
					                     ]
				                     initializationVisusBlock: [ :visus :browser | visus do: [ :visu | browser setBorderForTagsIn: visu ] ]).
			                    (CPPSArchitectureBrowserState
				                     named: 'evolution'
				                     description: 'I am a comparison mode allowing to see the impact of evolution between two versions.'
				                     initializationBlock:
					                     [ :browser | 
					                     browser foldRightPanel.
					                     browser defaultArchitecturesForComparisonMode
					                     ]
				                     initializationVisusBlock:
					                     [ :visus :browser | 
					                     visus size > 1 ifTrue:
						                     [ browser
							                     addEvolutionStyleWith: visus first
							                     to: visus second
						                     ]
					                     ]) }
		  ]
]

{ #category : #accessing }
CPPSArchitectureBrowser class >> priority [

	^ 20
]

{ #category : #accessing }
CPPSArchitectureBrowser class >> resetStates [

	<script>
	possibleStates := nil
]

{ #category : #architecture }
CPPSArchitectureBrowser >> addEvolutionStyleWith: visu to: evolvedVisu [

	| changes |

	changes := CPPSArchitectureDiff
		           updatesBetween: visu mainLayer
		           and: evolvedVisu mainLayer.
	self
		with: visu
		stylizeDeletedElement: changes.
	evolvedVisu borderColorBlock: [ :entity | changes colorFor: entity ].
	evolvedVisu legend
		borderColorDescription: [ :entity | self modificationDescriptionForColor: (changes colorFor: entity) ]
		forNodes: [ evolvedVisu obtain recursively visibles nodes ].
	evolvedVisu styleSheet borderWidth: 1.5
]

{ #category : #architecture }
CPPSArchitectureBrowser >> addHighlightInteractionFrom: visu1 to: visu2 [

	^ visu1 addInteraction: (((TLStyleCustomizationAction
			     custom: [ :style | style borderColor: Color red ]
			     target:
				     [ :aNode | 
				     | entities |

				     entities := (visu2 obtain recursively nodesSelect:
					                  [ :each | 
					                  self
						                  compareEquivalenceNode: aNode
						                  withSecondNode: each
					                  ]) entities.
				     visu2 nodesForEntities: entities
				     ]) updateAlso: visu2) withMenu: (self
				    translate: 'Show repartition'
				    french: 'Montrer la répartition')) propagateToChildren
]

{ #category : #architecture }
CPPSArchitectureBrowser >> addInteractionsFrom: aVisualisation to: otherVisu [

	otherVisu do:
		[ :visu | 
		self
			addHighlightInteractionFrom: aVisualisation
			to: visu
		]
]

{ #category : #architecture }
CPPSArchitectureBrowser >> addMenuInteractionOn: archiVisualization [

	| session |

	session := self session.
	archiVisualization
		addInteraction: ((TLExpandCollapseCompositeNodeAction new condition: [ :drawable | drawable isNode and: [ drawable isComposite and: [ drawable childrenNodes isNotEmpty ] ] ]) withMenu: 'Fold / Unfold') propagateToChildren;
		addInteraction: (((CPPSTagAction tag: [ session currentTag ]) condition: [ :aNode | (aNode entity isKindOf: CPPSArchitectureEntity) not ]) withMenu: 'Tag with selected tag') propagateToChildren;
		addInteraction: ((TLSeasideCallBackAction inNewTabWithBlock: [ :aNode | self openAdaptatedBrowserOn: { aNode entity modelEntity } ])
				 condition: [ :aNode | (aNode entity isKindOf: CPPSArchitectureEntity) and: [ aNode entity isAssigned ] ];
				 withMenu: 'Show in specific browser') propagateToChildren;
		addInteraction: ((TLSeasideCallBackAction inNewTabWithBlock: [ :aNode | self openAdaptatedBrowserOn: { aNode entity } ])
				 condition: [ :aNode | (aNode entity isKindOf: CPPSArchitectureEntity) not ];
				 withMenu: 'Show in CodeAnalyzer') propagateToChildren
]

{ #category : #accessing }
CPPSArchitectureBrowser >> architecturesWithVersion [

	^ architecturesWithVersion ifNil: [ architecturesWithVersion := self defaultArchitecturesWithVersion ]
]

{ #category : #accessing }
CPPSArchitectureBrowser >> architecturesWithVersion: anObject [

	architecturesWithVersion := anObject
]

{ #category : #accessing }
CPPSArchitectureBrowser >> browserClass [

	^ #architecture
]

{ #category : #accessing }
CPPSArchitectureBrowser >> browserState [

	^ browserState
]

{ #category : #accessing }
CPPSArchitectureBrowser >> browserState: anObject [

	browserState := anObject.
	self architecturesWithVersion: (browserState architectureToDisplayFor: self)
]

{ #category : #hooks }
CPPSArchitectureBrowser >> children [

	^ Array
		  with: self toolbar
		  with: self rightPanel
		  with: self menuComponent
]

{ #category : #accessing }
CPPSArchitectureBrowser >> clearVisus [

	visus := nil
]

{ #category : #'as yet unclassified' }
CPPSArchitectureBrowser >> compareEquivalenceNode: aTLCompositeNode withSecondNode: aTLCompositeNode2 [

	(aTLCompositeNode2 entity includesAnyTag: aTLCompositeNode entity tags) ifTrue: [ ^ true ].
	aTLCompositeNode entity modelEntity name = aTLCompositeNode2 entity modelEntity name ifTrue: [ ^ true ].
	^ (aTLCompositeNode2 childrenNodes reject: #isVisible) anySatisfy:
		  [ :child | 
		  self
			  compareEquivalenceNode: aTLCompositeNode
			  withSecondNode: child
		  ]
]

{ #category : #accessing }
CPPSArchitectureBrowser >> createNewArchitecture [

	^ createNewArchitecture
]

{ #category : #accessing }
CPPSArchitectureBrowser >> createNewArchitecture: anObject [

	createNewArchitecture := anObject
]

{ #category : #accessing }
CPPSArchitectureBrowser >> defaultArchitecturesForComparisonMode [

	"If we have two architectures, we compare them, if not we compare two versions with the architecture"

	^ self architectures size >= 2
		  ifTrue:
			  [ (self architectures last: 2) collect:
				  [ :architecture | 
				  CPPSArchitectureVisualizationConfiguration
					  architecture: architecture
					  version: self currentUser version
				  ]
			  ]
		  ifFalse:
			  [ | versions |

			  versions := OrderedCollection with: self currentUser version.
			  self versions size > 1 ifTrue: [ versions add: (self versions reverse detect: [ :aVersion | aVersion ~= self currentUser version ]) ].
			  versions collect:
				  [ :aVersion | 
				  CPPSArchitectureVisualizationConfiguration
					  architecture: self architectures anyOne
					  version: aVersion
				  ]
			  ]
]

{ #category : #accessing }
CPPSArchitectureBrowser >> defaultArchitecturesWithVersion [

	^ self architectures
		  ifNotEmpty:
			  [ :archs | 
			  OrderedCollection with: (CPPSArchitectureVisualizationConfiguration
					   architecture: archs last
					   version: self currentUser version)
			  ]
		  ifEmpty: [ OrderedCollection new ]
]

{ #category : #components }
CPPSArchitectureBrowser >> defaultToolbar [

	^ MDLVerticalToolbar buttons: { 
			  ((MDLFoldButton for: '#' , self rightPanelId)
				   resetVisusOnFold;
				   yourself).
			  (self
				   switcherButton: (self
						    english: 'Highligth'
						    french: 'Détection')
				   tooltip: (self
						    english: 'Select a tag to highlight.'
						    french: 'Sélectionner un tag à détecter.')
				   perform: #setDefaultRightPanel).
			  (self
				   switcherButton: (self
						    english: 'Search'
						    french: 'Recherche')
				   tooltip: (self
						    english: 'Search in visu with tag.'
						    french: 'Rechercher dans la visu à l''aide de tag.')
				   perform: #setSearchWithTagPanel) }
]

{ #category : #architecture }
CPPSArchitectureBrowser >> defineArchitecture: aArchitectureLayer forPosition: anInteger [

	[ (self architecturesWithVersion at: anInteger) architecture: aArchitectureLayer ]
		on: SubscriptOutOfBounds
		do: [ self defineDefaultArchitectures ]
]

{ #category : #action }
CPPSArchitectureBrowser >> defineDefaultArchitectures [

	self architecturesWithVersion: self defaultArchitecturesWithVersion
]

{ #category : #architecture }
CPPSArchitectureBrowser >> defineVersion: aMooseProjectVersion forPosition: anInteger [

	(self architecturesWithVersion at: anInteger) version: aMooseProjectVersion
]

{ #category : #architecture }
CPPSArchitectureBrowser >> drillDownAction [

	^ TLExpandCollapseCompositeNodeAction new
		  condition: self drillDownCondition;
		  onExternalTrigger
]

{ #category : #architecture }
CPPSArchitectureBrowser >> drillDownCondition [

	^ [ :drawable | 
	  drawable isNode and:
		  [ drawable isComposite and:
			  [ drawable childrenNodes
				  ifEmpty: [ false ]
				  ifNotEmpty: [ (drawable childrenNodes anySatisfy: [ :child | child isVisible ]) not ]
			  ]
		  ]
	  ]
]

{ #category : #action }
CPPSArchitectureBrowser >> enableNewArchitectureCreation [

	^ self createNewArchitecture: true
]

{ #category : #action }
CPPSArchitectureBrowser >> foldRightPanel [

	self toolbar buttons first fold "Not the best way to do it but no time right now :("
]

{ #category : #testing }
CPPSArchitectureBrowser >> hasArchitectures [

	^ self architectures isEmpty
]

{ #category : #initialization }
CPPSArchitectureBrowser >> initialize [

	super initialize.
	self createNewArchitecture: false.
	self menuComponent: (CPPSArchitectureMenuComponent owner: self).
	browserState := self class possibleStates anyOne.
	self initializeRightPanel
]

{ #category : #testing }
CPPSArchitectureBrowser >> isComparingArchitecture [

	^ self architecturesWithVersion size > 1
]

{ #category : #accessing }
CPPSArchitectureBrowser >> menuComponent [

	^ menuComponent
]

{ #category : #accessing }
CPPSArchitectureBrowser >> menuComponent: anObject [

	menuComponent := anObject
]

{ #category : #architecture }
CPPSArchitectureBrowser >> modificationDescriptionForColor: aMDLColor [

	^ { 
		  ((MDLColor
			    tint: #green
			    code: #'500') -> (self
			    english: #Added
			    french: #Ajouté)).
		  ((MDLColor
			    tint: #orange
			    code: #'500') -> (self
			    english: #Changed
			    french: #Modifié)).
		  ((MDLColor
			    tint: #red
			    code: #'500') -> (self
			    english: #Deleted
			    french: #Supprimé)) } asDictionary
		  at: aMDLColor
		  ifAbsent: (self
				   english: #'No change'
				   french: #'Non modifié')
]

{ #category : #initialization }
CPPSArchitectureBrowser >> newArchitectureCreationRequired [

	^ self hasArchitectures or: [ self createNewArchitecture ]
]

{ #category : #opening }
CPPSArchitectureBrowser >> onEntity: anArchitecture [

	self architecturesWithVersion: (OrderedCollection with: (CPPSArchitectureVisualizationConfiguration
				  architecture: anArchitecture
				  version: self currentUser version))
]

{ #category : #rendering }
CPPSArchitectureBrowser >> renderArchitecturesOn: html [

	html mdlGrid
		id: self browserClass , '-grid';
		beGrowing;
		with:
			[ | numberOfArchitectures |

			numberOfArchitectures := self architecturesWithVersion size. "we create all visualizations before"
			self flag: #TODO. "/!\/!\/!\ DANGER DANGER!! In the following line we pass the current model and not the model we get through `arch value`. This is bad and break the multiple versions functionnality. /!\/!\/!\"
			visus := self architecturesWithVersion collect: [ :arch | CPPSArchitectureVisualization configuration: arch ].
			self browserState
				initializeVisus: visus
				for: self.
			self architecturesWithVersion doWithIndex:
					[ :anArchitectureWithVersion :i | 
					html mdlCell
						desktopSize: 12 / numberOfArchitectures;
						tabletSize: 8 / numberOfArchitectures;
						phoneSize: 4 / numberOfArchitectures;
						with:
							[ | visu visuComponent |

							visu := visus at: i.
							self addMenuInteractionOn: visu.
							self
								addInteractionsFrom: visu
								to: (visus collect: #value) \ { visu }.
							visuComponent := (TLCytoscapeComponent visualization: visu)
								                 withPNGExport;
								                 yourself.
							self
								renderExternalTriggersOf: visu
								for: visuComponent
								on: html.
							html render: visuComponent
							]
					].
			self renderNewArchitectureFabButton: html
			]
]

{ #category : #rendering }
CPPSArchitectureBrowser >> renderContentOn: html [

	html div
		class: self browserClass;
		with:
			[ self newArchitectureCreationRequired
				ifTrue:
					[ html render: (CPPSCreateArchitectureComponent owner: self).
					self createNewArchitecture: false
					]
				ifFalse:
					[ html render: self menuComponent.
					html div
						class: self browserClass , '-content';
						with:
							[ self renderArchitecturesOn: html.
							self renderRightPanelOn: html
							]
					]
			]
]

{ #category : #rendering }
CPPSArchitectureBrowser >> renderExternalTriggersOf: aVisu for: aVisuComponent on: html [

	| drillDown |

	drillDown := self drillDownAction.
	aVisu addInteraction: drillDown.
	html mdlMajorButton
		class: self browserClass , '-drill-down';
		onClick: (drillDown externalTriggerForVisuId: aVisuComponent visuDivId);
		with: 'drillDown'
]

{ #category : #rendering }
CPPSArchitectureBrowser >> renderNewArchitectureFabButton: html [

	html div
		class: self browserClass , '-grid__fab';
		with:
			[ html anchor
				callback: [ self enableNewArchitectureCreation ];
				with:
					[ html mdlButton
						fab;
						rippleEffect;
						accentColor;
						with: '+'
					]
			]
]

{ #category : #accessing }
CPPSArchitectureBrowser >> rightPanel [

	^ rightPanel
]

{ #category : #accessing }
CPPSArchitectureBrowser >> rightPanel: aComponent [

	rightPanel := aComponent
]

{ #category : #accessing }
CPPSArchitectureBrowser >> selectedTag [

	"BE CAREFUL! For now it works because there is only one right panel. It will break if you add some more. The logic will need to be updated in that case."

	^ self rightPanel selectedTag
]

{ #category : #accessing }
CPPSArchitectureBrowser >> selectedTag: aTag [

	self flag: 'Caution; it will not send to the selectTagComponent the selected tag'.
	visus ifNotNil: [ :vs | vs do: [ :aVisu | aVisu highlightTag: aTag ] ]
]

{ #category : #architecture }
CPPSArchitectureBrowser >> setBorderForTagsIn: visu [

	visu styleSheet > #tagChildrenHighlight borderColor:
		[ visu tagToHighlight
			ifNil: [ Color black ]
			ifNotNil: #color
		]
]

{ #category : #initialization }
CPPSArchitectureBrowser >> setDefaultRightPanel [

	self rightPanel: (CPPSTagSelectionPanel owner: self)
]

{ #category : #initialization }
CPPSArchitectureBrowser >> setSearchWithTagPanel [

	self rightPanel: (CPPSSearchWithTagPanel owner: self)
]

{ #category : #architecture }
CPPSArchitectureBrowser >> tagActionBlock [

	^ [ :aNode | self selectedTag ifNotNil: [ aNode entity modelLink: self selectedTag ] ]
]

{ #category : #accessing }
CPPSArchitectureBrowser >> toolbar [

	^ toolbar
]

{ #category : #accessing }
CPPSArchitectureBrowser >> toolbar: aComponent [

	toolbar := aComponent
]

{ #category : #action }
CPPSArchitectureBrowser >> unfoldRightPanel [

	self toolbar buttons first unfold "Not the best way to do it but no time right now :("
]

{ #category : #accessing }
CPPSArchitectureBrowser >> versions [

	^ self project versions
]

{ #category : #architecture }
CPPSArchitectureBrowser >> with: visu stylizeDeletedElement: changes [

	visu postBuild:
		[ "visu update"
		changes deletions do:
			[ :deletedChild | 
			[ (visu nodeForEntity: deletedChild modelEntity) borderColor: (changes colorFor: deletedChild) ]
				on: Error
				do: [ self flag: 'todo' ]
			]
		]
]
