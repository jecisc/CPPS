Class {
	#name : #CPPSContainerWithFeedbackComponent,
	#superclass : #MAContainerComponent,
	#category : #'CPPS-Toolkit-Magritte'
}

{ #category : #private }
CPPSContainerWithFeedbackComponent >> buildChildren [

	^ self magritteDescription
		  inject: Dictionary new
		  into:
			  [ :result :each | 
			  each isVisible ifTrue:
				  [ result
					  at: each
					  put: ((each perform: #mdlComponentClass)
							   memento: self memento
							   description: (each
									    validator: self magritteDescription validator;
									    yourself)
							   parent: self)
				  ].
			  result
			  ]
]

{ #category : #rendering }
CPPSContainerWithFeedbackComponent >> renderContentOn: html [

	html div
		id: 'debugging';
		with:
			[ self magritteDescription componentRenderer
				component: self
				on: html
			]
]
