"
Description
--------------------

I am a composite query that will select entities based on exclusive disjonction. I'll apply my sub queries and select the entities that are present in only one of the results. (Equivalent to a XOR)
"
Class {
	#name : #FQExclusiveDisjonctionQuery,
	#superclass : #FQCompositeQuery,
	#category : #'Famix-Queries-Model-Composites'
}

{ #category : #accessing }
FQExclusiveDisjonctionQuery class >> compositeName [
	^ 'XOR'
]

{ #category : #run }
FQExclusiveDisjonctionQuery >> runOn: aMooseGroup collect: aBlock [
	| res |
	res := MooseGroup new.
	((self childrenQueries collect: aBlock)
		inject: Bag new
		into: [ :bag :coll | 
			bag
				addAll: coll;
				yourself ]) doWithOccurrences: [ :entity :occurences | occurences = 1 ifTrue: [ res add: entity ] ].
	^ res
]
