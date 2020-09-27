"
Description
----------------

I am a concret component allowing the user to create a query to naviguate  through the associations of the current result.
 
Internal Representation and Key Implementation Points.
---------------

    Instance Variables
	associations:		<aCollection> 	The kind of associations selected by the user for the navigation.
	direction:		<aSymbole>		A symbole representing the direction of the naviguation.

"
Class {
	#name : #CPPSQueryNavigationComponent,
	#superclass : #CPPSQueryComponent,
	#instVars : [
		'associations'
	],
	#category : #'CPPS-Toolkit-QueryBrowser-Core'
}

{ #category : #accessing }
CPPSQueryNavigationComponent class >> englishName [

	^ 'Navigation'
]

{ #category : #accessing }
CPPSQueryNavigationComponent class >> frenchName [

	^ 'Navigation'
]

{ #category : #accessing }
CPPSQueryNavigationComponent class >> priority [

	^ 60
]

{ #category : #accessing }
CPPSQueryNavigationComponent >> associationMap [

	^ associations ifNil: [ self resetAssociationMap ]
]

{ #category : #accessing }
CPPSQueryNavigationComponent >> associationsDivId [

	^ 'query_associations-list'
]

{ #category : #accessing }
CPPSQueryNavigationComponent >> directions [

	^ self modelClass directionStrategies
]

{ #category : #testing }
CPPSQueryNavigationComponent >> isUnavailable [

	^ self associationMap isEmpty
]

{ #category : #accessing }
CPPSQueryNavigationComponent >> modelClass [

	^ FQNavigationQuery
]

{ #category : #accessing }
CPPSQueryNavigationComponent >> query [

	"Select only checked associations"

	^ query
		  flag: #todo;
		  "Ugly. We should delegate to the hierarchy of strategies and ask them to select the right one for the selection."associationStrategy: (self associationMap
				   detect: #not
				   ifFound:
					   [ :a | 
					   | selected |

					   selected := (self associationMap select: #yourself) keys.
					   selected size = 1
						   ifTrue: [ MQNavigationSpecificAssociationStrategy association: selected anyOne ]
						   ifFalse: [ MQNavigationSpecificAssociationsStrategy associations: selected ]
					   ]
				   ifNone: [ "All associations were selected, thus we can use the way to query all dependencies." MQNavigationAllAssociationsStrategy new ]);
		  yourself
]

{ #category : #rendering }
CPPSQueryNavigationComponent >> renderAssociationsInputsOn: html [

	html formContainer
		id: #'query-manager-content__navigation-association';
		with:
			[ self associationMap keysDo:
					[ :assocType | 
					html div:
							[ html mdlCheckboxContainer
								for: html nextId;
								with:
									[ html mdlCheckbox
										id: html lastId;
										required;
										callback:
											[ :confirmation | 
											self associationMap
												at: assocType
												put: confirmation
											];
										value: (self associationMap at: assocType).
									html mdlCheckboxLabel: assocType englishName
									]
							]
					].
			html script:
				'var requiredCheckboxes=$("#query-manager-content__navigation-association").find(":checkbox[required]");requiredCheckboxes.change(function(){if(requiredCheckboxes.is(":checked")){requiredCheckboxes.removeAttr("required");}else {requiredCheckboxes.attr("required", "required");}}).trigger("change");'
					js
			]
]

{ #category : #rendering }
CPPSQueryNavigationComponent >> renderDirectionInputOn: html [

	html render: ((MDLSelectWidget
			  possibilities: self directions
			  inputLabel: 'Direction'
			  labelBlock: #label
			  callback: [ :aDirectionStrategy | self query direction: aDirectionStrategy ]
			  selectedObject: self query direction)
			 customizationBlock:
				 [ :textField :renderer | 
				 textField onChange: (html jQuery ajax serializeThis onComplete: (((html jQuery id: self associationsDivId) load html:
										    [ :htm | 
										    self resetAssociationMap.
										    self renderAssociationsInputsOn: htm
										    ]) onComplete: 'componentHandler.upgradeDom();'))
				 ];
			 yourself)
]

{ #category : #rendering }
CPPSQueryNavigationComponent >> renderFormContentOn: html [

	self renderDirectionInputOn: html.
	self renderRecursionInputOn: html.
	self renderSelfLoopsExclusionsInputOn: html.
	html div
		id: self associationsDivId;
		with: [ self renderAssociationsInputsOn: html ]
]

{ #category : #rendering }
CPPSQueryNavigationComponent >> renderRecursionInputOn: html [

	html formContainer:
		[ html radioGroup
			callback: [ :value | self query isLocal: value ];
			selected: self query isLocal;
			with:
				[ :group | 
				(OrderedDictionary
					 with: 'Local dependencies' -> true
					 with: 'Local and contained entities dependenices' -> false) keysAndValuesDo:
						[ :label :value | 
						html mdlRadioContainer
							rippleEffect;
							for: html nextId;
							with:
								[ group mdlRadioButton
									value: value;
									id: html lastId.
								html mdlRadioLabel: label
								]
						]
				]
		]
]

{ #category : #rendering }
CPPSQueryNavigationComponent >> renderSelfLoopsExclusionsInputOn: html [

	html mdlSwitchContainer
		rippleEffect;
		style: 'width: auto; margin-bottom: 20px;';
		for: html nextId;
		with:
			[ html mdlSwitch
				value: self query withoutSelfLoops;
				callback: [ :value | self query withoutSelfLoops: value ];
				id: html lastId.
			html mdlSwitchLabel: 'Reject dependencies from inside the entity'
			]
]

{ #category : #accessing }
CPPSQueryNavigationComponent >> resetAssociationMap [

	^ associations := (query direction availableAssociationsFor: self queryResult)
		                  inject: OrderedDictionary new
		                  into:
			                  [ :res :elem | 
			                  res
				                  at: elem
				                  put: (query
						                   ifNil: [ false ]
						                   ifNotNil: [ query hasAssociation: elem ]).
			                  res
			                  ]
]

{ #category : #accessing }
CPPSQueryNavigationComponent >> unavailableMessage [

	^ self
		  translate: 'No possible navigation for current entities'
		  french: 'Pas de navigation possible pour les entités actuelles'
]
