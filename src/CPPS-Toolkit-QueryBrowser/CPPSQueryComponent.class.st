"
Description
----------------

I am an abstract component managing the creation of queries. 

My subclasses should provide a way to the user to create and apply a query. 


Public API and Key Messages
---------------

- #query 		This method should return the query created by the user if there is one.
	
		 
Internal Representation and Key Implementation Points.
---------------

    Instance Variables
	query:		<aQuery>	The query the user is creating

"
Class {
	#name : #CPPSQueryComponent,
	#superclass : #CPPSComponent,
	#traits : 'CPPSTQueryBrowserComponent',
	#classTraits : 'CPPSTQueryBrowserComponent classTrait',
	#instVars : [
		'query'
	],
	#category : #'CPPS-Toolkit-QueryBrowser-Core'
}

{ #category : #accessing }
CPPSQueryComponent class >> components [

	^ (self allSubclasses reject: #isAbstract) sorted: #priority ascending
]

{ #category : #accessing }
CPPSQueryComponent class >> englishName [

	^ self subclassResponsibility
]

{ #category : #accessing }
CPPSQueryComponent class >> frenchName [

	^ self subclassResponsibility
]

{ #category : #testing }
CPPSQueryComponent class >> isAbstract [

	^ self = CPPSQueryComponent
]

{ #category : #accessing }
CPPSQueryComponent class >> multilanguageTitle [

	^ self englishName french: self frenchName
]

{ #category : #accessing }
CPPSQueryComponent class >> priority [

	^ self subclassResponsibility
]

{ #category : #rendering }
CPPSQueryComponent >> iconName [

	^ self modelClass mdlIconName
]

{ #category : #initialization }
CPPSQueryComponent >> initialize [

	super initialize.
	self query: self modelClass new
]

{ #category : #testing }
CPPSQueryComponent >> isUnavailable [

	^ false
]

{ #category : #accessing }
CPPSQueryComponent >> modelClass [

	"my implementation returns the associated class in model; FQPropertyQuery for CPPSQueryFilterComponent"

	^ self subclassResponsibility
]

{ #category : #accessing }
CPPSQueryComponent >> query [

	^ query
]

{ #category : #accessing }
CPPSQueryComponent >> query: anObject [

	query := anObject
]

{ #category : #rendering }
CPPSQueryComponent >> renderApplyButtonOn: html [

	| id |

	id := html mdlSpinner ensureId.
	html mdlSubmitButton
		callback: [ self useQuery: self query ];
		onClick: ((html jQuery: '#' , id) addClass: 'is-active') , ((html jQuery: '.mdl-button')
					 attributeAt: 'disabled'
					 put: 'disabled') , (html jQuery this removeAttribute: 'disabled');
		disabled: self isUnavailable;
		with: (self
				 english: 'Apply'
				 french: 'Appliquer')
]

{ #category : #rendering }
CPPSQueryComponent >> renderContentOn: html [

	html div:
		[ html headerContainer:
			[ html headline:
				[ html mdlIcon: self iconName.
				html space.
				html text: self title
				]
			].
		html form:
			[ html div
				class: #'text-center';
				with:
					[ self renderUnavailableMessage: html.
					self renderFormContentOn: html
					].
			html div
				class: #'text-right';
				with: [ self renderApplyButtonOn: html ]
			]
		]
]

{ #category : #rendering }
CPPSQueryComponent >> renderFormContentOn: html [

	self subclassResponsibility
]

{ #category : #rendering }
CPPSQueryComponent >> renderUnavailableMessage: html [

	self isUnavailable ifFalse: [ ^ self ].
	html mdlAlert
		beWarning;
		with: self unavailableMessage.
	html break
]

{ #category : #rendering }
CPPSQueryComponent >> title [

	^ self translate: self class multilanguageTitle
]

{ #category : #accessing }
CPPSQueryComponent >> unavailableMessage [

	^ self subclassResponsibility
]
