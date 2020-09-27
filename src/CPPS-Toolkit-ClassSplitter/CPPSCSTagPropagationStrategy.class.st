Class {
	#name : #CPPSCSTagPropagationStrategy,
	#superclass : #Object,
	#traits : 'CPPSTGUIStrategy',
	#classTraits : 'CPPSTGUIStrategy classTrait',
	#category : #'CPPS-Toolkit-ClassSplitter'
}

{ #category : #accessing }
CPPSCSTagPropagationStrategy class >> tagsToPropagateFor: aTagPropagationComponent [

	^ self subclassResponsibility
]
