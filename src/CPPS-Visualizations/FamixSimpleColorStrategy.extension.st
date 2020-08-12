Extension { #name : #FamixSimpleColorStrategy }

{ #category : #'*CPPS-Visualizations' }
FamixSimpleColorStrategy >> addBackgroundLegendToVisualization: aTLVisualization [

	aTLVisualization legend
		description: (aTLVisualization translate: ('Other' french: 'Autres'))
		forColor: self color
]

{ #category : #'*CPPS-Visualizations' }
FamixSimpleColorStrategy >> addBorderLegendToVisualization: aTLVisualization [

	aTLVisualization legend
		description: (aTLVisualization translate: ('Other' french: 'Autres'))
		forBorderColor: self color
]
