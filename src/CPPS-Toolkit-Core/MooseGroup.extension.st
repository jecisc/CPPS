Extension { #name : #MooseGroup }

{ #category : #'*CPPS-Toolkit-Core' }
MooseGroup >> detectIndex: aBlock [

	^ self
		  detectIndex: aBlock
		  ifNone: [ NotFound signalFor: aBlock ]
]

{ #category : #'*CPPS-Toolkit-Core' }
MooseGroup >> detectIndex: aBlock ifNone: exceptionBlock [

	self doWithIndex: [ :each :index | (aBlock value: each) ifTrue: [ ^ index ] ].
	^ exceptionBlock value
]

{ #category : #'*CPPS-Toolkit-Core' }
MooseGroup >> indexOf: anElement ifAbsent: exceptionBlock [

	"Answer the index of the first occurence of anElement within the  
	receiver. If the receiver does not contain anElement, answer the 
	result of evaluating the argument, exceptionBlock."

	^ self
		  indexOf: anElement
		  startingAt: 1
		  ifAbsent: exceptionBlock
]

{ #category : #'*CPPS-Toolkit-Core' }
MooseGroup >> indexOf: anElement startingAt: start ifAbsent: exceptionBlock [

	"Answer the index of the first occurence of anElement after start
	within the receiver. If the receiver does not contain anElement, 
	answer the 	result of evaluating the argument, exceptionBlock."

	start to: self size do: [ :index | (self at: index) = anElement ifTrue: [ ^ index ] ].
	^ exceptionBlock value
]
