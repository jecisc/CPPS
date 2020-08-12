Extension { #name : #FamixStateColorStrategy }

{ #category : #'*CPPS-Visualizations' }
FamixStateColorStrategy >> addBackgroundLegendToVisualization: aTLVisualization [

	aTLVisualization legend
		description: (aTLVisualization translate: ('Duplicated' french: 'Dupliquée'))
		forColor: MDLColor orange;
		description: (aTLVisualization translate: ('Staticaly dead' french: 'Statiquement morte'))
		forColor: (MDLColor
				 tint: #red
				 code: '600')
]

{ #category : #'*CPPS-Visualizations' }
FamixStateColorStrategy >> addBorderLegendToVisualization: aTLVisualization [

	aTLVisualization legend
		description: (aTLVisualization translate: ('Duplicated' french: 'Dupliquée'))
		forBorderColor: MDLColor orange;
		description: (aTLVisualization translate: ('Staticaly dead' french: 'Statiquement morte'))
		forBorderColor: (MDLColor
				 tint: #red
				 code: '600')
]
