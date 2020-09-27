"
Description
--------------------

I am a component to display the code corresponding to the current query been executed on the model.
 
Internal Representation and Key Implementation Points.
--------------------

    Instance Variables
	codeDisplayer:		<aPrismCodeDisplayerComponent>		Component displaying the code of the query.

"
Class {
	#name : #CPPSQueryCodeRightPanel,
	#superclass : #CPPSQueryBrowserRightPanel,
	#instVars : [
		'codeDisplayer'
	],
	#category : #'CPPS-Toolkit-QueryBrowser-Core'
}

{ #category : #hooks }
CPPSQueryCodeRightPanel >> children [

	^ { self codeDisplayer }
]

{ #category : #rendering }
CPPSQueryCodeRightPanel >> codeDisplayer [

	^ codeDisplayer ifNil:
		  [ codeDisplayer := PrismComponent new
			                   sourceCode:
				                   [ self class compiler format: (String streamContents:
								                    [ :s | 
								                    s nextPutAll: 'codeFiltering: inputCollection ('.
								                    self modelQuery storeOn: s.
								                    s nextPutAll: ') runOn: inputCollection'
								                    ])
				                   ];
			                   language: #smalltalk;
			                   enableCopyOnClick
		  ]
]

{ #category : #rendering }
CPPSQueryCodeRightPanel >> renderContentOn: html [

	html render: self codeDisplayer
]

{ #category : #testing }
CPPSQueryCodeRightPanel >> shouldBeExtended [

	^ true
]
