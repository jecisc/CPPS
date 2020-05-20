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

{ #category : #accessing }
CPPSModel >> allModelClasses [
	"a cpp model can have types or classes hence we show both: types and classes.
	we double check here that types shown have sourceanchor in addition to checking in the super class that these are stubs
	we try to avoid showing type alias in the interface"

	^ self lookUpPropertyNamed: #allModelClasses computedAs: [ self allTypes reject: [ :each | each isStub or: [ each hasSourceAnchor not ] ] ]
]

{ #category : #accessing }
CPPSModel >> allModelFunctions [
	^ self
		lookUpPropertyNamed: #allModelFunctions
		computedAs: [ 'Compute allModelFunctions' record.
			self allFunctions reject: #isStub ]
]

{ #category : #accessing }
CPPSModel >> computeAllModelBehaviourals [
	self flag: #todo.	"we remove empty functions because these are function pointers and we dont know yet how to show  these in the interface correctly"
	^ super computeAllModelBehaviourals reject: [ :each | each name isEmpty ]
]

{ #category : #accessing }
CPPSModel >> computeNumberOfLinesOfCode [
	"the number of lines of code for a C/C++ model is the number of lines in individual source (header and source) files."

	"sum of the number of lines in each file. fileAnchor with same file name are counted only once"

	^ ((self allUsing: FamixTFileAnchor) groupedBy: #fileName) values sum: [ :indexedFileAnchorGroup | indexedFileAnchorGroup anyOne completeText lineCount ]
]

{ #category : #accessing }
CPPSModel >> entitiesForReplicationDetection [
	"for duplication entities we have to assert that their start and end are known. for now the problem only occurs for Siemens ref file, we might need to make it common to all models"

	^ self allModelMethods asOrderedCollection, self allModelFunctions
]

{ #category : #accessing }
CPPSModel >> replicationDetectionConfiguration [
	^ FamixRepConfiguration
		sourcesCleaner: FamixRepCPPCleaner new
		minimumNumberOfReplicas: 2
		ofLines: 100
		ofCharacters: 80
]
