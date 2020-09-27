"
Description
--------------------

I am a Seaside element that will catch any exception during the rendering and show an error message without interupting the rendering.
"
Class {
	#name : #CPPSDivExceptionCatcherTag,
	#superclass : #WAGenericTag,
	#category : #'CPPS-Toolkit-Core-Exceptions'
}

{ #category : #accessing }
CPPSDivExceptionCatcherTag >> tag [

	^ #div
]

{ #category : #public }
CPPSDivExceptionCatcherTag >> with: anObject [

	[ super with: anObject ]
		on: Error
		do:
			[ :anError | 
			('ERROR IN INTERFACE. Here is the stack:
' , (anError signalerContext ifNil: [ thisContext ]) shortStack) withSystemLineEnding record.
			canvas render: 'Error : ' , anError asString
			]
]
