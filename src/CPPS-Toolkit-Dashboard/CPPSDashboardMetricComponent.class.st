"
Description
----------------------

I am a component to display a Dashboard metric.

I work with a strategy that should be a CPPSMetricStrategy. With this strategy I am able te render a Metric and his decoration. 

The user can click on me to update the current view of the browser containing me.

I am mostly use by a CPPSDashboard to render the principals metrics of an application.

Example
---------------------

	| strategy |
	
	strategy := CPPSDashboardMetricStrategy
		classByIntervals:
			(Dictionary with: (0 to: 33) -> #danger with: (33 to: 66) -> #warning with: (66 to: 100) -> #healthy)
		text: 'Duplication'
		helpText: 'The duplication is the repetition of code among different entites in the application.'
		icon: 'duplicationIconPng'
		displayBlock: [ :elem | elem asString , '%' ].
		
	CPPSDashboardMetricComponent 
		startegy: strategy 
		value: 5
		actionBlock: [ self currentMetric: metricName ]
		ajaxRenderingBlock: [ :ajaxHtml | self renderGraphsOn: ajaxHtml ]
		isSelected: self currentMetric = metricName
 
Internal Representation and Key Implementation Points.
---------------------

    Instance Variables
	actionBlock:					<aBlock >					A block to execute when the user click on the metric component.
	ajaxRenderingBlock:		<aBlock >					A block taking a html canvas as parameter to render the new browser content on click.
	isSelected:					<aBoolean>				To know if the component is currently selected.
	metric:						<anInteger> 				I am the metric that should be display. 
	metricStrategy:				<aMetricStrategy>	 	I am a strategy to help the renderer. For example I am able to give an icon for a metric.

"
Class {
	#name : #CPPSDashboardMetricComponent,
	#superclass : #CPPSComponent,
	#instVars : [
		'metric',
		'actionBlock',
		'isSelected',
		'metricStrategy',
		'ajaxRenderingBlock'
	],
	#classVars : [
		'IconsForClass'
	],
	#category : #'CPPS-Toolkit-Dashboard'
}

{ #category : #accessing }
CPPSDashboardMetricComponent class >> defaultIconsForClass [

	^ Dictionary new
		  at: #danger
		  put: #thumb_down;
		  at: #warning
		  put: #thumbs_up_down;
		  at: #healthy
		  put: #thumb_up;
		  at: #lowAttention
		  put: #card_travel;
		  at: #attention
		  put: #card_travel;
		  at: #highAttention
		  put: #card_travel;
		  at: #unavailable
		  put: #report;
		  yourself
]

{ #category : #accessing }
CPPSDashboardMetricComponent class >> iconFor: aClassName [

	^ self iconsForClass at: aClassName
]

{ #category : #accessing }
CPPSDashboardMetricComponent class >> iconsForClass [

	^ IconsForClass ifNil: [ IconsForClass := self defaultIconsForClass ]
]

{ #category : #accessing }
CPPSDashboardMetricComponent class >> iconsForClass: anObject [

	IconsForClass := anObject
]

{ #category : #'instance creation' }
CPPSDashboardMetricComponent class >> strategy: aStrategy value: aMetric actionBlock: aBlock ajaxRenderingBlock: aBlock2 isSelected: aBoolean [

	^ self new
		  metricStrategy: aStrategy;
		  metric: aMetric;
		  actionBlock: aBlock;
		  ajaxRenderingBlock: aBlock2;
		  isSelected: aBoolean;
		  yourself
]

{ #category : #accessing }
CPPSDashboardMetricComponent >> actionBlock [

	^ actionBlock
]

{ #category : #accessing }
CPPSDashboardMetricComponent >> actionBlock: anObject [

	actionBlock := anObject
]

{ #category : #javascript }
CPPSDashboardMetricComponent >> ajaxOnClickFor: html [

	^ html jQuery ajax
		  callback: [ self actionBlock value ];
		  context: (JSStream on: 'this');
		  onComplete: (html jQuery script:
					   [ :s | 
					   s
						   << ((html jQuery: '#dashboard_graphs') load html: self ajaxRenderingBlock);
						   << ((html jQuery: '.metricComponent') removeClass: 'mdl-shadow--4dp');
						   << (html jQuery this addClass: 'mdl-shadow--4dp')
					   ])
]

{ #category : #accessing }
CPPSDashboardMetricComponent >> ajaxRenderingBlock [

	^ ajaxRenderingBlock
]

{ #category : #accessing }
CPPSDashboardMetricComponent >> ajaxRenderingBlock: anObject [

	ajaxRenderingBlock := anObject
]

{ #category : #accessing }
CPPSDashboardMetricComponent >> htmlClassOfMetric [

	^ [ self metricStrategy classForValue: self metric ]
		  on: CPPSWrongMetricException
		  do:
			  [ ('/!\ ERROR /!\ In the dashboard a metric value is out of the scope of the metric. Metric : ' , (self translate: self metricStrategy metricName) , '; value : ' , self metric asString) record.
			  #unavailable
			  ]
]

{ #category : #initialization }
CPPSDashboardMetricComponent >> initialize [

	super initialize.
	self isSelected: false
]

{ #category : #accessing }
CPPSDashboardMetricComponent >> isSelected [

	^ isSelected
]

{ #category : #accessing }
CPPSDashboardMetricComponent >> isSelected: anObject [

	isSelected := anObject
]

{ #category : #accessing }
CPPSDashboardMetricComponent >> metric [

	^ metric
]

{ #category : #accessing }
CPPSDashboardMetricComponent >> metric: anObject [

	metric := anObject
]

{ #category : #accessing }
CPPSDashboardMetricComponent >> metricStrategy [

	^ metricStrategy
]

{ #category : #accessing }
CPPSDashboardMetricComponent >> metricStrategy: anObject [

	metricStrategy := anObject
]

{ #category : #rendering }
CPPSDashboardMetricComponent >> renderContentOn: html [

	| id |

	html div
		id: (id := html nextId);
		class: 'metricComponent';
		class: 'mdl-shadow--4dp'
		if: self isSelected;
		onClick: (self ajaxOnClickFor: html);
		with:
			[ self renderIconOn: html.
			html div
				class: 'value';
				with: [ self renderMetricAndLabelOn: html ]
			].
	html
		mdlLargeTooltipFor: id
		with: (self translate: self metricStrategy helpText)
]

{ #category : #rendering }
CPPSDashboardMetricComponent >> renderIconOn: html [

	| class |

	class := self htmlClassOfMetric.
	html div
		class: 'icon';
		class: class;
		with: [ html mdlIcon: (self class iconFor: class) ]
]

{ #category : #rendering }
CPPSDashboardMetricComponent >> renderMetricAndLabelOn: html [

	html div
		class: 'label';
		with:
			[ html span
				class: 'metricVal';
				with: (self metricStrategy printMetric: self metric).
			html text: (self translate: self metricStrategy metricName)
			]
]
