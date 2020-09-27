"
Description
--------------------

I am responsible for displaying an error report when the creation of a moose project version fails.
I am instanciated by a ""version creation progress component"", when specific errors are catched during creation.

"
Class {
	#name : #CPPSVersionCreationFailureComponent,
	#superclass : #CPPSComponent,
	#instVars : [
		'exception'
	],
	#category : #'CPPS-Toolkit-Core-Components'
}

{ #category : #accessing }
CPPSVersionCreationFailureComponent >> exception [

	^ exception
]

{ #category : #accessing }
CPPSVersionCreationFailureComponent >> exception: aVersionCreationError [

	exception := aVersionCreationError
]

{ #category : #rendering }
CPPSVersionCreationFailureComponent >> renderContentOn: html [

	html div
		class: 'smallComponent';
		with:
			[ html heading
				level: 2;
				with: 'Generation failure'.
			html div
				class: 'instruction';
				paddedForm;
				with:
					[ html div
						class: 'form-wrap';
						with:
							[ self renderReportOn: html.
							html form with:
									[ html mdlMajorButton
										callback: [ self answer: nil ];
										with: 'Back to configuration'
									]
							]
					]
			]
]

{ #category : #rendering }
CPPSVersionCreationFailureComponent >> renderReportOn: html [

	html paragraph:
		[ | stream |

		stream := self exception messageText readStream.
		html span: stream nextLine.
		html break.
		html span
			style: 'text-align: left;';
			with:
				[ [ stream atEnd ] whileFalse:
						[ html small: stream nextLine.
						html break
						]
				]
		].
	html paragraph:
		[ | stackDump |

		html span: 'Stack dump: '.
		stackDump := self exception dumpStack.
		html anchor
			document: stackDump contents
			mimeType: 'text/plain'
			fileName: stackDump asAbsolute basename;
			with: stackDump asAbsolute pathString
		]
]
