Class {
	#name : #CPPSRefactoringImpactBrowser,
	#superclass : #CPPSAbstractBrowser,
	#traits : 'TFilterBrowser + TRightTabsPanelBrowser',
	#classTraits : 'TFilterBrowser classTrait + TRightTabsPanelBrowser classTrait',
	#instVars : [
		'rightPanel',
		'toolbar',
		'visuComponent',
		'addedEntities',
		'directionStrategy',
		'kindsToExclude',
		'defaultScope'
	],
	#category : #'CPPS-Toolkit-RefactoringImpactAnalyzer'
}

{ #category : #accessing }
CPPSRefactoringImpactBrowser class >> browserName [

	^ 'Refactoring Impact Analyzer' french: 'Analyseur d''impact de rearchitecture'
]

{ #category : #accessing }
CPPSRefactoringImpactBrowser class >> priority [

	^ 10
]

{ #category : #accessing }
CPPSRefactoringImpactBrowser >> addedEntities [

	^ addedEntities
]

{ #category : #accessing }
CPPSRefactoringImpactBrowser >> browserClass [

	^ #'refactoring-impact-analyzer'
]

{ #category : #accessing }
CPPSRefactoringImpactBrowser >> defaultScope [

	^ defaultScope
]

{ #category : #accessing }
CPPSRefactoringImpactBrowser >> defaultScope: anObject [

	defaultScope := anObject
]

{ #category : #components }
CPPSRefactoringImpactBrowser >> defaultToolbar [

	^ MDLVerticalToolbar buttons: { 
			  ((MDLFoldButton for: '#' , self rightPanelId)
				   fold;
				   resetVisusOnFold;
				   yourself).
			  (self
				   switcherButton: 'Options'
				   perform: #setDefaultRightPanel) }
]

{ #category : #accessing }
CPPSRefactoringImpactBrowser >> defaultVisualisation [

	| visu session |

	visu := (CPPSRIAVisualization
		         owner: self
		         elementsToAnalyze: self addedEntities)
		        model: self model;
		        language: self session language.
	session := self session.
	visu addInteraction: ((CPPSTagAction tag: [ session currentTag ]) withMenu: 'Tag/Untag') propagateToChildren.
	^ (TLCytoscapeComponent visualization: visu)
		  withPNGExport;
		  yourself
]

{ #category : #accessing }
CPPSRefactoringImpactBrowser >> directionStrategy [

	^ directionStrategy ifNil: [ directionStrategy := CPPSRIAOutgoingDirectionStrategy ]
]

{ #category : #accessing }
CPPSRefactoringImpactBrowser >> directionStrategy: aDirection [

	directionStrategy := aDirection.
	self visuComponent visualization update
]

{ #category : #hook }
CPPSRefactoringImpactBrowser >> hookBeforeRendering [

	self resetVisu
]

{ #category : #initialization }
CPPSRefactoringImpactBrowser >> initialize [

	super initialize.
	self initializeFilterBrowser.
	self initializeBrowserSpecificFilters.
	self initializeRightPanel.
	kindsToExclude := OrderedCollection new.
	self resetAddedEntities
]

{ #category : #initialization }
CPPSRefactoringImpactBrowser >> initializeBrowserSpecificFilters [

	self tree rightIconBlock:
		[ :ent :html | 
		self
			renderAddButtonFor: ent
			on: html
		]
]

{ #category : #accessing }
CPPSRefactoringImpactBrowser >> kindsToExclude [

	^ kindsToExclude
]

{ #category : #accessing }
CPPSRefactoringImpactBrowser >> kindsToExclude: anObject [

	kindsToExclude := anObject
]

{ #category : #rendering }
CPPSRefactoringImpactBrowser >> renderAddButtonFor: entity on: html [

	html mdlButton
		accentColor;
		onClick: (html jQuery ajax callback:
					 [ self visuComponent visualization
						 addToVisible: entity;
						 update.
					 self addedEntities add: entity
					 ]);
		icon: #add_circle_outline
]

{ #category : #rendering }
CPPSRefactoringImpactBrowser >> renderBrowserContentOn: html [

	html div
		beGrowing;
		with: [ html render: self visuComponent ].
	self renderRightPanelOn: html
]

{ #category : #initialization }
CPPSRefactoringImpactBrowser >> resetAddedEntities [

	addedEntities := Set new
]

{ #category : #accessing }
CPPSRefactoringImpactBrowser >> resetVisu [

	^ visuComponent := self defaultVisualisation
]

{ #category : #accessing }
CPPSRefactoringImpactBrowser >> rightPanel [

	^ rightPanel
]

{ #category : #accessing }
CPPSRefactoringImpactBrowser >> rightPanel: aComponent [

	rightPanel := aComponent
]

{ #category : #accessing }
CPPSRefactoringImpactBrowser >> selectedEntity: anEntity [

	self tree selectedEntity: anEntity.
	self resetAddedEntities.
	self addedEntities add: anEntity.
	self visuComponent visualization elementsToAnalyze ifEmpty: [ "This happen at the first rendering." self visuComponent visualization elementsToAnalyze: self addedEntities ]
]

{ #category : #components }
CPPSRefactoringImpactBrowser >> setDefaultRightPanel [

	self rightPanel: (CPPSRefactoringImpactOptionsRightPanel owner: self)
]

{ #category : #accessing }
CPPSRefactoringImpactBrowser >> toolbar [

	^ toolbar
]

{ #category : #accessing }
CPPSRefactoringImpactBrowser >> toolbar: aComponent [

	toolbar := aComponent
]

{ #category : #accessing }
CPPSRefactoringImpactBrowser >> visuComponent [

	^ visuComponent ifNil: [ self resetVisu ]
]
