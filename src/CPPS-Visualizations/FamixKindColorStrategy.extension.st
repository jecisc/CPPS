Extension { #name : #FamixKindColorStrategy }

{ #category : #'*CPPS-Visualizations' }
FamixKindColorStrategy >> addBackgroundLegendToVisualization: aTLVisualization [

	aTLVisualization legend
		backgroundDescription: [ :entity | aTLVisualization translate: entity multilanguageDisplayName ]
		forNodes: [ aTLVisualization obtain recursively visibles nodes ]
]

{ #category : #'*CPPS-Visualizations' }
FamixKindColorStrategy >> addBorderLegendToVisualization: aTLVisualization [

	aTLVisualization legend
		borderColorDescription: [ :entity | aTLVisualization translate: entity multilanguageDisplayName ]
		forNodes: [ aTLVisualization obtain recursively visibles nodes ]
]
