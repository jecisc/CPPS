Class {
	#name : #CPPSSearchWithTagPanel,
	#superclass : #CPPSAbstractArchitectureRightPanel,
	#category : #'CPPS-Toolkit-ArchitectureSimulation'
}

{ #category : #search }
CPPSSearchWithTagPanel >> createResearchFilter: aString [

	| tag parentTag |

	tag := self tagModel tagNamed: aString.
	parentTag := self tagModel tagNamed: #researchs.
	parentTag color: MDLColor red. "Just in case it was not created before."
	[ parentTag addSubTag: tag.
	tag color: MDLColor red
	]
		on: FamixAlreadyExistTagFailure
		do:
			[ :error | 
			tag remove.
			tag := error existingTag
			].
	^ tag
]

{ #category : #accessing }
CPPSSearchWithTagPanel >> filteredTags [

	^ (self tagModel tagNamed: #researchs) children asOrderedCollection
]

{ #category : #accessing }
CPPSSearchWithTagPanel >> inputExplanation [

	| string englishText frenchText |

	string := '<strong>{1} :</strong>
<br><br>
{2}
<br><br>
{3}
<br><br>
{4}
<br><br>
{5}'.
	englishText := #( 'Search' 'Using this search field, you have the possibility to search for specific entities in the architecture.' 'It will create a concept with your input, tag all entities containing its name and highlight this concept.'
	                  'The name to search for must be at least 3 characters long.' 'The search work on the real entities but not on the concepts (tags) for now.' ).
	frenchText := #( 'Recherche' 'En utilisant ce champ de recherche, vous avez la possibilité de recherche des entités spécifiques dans l''architecture.' 'Un concept va être créé avec votre recherche, toutes les entités contenant son nom vont être tagées  et le concept sera mit en évidence dans l''architecture.'
	                 'Le nom de la recherche doit être d''au moins 3 caractères.' 'La recherche fonctionne actuellement sur les entités réelles et non sur les concepts (tags).' ).
	^ self
		  english: (string format: englishText)
		  french: (string format: frenchText)
]

{ #category : #javascript }
CPPSSearchWithTagPanel >> onInputChangeScriptFor: html [

	^ html jQuery ajax
		  serializeThis;
		  onComplete: ((html jQuery id: self searchTagListId) load
				   html: [ :r | self renderSearchListOn: r ];
				   onComplete: 'stopArchitectureSearchSpinner()' js)
]

{ #category : #rendering }
CPPSSearchWithTagPanel >> renderContentOn: html [

	html headerContainer:
		[ html headline: (self
				 english: 'New search'
				 french: 'Nouvelle recherche')
		].
	html div
		style: 'display: flex; padding: 0px 15px; align-items: center;';
		with: [ self renderSearchInputOn: html ].
	self renderPreviousSearchOn: html
]

{ #category : #rendering }
CPPSSearchWithTagPanel >> renderInputExplanationOn: html [

	html mdlButton
		id: html nextId;
		icon;
		with: [ html mdlIcon: #info_outline ].
	html
		mdlLargeTooltipFor: html lastId
		with: [ html html: self inputExplanation ]
]

{ #category : #rendering }
CPPSSearchWithTagPanel >> renderPreviousSearchOn: html [

	html headerContainer:
		[ html headline: (self
				 english: 'Previous search'
				 french: 'Recherches précédentes')
		].
	html div
		id: self searchTagListId;
		with: [ self renderSearchListOn: html ]
]

{ #category : #rendering }
CPPSSearchWithTagPanel >> renderSearchInputOn: html [

	self renderInputExplanationOn: html.
	html mdlTextFieldContainer
		expandable;
		style: 'width: 90%;';
		with:
			[ html mdlButton
				labelIcon;
				for: html nextId;
				with: [ html mdlIcon: 'search' ].
			html mdlTextFieldExpandableHolder:
				[ html mdlTextFieldInput
					class: 'architecture-search__input';
					callback: [ :filt | (filt isEmptyOrNil not and: [ filt size > 2 ]) ifTrue: [ self searchAndHightlightEntityFromFilter: filt ] ];
					onChange: (self onInputChangeScriptFor: html);
					id: html lastId.
				html mdlTextFieldLabel
					for: html lastId;
					with: (self
							 english: 'Search'
							 french: 'Recherche')
				]
			].
	self renderSearchSpinnerOn: html
]

{ #category : #rendering }
CPPSSearchWithTagPanel >> renderSearchListOn: html [

	html render: self tagListComponent
]

{ #category : #rendering }
CPPSSearchWithTagPanel >> renderSearchSpinnerOn: html [

	html mdlSpinner
		class: 'architecture-search__spinner';
		singleColor.
	html document addLoadScript: 'initArchitectureSearchSpinner();' js
]

{ #category : #search }
CPPSSearchWithTagPanel >> searchAndHightlightEntityFromFilter: aString [

	| tag |

	tag := self createResearchFilter: aString.
	self
		tagAllEntitiesIncluding: aString
		with: tag.
	self selectedTag: tag
]

{ #category : #accessing }
CPPSSearchWithTagPanel >> searchTagListId [

	^ #'architecture-tags__search-list-component'
]

{ #category : #search }
CPPSSearchWithTagPanel >> tagAllEntitiesIncluding: aString with: tag [

	"We do this instead of #allWithSubTypesOf: because this is faster and the research cannot be too slow."

	CPPSNamedEntity withMooseSubclasses do:
		[ :each | 
		(self model entityStorage selectAllWithType: each)
			select: [ :entity | entity name includesSubstring: aString ]
			thenDo: [ :entity | entity tagWith: tag ]
		]
]
