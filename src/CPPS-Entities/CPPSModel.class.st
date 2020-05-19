Class {
	#name : #CPPSModel,
	#superclass : #MooseModel,
	#category : #'CPPS-Entities-Model'
}

{ #category : #accessing }
CPPSModel class >> allSubmetamodelsPackagesNames [
	<generated>
	^ #(#'Moose-Query' #'Famix-Traits')
]

{ #category : #meta }
CPPSModel class >> annotation [
	<FMClass: #CPPSModel super: #MooseModel>
	<package: #'CPPS-Entities'>
	<generated>
]

{ #category : #'as yet unclassified' }
CPPSModel >> allModelClasses [
	"a cpp model can have types or classes hence we show both: types and classes.
	we double check here that types shown have sourceanchor in addition to checking in the super class that these are stubs
	we try to avoid showing type alias in the interface"

	^ self lookUpPropertyNamed: #allModelClasses computedAs: [ self allTypes reject: [ :each | each isStub or: [ each hasSourceAnchor not ] ] ]
]

{ #category : #'as yet unclassified' }
CPPSModel >> allModelFunctions [
	^ self
		lookUpPropertyNamed: #allModelFunctions
		computedAs: [ 'Compute allModelFunctions' record.
			self allFunctions reject: #isStub ]
]
