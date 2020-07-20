"
Description
--------------------

I am a detector of diff between two architectures. 
I store additions/deletions/modifications between two architectures.

The algorithm is implemented as tree matching between two architecture: a source architecture and an evolved architecture.
It compares nodes at the same level and if matching name find, it goes to match their children recursively.

It returns a CPPSArchitectureUpdate.

Examples
--------------------

	CPPSArchitectureDiff updatesBetween: sourceArchitecture and: evolvedArchitecture
 
Internal Representation and Key Implementation Points.
--------------------

    Instance Variables
	updates:		<CPPSArchitectureUpdate>		List of changes detected between both architectures.
"
Class {
	#name : #CPPSArchitectureDiff,
	#superclass : #Object,
	#instVars : [
		'updates'
	],
	#category : #'CPPS-Architecture-Diff'
}

{ #category : #public }
CPPSArchitectureDiff class >> updatesBetween: sourceArchitecture and: evolvedArchitecture [
	^ self new
		compare: sourceArchitecture with: evolvedArchitecture;
		updates
]

{ #category : #comparison }
CPPSArchitectureDiff >> compare: sourceArchitecture with: evolvedArchitecture [
	evolvedArchitecture == sourceArchitecture ifTrue: [ ^ self ].

	self compareEntity: sourceArchitecture with: evolvedArchitecture.
	self markMovedNodeIn: evolvedArchitecture
]

{ #category : #comparison }
CPPSArchitectureDiff >> compareEntity: aSourceArchitectureElement with: anEvolvedArchitectureElement [
	"report any addition on evolved elements"

	self findAdditionsIn: anEvolvedArchitectureElement comparingWith: aSourceArchitectureElement.

	"And then find all the element deletions i.e. nodes present in source not found in target"
	aSourceArchitectureElement children
		do: [ :sourceAchitectureChild | 
			anEvolvedArchitectureElement children
				detect: [ :matchingArchitectureChild | "if found a matching node, compare their children" sourceAchitectureChild nameMatches: matchingArchitectureChild ]
				ifFound: [ :matchingArchitectureChild | self compareEntity: sourceAchitectureChild with: matchingArchitectureChild ]
				ifNone: [ updates addDeletedNode: (CPPSArchitectureDeletion deletedElement: sourceAchitectureChild) ] ]
]

{ #category : #comparison }
CPPSArchitectureDiff >> findAdditionsIn: anEvolvedArchitectureElement comparingWith: aSourceArchitectureElement [
	"report all additions on the new architecture, comparing its elements with source architecture, this way we report additions in the same pass"

	(anEvolvedArchitectureElement children
		select: [ :aRefChild | aSourceArchitectureElement children noneSatisfy: [ :aSourceChild | aRefChild nameMatches: aSourceChild ] ])
		do: [ :addedChild | updates addAddedNode: addedChild ]
]

{ #category : #initialization }
CPPSArchitectureDiff >> initialize [
	super initialize.
	updates := CPPSArchitectureUpdate new
]

{ #category : #comparison }
CPPSArchitectureDiff >> markMovedNodeIn: anArchitectureElement [
	anArchitectureElement children
		do: [ :matchingArchitectureChild | 
			updates deletions
				detect: [ :deletedChild | deletedChild modelEntity = matchingArchitectureChild modelEntity ]
				ifFound: [ :deletedEntity | 
					updates deletions removeAt: (updates deletions indexOf: deletedEntity).
					updates addModifiedNode: matchingArchitectureChild ].
			self markMovedNodeIn: matchingArchitectureChild ]
]

{ #category : #query }
CPPSArchitectureDiff >> updates [
	^ updates
]
