Extension { #name : #MooseModel }

{ #category : #'*CPPS-Toolkit-Core' }
MooseModel >> buildCacheOfDashboardNumberOfLinesOfCodeRepartition [

	"In the dashboard we show graphs of the number of lines of code repartition. Since it might be long, we save the long part of the algorithme here."

	self class browserStrategy selectorsForRepartitionInOverview do: [ :selector | self numberOfLinesOfCodeRepartitionFor: selector ]
]

{ #category : #'*CPPS-Toolkit-Core' }
MooseModel >> buildCommentsPercentageCache [

	self allComments ifEmpty: [ ^ self ].
	(self allWithSubTypesOf: CPPSSourcedEntity) asOrderedCollection
		reject: #isStub
		thenDo: #commentsRatio
]

{ #category : #'*CPPS-Toolkit-Core' }
MooseModel >> cachesToBuild [

	^ OrderedCollection new
		  add: 'dead containers' -> [ self allModelContainers do: #isDead ];
		  add: 'rules' -> [ self rulesManager totalRemediationTime ];
		  add: 'model number of lines of code' -> [ self numberOfLinesOfCode ];
		  add: 'comments number of lines of code' -> [ self allComments do: #numberOfLinesOfCode ];
		  add: 'executables' -> [ self allModelBehaviourals ];
		  add: 'containers' -> [ self allModelContainers ];
		  add: 'methods' -> [ self allModelMethods ];
		  add: 'main entities' -> [ self allMainEntities ];
		  add: 'dead code rate' ->
				  [ self
					  deadCodeRate;
					  allBehaviouralsWithDeadCode
				  ];
		  add: 'duplication rate' ->
			  [ self
				  duplicationRate;
				  allBehaviouralsWithDuplicatedCode
			  ];
		  add: 'comment percentage' -> [ self buildCommentsPercentageCache ];
		  add: 'dashboard' -> [ self buildCacheOfDashboardNumberOfLinesOfCodeRepartition ];
		  add: 'allProviders/allClients' ->
			  [ (self allUsing: TEntityMetaLevelDependency) do:
				  [ :each | 
				  each
					  allProviders;
					  allClients
				  ]
			  ];
		  yourself
]

{ #category : #'*CPPS-Toolkit-Core' }
MooseModel >> numberOfLinesOfCodeRepartitionFor: selector [

	^ self
		  lookUpPropertyNamed: selector , 'NumberOfLinesOfCodeRepartition'
		  computedAs:
			  [ (self perform: selector)
				  collect: #numberOfLinesOfCode
				  as: SortedCollection
			  ]
]

{ #category : #'*CPPS-Toolkit-Core' }
MooseModel >> postLoadAction [

	"We build some cache to avoid to be too long on display"

	<postLoadingMooseProjectActionPriority: 10>
	self
		execute:
			[ self cachesToBuild
				do:
					[ :asso | 
					self
						execute: [ asso value value ]
						recordedAs: 'Building caches of ' , asso key
					]
				displayingProgress: [ :asso | 'Building caches of ' , asso key ]
			]
		recordedAs: 'Build caches'
]
