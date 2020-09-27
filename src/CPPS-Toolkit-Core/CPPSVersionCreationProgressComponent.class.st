"
Description
--------------------

I am responsible for displaying a progress bar while the creation of a moose project version  runs in background.
I trigger myself the version creation in my initialize method.

For now,  I simply display an ""indeterminate"" progress bar with fixed static message.

Later it would be nice to provide dynamic progression and messages.
In order to achieve, I  initialize a WAAjaxUpdaterDecoration decoration which is reponsible for  updating the page every second till reaching the end of the version creation.
Next step would be to implement the renderContentOn: ""dynamically"",  so that the progression and message are set according to the creation state
"
Class {
	#name : #CPPSVersionCreationProgressComponent,
	#superclass : #CPPSComponent,
	#instVars : [
		'message',
		'title',
		'answerComponent',
		'generationBlock',
		'isGenerationEnded',
		'progress'
	],
	#category : #'CPPS-Toolkit-Core-Components'
}

{ #category : #'instance creation' }
CPPSVersionCreationProgressComponent class >> titled: aString message: aString2 during: aBlock [

	^ self new
		  title: aString;
		  message: aString2;
		  generationBlock: aBlock;
		  yourself
]

{ #category : #accessing }
CPPSVersionCreationProgressComponent >> answerComponent [

	^ answerComponent
]

{ #category : #accessing }
CPPSVersionCreationProgressComponent >> answerComponent: aComponent [

	answerComponent := aComponent
]

{ #category : #rendering }
CPPSVersionCreationProgressComponent >> failureReportComponentFrom: anException [

	^ CPPSVersionCreationFailureComponent new
		  exception: anException;
		  yourself
]

{ #category : #accessing }
CPPSVersionCreationProgressComponent >> generationBlock [

	^ generationBlock
]

{ #category : #accessing }
CPPSVersionCreationProgressComponent >> generationBlock: aBlock [

	generationBlock := aBlock
]

{ #category : #initialization }
CPPSVersionCreationProgressComponent >> initialize [

	super initialize.
	[ [ self generationBlock value ]
		on: CPPSVersionCreationError
		do:
			[ :ex | 
			ex freeze.
			self answerComponent: (self failureReportComponentFrom: ex)
			].
	self isGenerationEnded: true
	] fork
]

{ #category : #accessing }
CPPSVersionCreationProgressComponent >> isGenerationEnded [

	^ isGenerationEnded ifNil: [ false ]
]

{ #category : #accessing }
CPPSVersionCreationProgressComponent >> isGenerationEnded: aBoolean [

	isGenerationEnded := aBoolean
]

{ #category : #accessing }
CPPSVersionCreationProgressComponent >> message [

	^ message
]

{ #category : #accessing }
CPPSVersionCreationProgressComponent >> message: aString [

	message := aString
]

{ #category : #accessing }
CPPSVersionCreationProgressComponent >> progress [

	^ progress ifNil: [ progress := 1 ]
]

{ #category : #accessing }
CPPSVersionCreationProgressComponent >> progress: aNumber [

	aNumber >= 100 ifTrue: [ ^ self ].
	progress := aNumber
]

{ #category : #rendering }
CPPSVersionCreationProgressComponent >> renderContentOn: html [

	| didCallback |

	html div
		class: #progressComponent;
		style: 'padding-top: 2em;';
		with:
			[ html div
				class: 'smallComponent';
				with:
					[ html heading
						level: 2;
						with: self title.
					html div
						paddedForm;
						with:
							[ html div
								class: 'form-wrap';
								with:
									[ html div
										class: #instruction;
										with: self message.
									html mdlProgressBar
										indeterminate;
										id: 'bufferingProgressBar'.
									html div
									"To be uncommented the day we will display a real progression.
This script set the value of the progress bar defined above"
									"html script:
	'
	document.querySelector(''#bufferingProgressBar'').addEventListener(''mdl-componentupgraded'', function() {
		this.MaterialProgress.setProgress(', self progress asString,');
	});' "
									]
							]
					]
			].
	html script: 'componentHandler.upgradeDom();'.

	"Next one is a hacky script that run in background every second to check if the the generation is ended.
If yes, it will callback"
	didCallback := false.
	html div script: (html jQuery this load
			 html:
				 [ :h | 
				 didCallback ifFalse:
						 [ self isGenerationEnded ifTrue:
								 [ didCallback := true.
								 h script: 'clearInterval(updateInterval)'.
								 h script: (h javascript callback:
												  [ self project generationInProgress: false.
												  self answer: self answerComponent
												  ])
								 ]
						 ]
				 ];
			 interval: 5000;
			 assignTo: 'updateInterval')
]

{ #category : #accessing }
CPPSVersionCreationProgressComponent >> title [

	^ title
]

{ #category : #accessing }
CPPSVersionCreationProgressComponent >> title: aString [

	title := aString
]
