Class {
	#name : #CPPSAssociation,
	#superclass : #CPPSSourcedEntity,
	#traits : 'FamixTAssociation',
	#classTraits : 'FamixTAssociation classTrait',
	#category : #'CPPS-Entities-Entities'
}

{ #category : #meta }
CPPSAssociation class >> annotation [

	<FMClass: #Association super: #CPPSSourcedEntity>
	<package: #'CPPS-Entities'>
	<generated>
	^self
]

{ #category : #'as yet unclassified' }
CPPSAssociation >> start [
	^ self sourceAnchor
		ifNotNil: #startPos
		ifNil: [ MooseUnavailableMetric ]
]

{ #category : #'as yet unclassified' }
CPPSAssociation >> stop [
	^ self sourceAnchor
		ifNotNil: #endPos
		ifNil: [ MooseUnavailableMetric ]
]
