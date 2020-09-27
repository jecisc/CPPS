Class {
	#name : #CPPSCSCurrentTagPropagationStrategy,
	#superclass : #CPPSCSTagPropagationStrategy,
	#category : #'CPPS-Toolkit-ClassSplitter'
}

{ #category : #accessing }
CPPSCSCurrentTagPropagationStrategy class >> label [

	^ 'Current tag' french: 'Tag courant'
]

{ #category : #accessing }
CPPSCSCurrentTagPropagationStrategy class >> priority [

	^ 20
]

{ #category : #accessing }
CPPSCSCurrentTagPropagationStrategy class >> tagsToPropagateFor: aTagPropagationComponent [

	^ aTagPropagationComponent currentTag
		  ifNotNil: #asCollection
		  ifNil: [ self error: 'No current tag selected' ]
]
