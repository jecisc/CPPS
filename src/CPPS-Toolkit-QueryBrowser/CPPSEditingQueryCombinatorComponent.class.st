Class {
	#name : #CPPSEditingQueryCombinatorComponent,
	#superclass : #CPPSCreateQueryCombinatorComponent,
	#category : #'CPPS-Toolkit-QueryBrowser-Core'
}

{ #category : #callbacks }
CPPSEditingQueryCombinatorComponent >> actWith: aClassCombinatorQuery [

	self useQuery: aClassCombinatorQuery new
]

{ #category : #accessing }
CPPSEditingQueryCombinatorComponent >> title [

	^ self
		  english: 'Edit query'
		  french: 'Changer la requête'
]
