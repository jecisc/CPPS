Class {
	#name : #CPPSModel,
	#superclass : #MooseModel,
	#instVars : [
		'rulesManager'
	],
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
CPPSModel >> allMainEntities [
	^ self
		lookUpPropertyNamed: #allMainEntities
		computedAs: [ 'Compute allMainEntities' record.
			self allModelBehaviourals , self allModelContainers ]
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

{ #category : #metrics }
CPPSModel >> complexityRate [
	^ self allModelBehaviourals average: #cyclomaticComplexity
]

{ #category : #'dead code' }
CPPSModel >> computeAllBehaviouralsWithDeadCode [
	'Compute computeAllBehaviouralsWithDeadCode' record.
	^ super computeAllBehaviouralsWithDeadCode
]

{ #category : #accessing }
CPPSModel >> computeAllModelBehaviourals [
	self flag: #todo.	"we remove empty functions because these are function pointers and we dont know yet how to show  these in the interface correctly"
	^ super computeAllModelBehaviourals reject: [ :each | each name isEmpty ]
]

{ #category : #accessing }
CPPSModel >> computeAllModelContainers [
	'Compute all model containers' record.
	^ (self allWithSubTypesOf: CPPSContainerEntity) reject: #isStub
]

{ #category : #accessing }
CPPSModel >> computeNumberOfLinesOfCode [
	"the number of lines of code for a C/C++ model is the number of lines in individual source (header and source) files."

	"sum of the number of lines in each file. fileAnchor with same file name are counted only once"

	^ ((self allUsing: FamixTFileAnchor) groupedBy: #fileName) values sum: [ :indexedFileAnchorGroup | indexedFileAnchorGroup anyOne completeText lineCount ]
]

{ #category : #actions }
CPPSModel >> detectEncodingOfAllFileAnchors [
	self execute: [ super detectEncodingOfAllFileAnchors ] recordedAs: 'Detection of the encodings of files'
]

{ #category : #accessing }
CPPSModel >> entitiesForReplicationDetection [
	"for duplication entities we have to assert that their start and end are known. for now the problem only occurs for Siemens ref file, we might need to make it common to all models"

	^ self allModelMethods asOrderedCollection, self allModelFunctions
]

{ #category : #actions }
CPPSModel >> exportToMSEStream: aStream [
	self execute: [ super exportToMSEStream: aStream ] recordedAs: 'Export of a ' , self class printString
]

{ #category : #actions }
CPPSModel >> importFromMSEStream: aStream [
	"In Synectique we constraints our models with assertions. During loading, the MSE parser does not guarantee the order of the loading and so the consistency of the model; that's why we have to ignore assertions during loading"

	self
		execute: [ [ super importFromMSEStream: aStream ]
				on: AssertionFailure
				do: [ :ex | ex resume ] ]
		recordedAs: 'Import of a ' , self class printString
]

{ #category : #initialization }
CPPSModel >> initialize [
	super initialize.
	self rulesManager: RuRulesManager new.
	self initializeDefaultRules
]

{ #category : #initialization }
CPPSModel >> initializeDefaultRules [
	self
		query: 'Long Methods/Functions'
		meaning: 'Functions and Methods should not be longer than 50 lines of code'
		as: [ :aModel | aModel allModelBehaviourals select: [ :each | each numberOfLinesOfCode > 50 ] ]
		remediationTime: 15 minute.
	self
		query: 'Complex functions'
		meaning: 'Functions should not be complex: cyclomatic complexity of more than 50'
		as: [ :aModel | aModel allModelBehaviourals select: [ :each | each cyclomaticComplexity > 50 ] ]
		remediationTime: 40 minute.
	self
		query: 'Duplication'
		meaning: 'Functions should not have duplicate code'
		as: [ :aModel | aModel allModelBehaviourals select: #containsReplicas ]
		remediationTime: 10 minute.
	self
		query: 'Function Parameters'
		meaning: 'Functions should not have more than 5 parameters'
		as: [ :aModel | aModel allModelBehaviourals select: [ :each | each numberOfParameters > 5 ] ]
		remediationTime: 10 minute.
	self
		query: 'Incoming Links'
		meaning: 'More than 50 incoming calls mean that function is too complex'
		as: [ :aModel | aModel allModelBehaviourals select: [ :each | each incomingInvocations size > 50 ] ]
		remediationTime: 10 minute.
	self
		query: 'No Useful Comments'
		meaning: 'Complex Functions without useful comments'
		as:
			[ :aModel | aModel allModelBehaviourals select: [ :each | each numberOfUsefulCommentLines = 0 & (each cyclomaticComplexity >= 10) & (each numberOfLinesOfCode > 30) ] ]
		remediationTime: 10 minute.
	self
		query: 'Source Comment Rate 2.0'
		meaning: 'Complex functions without enough comments (SCR 2.0 < 1)'
		as: [ :aModel | aModel allModelBehaviourals select: [ :each | each sourceCommentRateWithCleaning < 1 ] ]
		remediationTime: 10 minute
]

{ #category : #rules }
CPPSModel >> query: aLabelString meaning: aMeaningString as: aBlock remediationTime: time [
	^ self rulesManager
		addRule:
			(RuRule
				rule: aBlock
				label: aLabelString
				explanation: aMeaningString
				remediationTime: time)
]

{ #category : #accessing }
CPPSModel >> replicationDetectionConfiguration [
	^ FamixRepConfiguration
		sourcesCleaner: FamixRepCPPCleaner new
		minimumNumberOfReplicas: 2
		ofLines: 100
		ofCharacters: 80
]

{ #category : #rules }
CPPSModel >> rules [
	^ self rulesManager listAllRules
]

{ #category : #rules }
CPPSModel >> rulesManager [
	^ rulesManager
]

{ #category : #rules }
CPPSModel >> rulesManager: anObject [
	rulesManager := anObject.
	rulesManager model: self
]

{ #category : #rules }
CPPSModel >> technicalDebt [
	"The technical debt computed from the rules of the model in number of days. (the result should not be used directly, you should format it)"

	^ self rulesManager technicalDebt asDays
]
