"
Description
--------------------

I am a component to display some filters the user can use to filter a list of entities.

I manage a list of filter that inherit from CPPSAbstractFilter. I use them to build a filtered list of entities a browser can use to help the user.

I am a sub component of the NavigationComponent in general.

Example
------------------
 
	CPPSFiltersComponent owner: aNavigationComponent

Internal Representation and Key Implementation Points.
------------------

    Instance Variables
	activeFilters:			<aCollection> 		I am a collection filters I need to use in order to build the list of filtered entities
	availableFilters:			<aCollection> 		I am a collection of filters available to the user

"
Class {
	#name : #CPPSFiltersComponent,
	#superclass : #CPPSAbstractNavigationSubComponent,
	#instVars : [
		'activeFilters',
		'availableFilters'
	],
	#category : #'CPPS-Toolkit-Core-Filters'
}

{ #category : #'instance creation' }
CPPSFiltersComponent class >> owner: aNavigationComponent [

	^ self basicNew
		  owner: aNavigationComponent;
		  initialize;
		  yourself
]

{ #category : #accessing }
CPPSFiltersComponent class >> title [

	^ 'Filters' french: 'Filtres'
]

{ #category : #accessing }
CPPSFiltersComponent >> activeFilters [

	^ activeFilters
]

{ #category : #accessing }
CPPSFiltersComponent >> activeFilters: anObject [

	activeFilters := anObject
]

{ #category : #'adding/removing' }
CPPSFiltersComponent >> addFilter: filter [

	self activeFilters add: filter.
	self update
]

{ #category : #'adding/removing' }
CPPSFiltersComponent >> addFilterAsAvailable: filter [

	self availableFilters add: filter
]

{ #category : #'adding/removing' }
CPPSFiltersComponent >> addSelectiveFilter: aCollectionOfEntities [

	self addFilter: (CPPSSelectifFilter new
			 entities: aCollectionOfEntities;
			 yourself)
]

{ #category : #accessing }
CPPSFiltersComponent >> ajaxBlock [

	^ self owner ajaxBlock
]

{ #category : #accessing }
CPPSFiltersComponent >> availableFilters [

	^ availableFilters
]

{ #category : #accessing }
CPPSFiltersComponent >> availableFilters: anObject [

	availableFilters := anObject.
	availableFilters do: [ :filter | filter model: self model ]
]

{ #category : #accessing }
CPPSFiltersComponent >> filteredEntities [

	^ (self activeFilters
		   inject: OrderedCollection new
		   into: [ :result :filter | filter filter: result ]) sorted: #name ascending
]

{ #category : #accessing }
CPPSFiltersComponent >> filtersToDisplay [

	^ (self isUsingDefaultFilters
		   ifTrue: [ self availableFilters ]
		   ifFalse: [ self activeFilters ]) sorted: [ :a :b | a priority > b priority ]
]

{ #category : #accessing }
CPPSFiltersComponent >> idOfImpactedList [

	^ self owner idOfImpactedList
]

{ #category : #initialization }
CPPSFiltersComponent >> initialize [

	super initialize.
	self selectDefaultFiltersAsActive
]

{ #category : #testing }
CPPSFiltersComponent >> isUsingDefaultFilters [

	^ self availableFilters includesAll: self activeFilters
]

{ #category : #accessing }
CPPSFiltersComponent >> owner: aNavigationComponent [

	super owner: aNavigationComponent.
	self availableFilters: self strategy defaultCommonFilters.
	self addFilterAsAvailable: ((CPPSAdditifFilter named: ('Concept' french: 'Concept'))
			 modelQueryBlock: [ :model | self tagModel tags ];
			 isDefault;
			 priority: 300;
			 yourself)
]

{ #category : #'adding/removing' }
CPPSFiltersComponent >> removeAllActiveFilters [

	self activeFilters removeAll.
	self update
]

{ #category : #'adding/removing' }
CPPSFiltersComponent >> removeFilter: filter [

	self activeFilters remove: filter.
	self activeFilters ifEmpty: [ self selectDefaultFiltersAsActive ].
	self update
]

{ #category : #rendering }
CPPSFiltersComponent >> renderChipFor: filter on: html [

	| chip |

	(chip := html mdlChip)
		class: #isActive
		if: (self activeFilters includes: filter).
	self isUsingDefaultFilters
		ifTrue:
			[ chip onClick: (html jQuery script:
					 [ :s | 
					 s
						 << ((html jQuery id: self owner id) load html:
									  [ :r | 
									  self toggleFilter: filter.
									  self owner renderComponentOn: r
									  ]);
						 << ((html jQuery id: self idOfImpactedList) load
								  html: [ :r | self ajaxBlock value: r ];
								  onComplete: ('initNestedList();componentHandler.upgradeDom();initFiltersChipsToAddSpinnerIn("' , self idOfImpactedList , '");') js)
					 ])
			]
		ifFalse: [ chip deleteCallback: [ self removeFilter: filter ] ].
	chip with:
		[ html mdlIcon
			chipIcon;
			with: filter iconName.
		html mdlChipText: (self translate: filter name)
		]
]

{ #category : #rendering }
CPPSFiltersComponent >> renderContentOn: html [

	self filtersToDisplay do:
		[ :filter | 
		self
			renderChipFor: filter
			on: html
		].
	html document addLoadScript: ('initFiltersChipsToAddSpinnerIn("' , self idOfImpactedList , '");') js
]

{ #category : #update }
CPPSFiltersComponent >> selectDefaultFiltersAsActive [

	activeFilters := self availableFilters select: #default.
	self update
]

{ #category : #'adding/removing' }
CPPSFiltersComponent >> toggleFilter: filter [

	self activeFilters
		detect: [ :e | e = filter ]
		ifFound: [ self removeFilter: filter ]
		ifNone: [ self addFilter: filter ]
]

{ #category : #update }
CPPSFiltersComponent >> update [

	self updateWith: self filteredEntities
]
