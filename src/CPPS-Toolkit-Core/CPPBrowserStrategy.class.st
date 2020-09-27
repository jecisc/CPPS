Class {
	#name : #CPPBrowserStrategy,
	#superclass : #CPPSBrowserStrategy,
	#classVars : [
		'CommonFilters'
	],
	#category : #'CPPS-Toolkit-Core'
}

{ #category : #testing }
CPPBrowserStrategy class >> allowToChangeVersionPath [

	^ true
]

{ #category : #testing }
CPPBrowserStrategy class >> allowToCreateQueryInPharo [

	^ true
]

{ #category : #accessing }
CPPBrowserStrategy class >> commonFilters [

	^ CommonFilters ifNil: [ CommonFilters := self defaultCommonFilters ]
]

{ #category : #accessing }
CPPBrowserStrategy class >> commonFilters: anObject [

	CommonFilters := anObject
]

{ #category : #accessing }
CPPBrowserStrategy class >> dashboardMetrics [

	^ super dashboardMetrics reject: [ :each | #( #commentedCodeRate #documentationRate #complexityRate ) includes: each ]
]

{ #category : #accessing }
CPPBrowserStrategy class >> defaultCommonFilters [

	^ super defaultCommonFilters
		  add: ((CPPSAdditifFilter named: ('Namespaces' french: 'Namespaces'))
				   modelQueryBlock: [ :model | model allModelNamespaces ];
				   priority: 240;
				   yourself);
		  add: ((CPPSAdditifFilter named: ('Packages' french: 'Packages'))
				   modelQueryBlock: [ :model | model allModelPackages ];
				   priority: 230;
				   yourself);
		  add: ((CPPSAdditifFilter named: ('Classes' french: 'Classes'))
				   modelQueryBlock: [ :model | model allModelClasses ];
				   isDefault;
				   priority: 220;
				   yourself);
		  add: ((CPPSAdditifFilter named: ('Methods' french: 'Méthodes'))
				   modelQueryBlock: [ :model | model allModelMethods ];
				   priority: 210;
				   yourself);
		  add: ((CPPSAdditifFilter named: ('Functions' french: 'Fonctions'))
				   modelQueryBlock: [ :model | model allModelFunctions ];
				   isDefault;
				   priority: 200;
				   yourself);
		  yourself
]

{ #category : #'tree-explorer' }
CPPBrowserStrategy class >> entitiesForTreeExplorerFrom: aModel [

	^ aModel allModelClasses
]

{ #category : #accessing }
CPPBrowserStrategy class >> languageClass [

	^ #cpp
]

{ #category : #accessing }
CPPBrowserStrategy class >> reset [

	<script>
	self metricCharts: nil.
	self commonFilters: nil
]

{ #category : #accessing }
CPPBrowserStrategy class >> selectorsForRepartitionInOverview [

	^ #( #allModelClasses #allModelMethods #allModelFunctions )
]

{ #category : #visualizations }
CPPBrowserStrategy class >> systemMapEntitiesFrom: aModel [

	^ aModel allModelClasses , aModel allModelFunctions
]

{ #category : #accessing }
CPPBrowserStrategy class >> urlOfLogo [

	^ CPPSLibrary urlOf: 'cppLogoPng'
]
