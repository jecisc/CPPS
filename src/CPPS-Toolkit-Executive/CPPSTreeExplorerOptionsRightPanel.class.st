"
Description
--------------------

I am a seaside component rendering options for the Tree Explorer browser. 

I allow the user to select the direction of the dependencies in the visualization.
"
Class {
	#name : #CPPSTreeExplorerOptionsRightPanel,
	#superclass : #CPPSAbstractRightPanel,
	#category : #'CPPS-Toolkit-Executive'
}

{ #category : #accessing }
CPPSTreeExplorerOptionsRightPanel >> directionStrategy [

	^ self treeExplorer directionStrategy
]

{ #category : #accessing }
CPPSTreeExplorerOptionsRightPanel >> directionStrategy: aStrategy [

	^ self treeExplorer directionStrategy: aStrategy
]

{ #category : #accessing }
CPPSTreeExplorerOptionsRightPanel >> nodeColorStrategies [

	^ { 
		  FamixKindColorStrategy.
		  FamixTagColorStrategy.
		  FamixStateColorStrategy } collect: #defaultStrategyWithFallback
]

{ #category : #accessing }
CPPSTreeExplorerOptionsRightPanel >> nodeColorStrategy [

	^ self treeExplorer nodeColorStrategy
]

{ #category : #accessing }
CPPSTreeExplorerOptionsRightPanel >> nodeColorStrategy: aColorStrategy [

	self treeExplorer nodeColorStrategy: aColorStrategy
]

{ #category : #rendering }
CPPSTreeExplorerOptionsRightPanel >> renderContentOn: html [

	html div
		marginAuto;
		style: 'width: 90%;';
		with:
			[ self
				renderDirectionOptionOn: html;
				renderNodeColorOptionOn: html
			]
]

{ #category : #rendering }
CPPSTreeExplorerOptionsRightPanel >> renderDirectionOptionOn: html [

	html headerContainer:
		[ html headline: (self
				 english: 'Dependencies directions'
				 french: 'Direction des dépendances')
		].
	html form
		noAutocomplete;
		with:
			[ html mdlGrid
				formControl;
				mdlTypographyTextJustify;
				with:
					[ html radioGroup
						callback: [ :value | self directionStrategy: value ];
						selected: self directionStrategy;
						with:
							[ :group | 
							CPPSTreeExplorerDirectionStrategy strategies do:
									[ :directionStrategy | 
									html mdlRadioContainer
										rippleEffect;
										beCell: 6
										phoneSize: 4
										tabletSize: 2;
										for: html nextId;
										with:
											[ group mdlRadioButton
												value: directionStrategy;
												onChange: 'submit()' js;
												id: html lastId.
											html mdlRadioLabel: directionStrategy label
											]
									]
							]
					]
			]
]

{ #category : #rendering }
CPPSTreeExplorerOptionsRightPanel >> renderNodeColorOptionOn: html [

	html headerContainer:
		[ html headline: (self
				 english: 'Entity colors'
				 french: 'Couleur des entités')
		].
	html form
		noAutocomplete;
		with:
			[ html mdlGrid
				formControl;
				mdlTypographyTextJustify;
				with:
					[ html radioGroup
						callback: [ :value | self nodeColorStrategy: value ];
						selected: self nodeColorStrategy;
						with:
							[ :group | 
							self nodeColorStrategies do:
									[ :directionStrategy | 
									html mdlRadioContainer
										rippleEffect;
										beCell: 6
										phoneSize: 4
										tabletSize: 2;
										for: html nextId;
										with:
											[ group mdlRadioButton
												value: directionStrategy;
												onChange: 'submit()' js;
												id: html lastId.
											html mdlRadioLabel: directionStrategy label
											]
									]
							]
					]
			]
]

{ #category : #accessing }
CPPSTreeExplorerOptionsRightPanel >> treeExplorer [

	^ self owner
]
