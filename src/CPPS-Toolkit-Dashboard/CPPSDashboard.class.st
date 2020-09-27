"
Description
--------------------

I am a tool to display high level information on the model been analyzed.
"
Class {
	#name : #CPPSDashboard,
	#superclass : #CPPSAbstractBrowser,
	#instVars : [
		'currentMetric'
	],
	#category : #'CPPS-Toolkit-Dashboard'
}

{ #category : #accessing }
CPPSDashboard class >> browserName [

	^ 'Dashboard' french: 'Tableau de Bord'
]

{ #category : #strategies }
CPPSDashboard class >> commentedCodeStrategy [

	<metricStrategy: #commentedCodeRate priority: 30>
	^ CPPSDashboardMetricStrategy
		  classByIntervals: (CPPSDashboardMetricStrategy
				   classAscendingRateFor: 0.05
				   and: 0.15)
		  named: ('Commented Code' french: 'Code Commenté')
		  helpText: ('The commented code is the old code that is still inside the program as comment.' french: 'Le code commenté correspond au vieux code qui est toujours au sein de l''application en tant que commentaire.')
		  displayBlock: CPPSDashboardMetricStrategy displayAsPercentBlock
]

{ #category : #strategies }
CPPSDashboard class >> complexityStrategy [

	<metricStrategy: #complexityRate priority: 25>
	^ CPPSDashboardMetricStrategy
		  classByIntervals: (CPPSDashboardMetricStrategy
				   classAscendingFrom: 0
				   to: 3
				   to: 6
				   to: 5000)
		  named: ('Cyclomatic Complexity' french: 'Complexité Cyclomatique')
		  helpText: ('The cyclomatic complexity measure the number paths through a program''s source code.' french: 'La complexité cyclomatique mesure le nombre de chemins dans le code source du programme.')
		  displayBlock: [ :elem | (elem asFloat round: 1) asString ]
]

{ #category : #strategies }
CPPSDashboard class >> deadCodeStrategy [

	<metricStrategy: #deadCodeRate priority: 15>
	^ CPPSDashboardMetricStrategy
		  classByIntervals: (CPPSDashboardMetricStrategy
				   classAscendingRateFor: 0.05
				   and: 0.10)
		  named: ('Dead Code' french: 'Code Mort')
		  helpText: ('The dead code is the code that is not referenced by other entities in the application.' french: 'Le code mort correspond au code qui n''est pas référencé par d''autres entitées de l''application.')
		  displayBlock: CPPSDashboardMetricStrategy displayAsPercentBlock
]

{ #category : #strategies }
CPPSDashboard class >> documentationStategy [

	<metricStrategy: #documentationRate priority: 20>
	^ CPPSDashboardMetricStrategy
		  classByIntervals: (CPPSDashboardMetricStrategy
				   classDescendingRateFor: 0.3
				   and: 0.5)
		  named: ('Documentation' french: 'Documentation')
		  helpText: ('The documentation is the rate of the comments among the source code.' french: 'La documentation est le ratio de commentaires parmi le code source.')
		  displayBlock: CPPSDashboardMetricStrategy displayAsPercentBlock
]

{ #category : #strategies }
CPPSDashboard class >> duplicationStrategy [

	<metricStrategy: #duplicationRate priority: 10>
	^ CPPSDashboardMetricStrategy
		  classByIntervals: (CPPSDashboardMetricStrategy
				   classAscendingRateFor: 0.1
				   and: 0.2)
		  named: ('Duplication' french: 'Duplication')
		  helpText: ('The duplication is the repetition of code among different entites in the application.' french: 'La duplication est la répétition de code parmi différentes entitées de l''application.')
		  displayBlock: CPPSDashboardMetricStrategy displayAsPercentBlock
]

{ #category : #accessing }
CPPSDashboard class >> priority [

	^ 200
]

{ #category : #strategies }
CPPSDashboard class >> projectSizeStrategy [

	<metricStrategy: #numberOfLinesOfCode priority: 5>
	^ CPPSDashboardMetricStrategy
		  classByIntervals: (Dictionary
				   with: (0 to: 100000) -> #lowAttention
				   with: (100000 to: 1000000) -> #attention
				   with: (1000000 to: 10000000000000000000000) -> #highAttention)
		  named: ('Project size' french: 'Taille du projet')
		  helpText: ('The project size is an indicator based on our experience to have an idea of the required infrastructure.' french: 'La taille du projet est un indicateur basé sur notre expérience pour évaluer l''infrastructure requise.')
		  displayBlock: #printFormated
]

{ #category : #strategies }
CPPSDashboard class >> technicalDebtStrategy [

	<metricStrategy: #technicalDebt priority: 35>
	self flag: #check. "This is pretty random, we should discuss about the values"
	^ CPPSDashboardMetricStrategy
		  classByIntervals: (Dictionary
				   with: (0 to: 10) -> #lowAttention
				   with: (10 to: 100) -> #attention
				   with: (100 to: 10000000000000000000000) -> #highAttention)
		  named: ('Technical Debt' french: 'Dette Technique')
		  helpText: ('Represent the cost of extra developments arising from the implementation of a short run solution instead of the best overall solution.' french: 'Représente le coût en développements supplémentaires provenant de l''implémentation de solutions à court terme au lieu .')
		  displayBlock: [ :number | (number printShowingMaxDecimalPlaces: 2) , ' days' ]
]

{ #category : #accessing }
CPPSDashboard >> currentMetric [

	^ currentMetric
]

{ #category : #accessing }
CPPSDashboard >> currentMetric: anObject [

	currentMetric := anObject
]

{ #category : #initialization }
CPPSDashboard >> initialize [

	super initialize.
	self currentMetric: self metrics first
]

{ #category : #components }
CPPSDashboard >> metricComponentFor: metricName [

	^ CPPSDashboardMetricComponent
		  strategy: (self strategy metricStrategyFor: metricName)
		  value: (self model perform: metricName)
		  actionBlock: [ self currentMetric: metricName ]
		  ajaxRenderingBlock: [ :ajaxHtml | self renderGraphsOn: ajaxHtml ]
		  isSelected: self currentMetric = metricName
]

{ #category : #accessing }
CPPSDashboard >> metrics [

	^ self strategy dashboardMetrics
]

{ #category : #opening }
CPPSDashboard >> onEntity: anEntity [

	"I do not manage entities so I do nothing."

	
]

{ #category : #rendering }
CPPSDashboard >> renderContentOn: html [

	html div
		class: 'dashboard';
		with:
			[ self renderMetricsOn: html.
			html div
				id: #dashboard_graphs;
				class: self currentMetric;
				with: [ self renderGraphsOn: html ]
			].
	html document addLoadScript: 'initDashboard()' js
]

{ #category : #rendering }
CPPSDashboard >> renderGraphsOn: html [

	((self strategy metricChartsFor: self currentMetric)
		 cull: self session language
		 cull: self model) do:
		[ :aChart | 
		html render: (ChartJsComponent
				 data: aChart
				 callback:
					 [ :s | 
					 [ self openAdaptatedBrowserOn: s ]
						 on: CPPSNoBrowserToDisplayException
						 do: [  ]
					 ])
		]
]

{ #category : #rendering }
CPPSDashboard >> renderMetricsOn: html [

	html div
		class: 'metrics';
		shadow: 2;
		with: [ self metrics do: [ :metricName | html render: (self metricComponentFor: metricName) ] ]
]
