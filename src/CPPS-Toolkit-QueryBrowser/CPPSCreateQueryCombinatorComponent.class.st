"
Description
----------------

I am a concret component allowing the user to create a query OR, AND or NOT to combinate his current focusedQuery with other query.
"
Class {
	#name : #CPPSCreateQueryCombinatorComponent,
	#superclass : #CPPSComponent,
	#traits : 'CPPSTQueryBrowserComponent',
	#classTraits : 'CPPSTQueryBrowserComponent classTrait',
	#category : #'CPPS-Toolkit-QueryBrowser-Core'
}

{ #category : #callbacks }
CPPSCreateQueryCombinatorComponent >> actWith: aClassCombinatorQuery [

	self queryPath combineFocusedQuery: aClassCombinatorQuery
]

{ #category : #rendering }
CPPSCreateQueryCombinatorComponent >> iconName [

	^ #attach_file
]

{ #category : #rendering }
CPPSCreateQueryCombinatorComponent >> renderButtonOn: html [

	FQCompositeQuery allSubclassesDo:
		[ :subclass | 
		html mdlMajorAnchorButton
			callback: [ self actWith: subclass ];
			with: subclass compositeName
		]
]

{ #category : #rendering }
CPPSCreateQueryCombinatorComponent >> renderContentOn: html [

	html div:
		[ html headerContainer:
			[ html headline:
				[ html mdlIcon: self iconName.
				html space.
				html text: self title
				]
			].
		html form: [ html formContainer: [ self renderButtonOn: html ] ]
		]
]

{ #category : #accessing }
CPPSCreateQueryCombinatorComponent >> title [

	^ self
		  english: 'Compose'
		  french: 'Composer'
]
