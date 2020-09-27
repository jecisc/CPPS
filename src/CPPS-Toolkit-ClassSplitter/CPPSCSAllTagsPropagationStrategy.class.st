Class {
	#name : #CPPSCSAllTagsPropagationStrategy,
	#superclass : #CPPSCSTagPropagationStrategy,
	#category : #'CPPS-Toolkit-ClassSplitter'
}

{ #category : #accessing }
CPPSCSAllTagsPropagationStrategy class >> label [

	^ 'All tags' french: 'Tous les tags'
]

{ #category : #accessing }
CPPSCSAllTagsPropagationStrategy class >> priority [

	^ 10
]

{ #category : #accessing }
CPPSCSAllTagsPropagationStrategy class >> tagsToPropagateFor: aTagPropagationComponent [

	^ aTagPropagationComponent visualization obtain recursively all nodes flatCollectAsSet: [ :node | node entity tags ]
]
