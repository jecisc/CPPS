"
Description
-------------------

I am a component used to display a progress bar.

I will render a component with informations for the user. 

I will ask to the server each 5sec if I should still continue. If I should stop I will refresh the page.

In the future we can imagine that I will be able to display a real progress. 

Example 
----------------

	CPPSProgressComponent
		titled: Persistance of the current version' 
		message: 'The current version is been saved in order to persist your tags and architectures. This operation can takes several minutes.'
		isFinishBlock: [ CPPSServer isPersistanceInProgress not ] 
 
Internal Representation and Key Implementation Points.
---------------

    Instance Variables
	isFinishBlock:		<aBlock>	I am a block returning a boolean. I will return true if the component should refresh the page.
	message:			<aString>	I am a message to display to the user.
	title:				<aString> 	I am the title of the component. I will be display to the user.

"
Class {
	#name : #CPPSProgressComponent,
	#superclass : #CPPSComponent,
	#instVars : [
		'message',
		'title',
		'isFinishBlock'
	],
	#category : #'CPPS-Toolkit-Core-Components'
}

{ #category : #'instance creation' }
CPPSProgressComponent class >> titled: aString message: aString2 isFinishBlock: aBlock [

	^ self new
		  title: aString;
		  message: aString2;
		  isFinishBlock: aBlock;
		  yourself
]

{ #category : #javascript }
CPPSProgressComponent >> ajaxFor: aCallback on: html [

	^ 'window.setInterval(function(){$.ajax({ url: location.origin + "' , html actionUrl asString , '", type: ''POST'', data: { ' , aCallback asString , ' : "foo"}, success: function(boolean, status){ if(boolean) { location.reload() } } })}, 5000)'
]

{ #category : #accessing }
CPPSProgressComponent >> callback [

	^ WAValueCallback on:
		  [ :text | 
		  self requestContext respond:
			  [ :answer | 
			  answer
				  doNotCache;
				  contentType: WAMimeType applicationJson.
			  answer stream nextPutAll: (STONJSON toString: self isFinishBlock value)
			  ]
		  ]
]

{ #category : #accessing }
CPPSProgressComponent >> isFinishBlock [

	^ isFinishBlock
]

{ #category : #accessing }
CPPSProgressComponent >> isFinishBlock: anObject [

	isFinishBlock := anObject
]

{ #category : #accessing }
CPPSProgressComponent >> message [

	^ message
]

{ #category : #accessing }
CPPSProgressComponent >> message: anObject [

	message := anObject
]

{ #category : #rendering }
CPPSProgressComponent >> renderContentOn: html [

	| div |

	(div := html div)
		class: #progressComponent;
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
									html mdlProgressBar indeterminate
									]
							]
					]
			].
	html script: (self
			 ajaxFor: (div storeCallback: self callback)
			 on: html)
]

{ #category : #accessing }
CPPSProgressComponent >> title [

	^ title
]

{ #category : #accessing }
CPPSProgressComponent >> title: anObject [

	title := anObject
]
