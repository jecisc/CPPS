Extension { #name : #CPPSBrowserStrategy }

{ #category : #'*CPPS-Toolkit-Dashboard' }
CPPSBrowserStrategy class >> behaviourialRepartitionDataFrom: aModel in: aLanguage [

	| executables duplicated dead deadAndDuplicated rest |

	executables := aModel allModelBehaviourals asOrderedCollection.
	duplicated := aModel allBehaviouralsWithDuplicatedCode asOrderedCollection.
	dead := aModel allBehaviouralsWithDeadCode asOrderedCollection.
	deadAndDuplicated := duplicated intersection: dead.
	rest := executables \ dead \ duplicated.
	duplicated := duplicated \ deadAndDuplicated.
	dead := dead \ deadAndDuplicated.
	^ { 
		  (ChartDataValue
			   value: duplicated
			   name: (('Duplicated Entities' french: 'Entitées dupliqués') into: aLanguage)
			   color: MDLColor orange).
		  (ChartDataValue
			   value: dead
			   name: (('Dead Entities' french: 'Entitées morts') into: aLanguage)
			   color: MDLColor red).
		  (ChartDataValue
			   value: deadAndDuplicated
			   name: (('Dead and duplicated Entities' french: 'Entitées morts et dupliqués') into: aLanguage)
			   color: MDLColor purple).
		  (ChartDataValue
			   value: rest
			   name: (('Other Entities' french: 'Autres Entitées') into: aLanguage)
			   color: MDLColor green) }
]

{ #category : #'*CPPS-Toolkit-Dashboard' }
CPPSBrowserStrategy class >> complexityCharts [

	^ [ :language :model | 
	  | metrics |

	  metrics := model allModelBehaviourals groupedBy: [ :f | self logRepartitionFor: f cyclomaticComplexity ].
	  metrics associationsDo:
		  [ :assoc | 
		  assoc value
			  propertyNamed: #cyclo
			  ifAbsentPut: assoc key
		  ].
	  metrics := metrics associations select: [ :asso | (asso value propertyNamed: #cyclo) > 10 ].
	  metrics := metrics sorted: [ :one :two | (one value propertyNamed: #cyclo) < (two value propertyNamed: #cyclo) ].
	  { ((Chart2dData
		    xObjects: ((metrics collect: #value) collect: [ :aGroup | aGroup propertyNamed: #cyclo ])
		    yObjects: (metrics collect: #value))
		   chartType: ChartBar;
		   valueDisplayBlock: #size;
		   title: (('Diagram of the repartition of the methods with a dangerous cyclomatic complexity.' french: 'Diagramme de la repartition des méthodes avec une complexité cyclomatique dangereuse.') into: language);
		   dataSetsColors: { MDLColor purple };
		   singleValueTooltip: (('There is <value> entities with a cyclomatic complexity close to <key>' french: 'Il y a <value> entités avec une complexité cyclomatique autour de <key>') into: language);
		   yourself) }
	  ]
]

{ #category : #'*CPPS-Toolkit-Dashboard' }
CPPSBrowserStrategy class >> deadCodeCharts [

	^ [ :language :model | 
	  | data |

	  data := model allBehaviouralsWithDeadCode groupedBy:
		          [ :f | 
		          f numberOfLinesOfCode <= 0
			          ifFalse: [ ((f numberOfLinesOfCode log roundDownTo: 0.1) * 10 ln) exp rounded ]
			          ifTrue: [ 0 ]
		          ].
	  { ((Chart2dData
		    xObjects: data keys sorted
		    function: [ :key | data at: key ]
		    color: MDLColor red)
		   chartType: ChartBar;
		   valueDisplayBlock: #size;
		   title: (('Diagram of the dead entities repartition by number of lines of code.' french: 'Diagramme de la répartition des entités statiquement morte en fonction de leur taille.') into: language);
		   singleValueTooltip: (('There is <value> dead entities with <key> lines of code' french: 'Il y a <value> entités avec <key> lignes de code') into: language);
		   yourself) }
	  ]
]

{ #category : #'*CPPS-Toolkit-Dashboard' }
CPPSBrowserStrategy class >> defaultMetricsChart [

	^ Dictionary new
		  at: #numberOfLinesOfCode
		  put: self overviewCharts;
		  at: #duplicationRate
		  put: self duplicationCharts;
		  at: #deadCodeRate
		  put: self deadCodeCharts;
		  at: #documentationRate
		  put: self documentationCharts;
		  at: #complexityRate
		  put: self complexityCharts;
		  at: #commentedCodeRate
		  put: self documentationCharts;
		  at: #technicalDebt
		  put: self technicalDebtCharts;
		  yourself
]

{ #category : #'*CPPS-Toolkit-Dashboard' }
CPPSBrowserStrategy class >> documentationCharts [

	^ [ :language :model | 
	  | comments codeComments sourceCommentRatesClean sourceCommentRates |

	  comments := model allModelBehaviourals asOrderedCollection groupedBy: [ :p | p commentsRatio roundTo: 0.05 ].
	  codeComments := model allModelBehaviourals asOrderedCollection groupedBy: [ :p | p commentedCodeCommentsPercentage roundTo: 0.05 ].
	  codeComments
		  removeKey: 0.0
		  ifAbsent: [ "Here we do not have any program without code in comments" ].
	  sourceCommentRatesClean := (model allModelBehaviourals asOrderedCollection reject: [ :p | p sourceCommentRateWithCleaning = 3 ]) groupedBy: [ :p | ((p sourceCommentRateWithCleaning roundTo: 0.1) * 10) rounded asInteger / 10 ]. "codeComments
		removeKey: 0.0
		ifAbsent: [ 
			Here we do not have any program without code in comments
			 ]."
	  sourceCommentRates := (model allModelBehaviourals asOrderedCollection reject: [ :p | p sourceCommentRateWithoutCleaning = 3 ]) groupedBy: [ :p | ((p sourceCommentRateWithoutCleaning roundTo: 0.2) * 10) rounded asInteger / 10 ].
	  { 
		  ((Chart2dData
			    xObjects: comments keys sorted
			    function: [ :key | comments at: key ]
			    color: MDLColor blueGrey)
			   displayKeysAsPercent;
			   valueDisplayBlock: #size;
			   chartType: ChartBar;
			   title: (('Repartition diagram of the programs depending on their comments rate.' french: 'Diagramme dela répartition des programmes en fonction de leur taux de commentaires') into: language);
			   singleValueTooltip: (('<value> programs have a rate of comments of <key>' french: '<value> programmes ont un taux de commentaires de <key>') into: language)).
		  ((Chart2dData
			    xObjects: codeComments keys sorted
			    function: [ :key | codeComments at: key ]
			    color: (MDLColor
					     tint: #yellow
					     code: '600'))
			   displayKeysAsPercent;
			   valueDisplayBlock: #size;
			   chartType: ChartBar;
			   title: (('Repartition diagram of the programs depending on the rate of code in their comments.' french: 'Diagramme dela répartition des programmes en fonction du taux de code dans leurs commentaires') into: language);
			   singleValueTooltip: (('<value> programs have a rate of code in their comments of <key>' french: '<value> programmes ont un taux de code dans les commentaires de <key>') into: language)).
		  ((Chart2dData
			    xObjects: sourceCommentRates keys sorted
			    function: [ :key | sourceCommentRates at: key ]
			    color: (MDLColor
					     tint: #yellow
					     code: '600'))
			   valueDisplayBlock: #size;
			   chartType: ChartBar;
			   title: (('Repartition diagram of the programs depending on their source comment rate.' french: 'Diagramme dela répartition des programmes en fonction du source comment rate') into: language);
			   singleValueTooltip: (('<value> programs have a source comment rate of <key>' french: '<value> programmes ont un source comment rate de <key>') into: language)).
		  ((Chart2dData
			    xObjects: sourceCommentRatesClean keys sorted
			    function: [ :key | sourceCommentRatesClean at: key ]
			    color: (MDLColor
					     tint: #yellow
					     code: '600'))
			   valueDisplayBlock: #size;
			   chartType: ChartBar;
			   title: (('Repartition diagram of the programs depending on their source comment rate cleaned.' french: 'Diagramme dela répartition des programmes en fonction du source comment rate après nettoyage') into: language);
			   singleValueTooltip: (('<value> programs have a cleaned source comment rate of <key>' french: '<value> programmes ont un source comment rate sans le bruit de <key>') into: language)) }
	  ]
]

{ #category : #'*CPPS-Toolkit-Dashboard' }
CPPSBrowserStrategy class >> duplicationCharts [

	| fragmentsMetrics clonesMetrics |

	^ [ :language :model | 
	  | metrics |

	  metrics := (model allModelBehaviourals asOrderedCollection select: #containsReplicas) groupedBy: [ :f | f duplicationRate roundDownTo: 0.05 ].
	  metrics
		  at: 0.0
		  ifPresent:
			  [ :metr | 
			  metrics removeKey: 0.0.
			  metrics
				  at: 0.1
				  put: metr
			  ].
	  fragmentsMetrics := model allReplicatedFragments asOrderedCollection groupedBy: [ :f | self logRepartitionFor: f averageNumberOfLines ].
	  clonesMetrics := model allReplicatedFragments asOrderedCollection groupedBy: [ :f | self logRepartitionFor: f replicas size ].
	  { 
		  ((Chart2dData
			    xObjects: metrics keys sorted
			    function: [ :key | metrics at: key ]
			    color: MDLColor orange)
			   chartType: ChartBar;
			   valueDisplayBlock: #size;
			   displayKeysAsPercent;
			   title: (('Diagram of the duplication proportion in duplicated methods.' french: 'Diagramme du taux de duplication au sein des méthodes dupliquées.') into: language);
			   singleValueTooltip: (('There is <value> entities with <key> to <%= parseInt(label.slice(0,-1)) + 5 %>% of duplication' french: 'Il y a <value> entités avec <key> à <%= parseInt(label.slice(0,-1)) + 5 %> % de duplication') into: language);
			   yourself).
		  ((Chart2dData
			    xObjects: fragmentsMetrics keys sorted
			    function: [ :key | fragmentsMetrics at: key ]
			    color: MDLColor red)
			   chartType: ChartBar;
			   valueDisplayBlock: #size;
			   title: (('Diagram of the duplication fragment size repartition.' french: 'Diagramme de la répartition en taille des fragments de duplications') into: language);
			   singleValueTooltip: (('There is <value> fragments with <key> lines of duplication' french: 'Il y a <value> fragments avec <key> lignes de duplication') into: language);
			   yourself).
		  ((Chart2dData
			    xObjects: clonesMetrics keys sorted
			    function: [ :key | clonesMetrics at: key ]
			    color: MDLColor purple)
			   valueDisplayBlock: #size;
			   chartType: ChartBar;
			   title: (('Diagram of the number of clones per fragments.' french: 'Diagramme du nombre de clones par fragment') into: language);
			   singleValueTooltip: (('There is <value> fragment with <key> clones' french: 'Il y a <value> fragments avec <key> clones') into: language);
			   yourself) }
	  ]
]

{ #category : #'*CPPS-Toolkit-Dashboard' }
CPPSBrowserStrategy class >> entitiesRepartitionDataFrom: aModel in: aLanguage [

	^ (aModel allMainEntities asOrderedCollection groupedBy: #class) associations collect:
		  [ :classAndGroup | 
		  ChartDataValue
			  value: classAndGroup value
			  name: (classAndGroup key multilanguageDisplayName into: aLanguage)
			  color: classAndGroup key color
		  ]
]

{ #category : #'*CPPS-Toolkit-Dashboard' }
CPPSBrowserStrategy class >> logRepartitionFor: f [

	f = 0 ifTrue: [ ^ 0 ].
	^ ((f log roundDownTo: 0.1) * 10 ln) exp rounded
]

{ #category : #'*CPPS-Toolkit-Dashboard' }
CPPSBrowserStrategy class >> metricCharts [

	^ MetricCharts ifNil: [ MetricCharts := self defaultMetricsChart ]
]

{ #category : #'*CPPS-Toolkit-Dashboard' }
CPPSBrowserStrategy class >> metricChartsFor: aSymbole [

	"I should return a block that can take a language. This block sould return a collection of Charts for a metric."

	^ self metricCharts at: aSymbole
]

{ #category : #'*CPPS-Toolkit-Dashboard' }
CPPSBrowserStrategy class >> metricStrategyFor: aSymbol [

	^ self metricStrategies at: aSymbol
]

{ #category : #'*CPPS-Toolkit-Dashboard' }
CPPSBrowserStrategy class >> overviewCharts [

	^ [ :language :model | 
	  | result |

	  result := OrderedCollection new.
	  self selectorsForRepartitionInOverview do:
		  [ :selector | 
		  (model perform: selector) asOrderedCollection ifNotEmpty:
			  [ :entities | 
			  result add: ((Chart2dData
					    xObjects: { '' }
					    multiYObjects: { ((entities anyOne multilanguageDisplayName into: language) -> { (ChartBoxPlotData forRepartition: (model numberOfLinesOfCodeRepartitionFor: selector)) }) })
					   dataSetsColors: { entities anyOne class color };
					   chartType: ChartBoxPlot;
					   title: (('Repartition of the number of lines in the ' french: 'Diagramme du nombre de ligne dans les ') into: language) , entities size asString , ' ' , (entities anyOne multilanguageDisplayName into: language) pluralize)
			  ]
		  ].
	  model allModelBehaviourals ifNotEmpty:
		  [ :executables | 
		  result add: ((Chart1dData new
				    datas: (self
						     behaviourialRepartitionDataFrom: model
						     in: language);
				    valueDisplayBlock: #size)
				   title: (('Repartition of the ' , executables size asString , ' programs depending on state' french: 'Répartition des ' , executables size asString , ' programmes selon leur état') into: language);
				   chartType: ChartPie;
				   yourself)
		  ].
	  result add: ((Chart1dData new
			    datas: (self
					     entitiesRepartitionDataFrom: model
					     in: language);
			    valueDisplayBlock: #size)
			   title: (('Repartition of the entities depending on type' french: 'Répartition des entités selon leur type') into: language);
			   chartType: ChartPie;
			   yourself).
	  result
	  ]
]

{ #category : #'*CPPS-Toolkit-Dashboard' }
CPPSBrowserStrategy class >> selectorsForRepartitionInOverview [

	^ self subclassResponsibility
]

{ #category : #'*CPPS-Toolkit-Dashboard' }
CPPSBrowserStrategy class >> technicalDebtCharts [

	^ [ :language :model | 
	  | datas |

	  datas := model rulesManager listAllRules collect:
		           [ :rule | 
		           ChartDataValue
			           value: rule
			           name: rule label
			           color: MDLColor randomColorAndTint
		           ].
	  (Chart1dData new
		   datas: datas;
		   title: (('Repartition of the rules infractions by rule' french: 'Répartition des infractions aux régles par régle') into: language);
		   valueDisplayBlock: [ :rule | (rule totalRemediationTime asDays printShowingMaxDecimalPlaces: 2) asNumber ];
		   chartType: ChartPie;
		   singleValueTooltip: '<key>: <value>' , ((' days to correct' french: ' jours pour corriger') into: language);
		   yourself) asOrderedCollection
	  ]
]
