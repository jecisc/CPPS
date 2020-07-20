"
Siemens architects use MagicDraw to model their architecture. We read their architecture description from xmi file exported from MagicDraw, create a dummy model and generate architecture from that model.
"
Class {
	#name : #CPPSArchitectureXMIImporter,
	#superclass : #XAMagicDrawToMooseGenerator,
	#instVars : [
		'architecture',
		'currentComponent',
		'cache',
		'tagRoot'
	],
	#category : #'CPPS-Architecture-Importer'
}

{ #category : #'as yet unclassified' }
CPPSArchitectureXMIImporter class >> generateArchitectureFrom: aFileReference model: aMooseModel tagModel: aTagModel [
	^ self new generateArchitectureFrom: aFileReference model: aMooseModel tagModel: aTagModel
]

{ #category : #'as yet unclassified' }
CPPSArchitectureXMIImporter class >> getModelFrom: aXMIFileReference [
	^ self new parseAndExtractModelFrom: aXMIFileReference
]

{ #category : #accessing }
CPPSArchitectureXMIImporter >> classes [
	"Returns all the model classes of the MooseModel."

	"Cache for performances."

	^ cache at: #classes
]

{ #category : #accessing }
CPPSArchitectureXMIImporter >> currentComponent [
	^ currentComponent
]

{ #category : #accessing }
CPPSArchitectureXMIImporter >> currentComponent: anObject [
	currentComponent := anObject
]

{ #category : #accessing }
CPPSArchitectureXMIImporter >> findEntityNamed: aName in: aCollection [
	^ aCollection
		detect: [ :entity | entity name = aName ]
		ifNone: [ [ tagRoot createSubTagNamed: aName ]
				on: FamixAlreadyExistTagFailure
				do: [ :err | err existingTag ] ]
]

{ #category : #architectureActions }
CPPSArchitectureXMIImporter >> generateArchitectureFrom: aFileReference model: aMooseModel tagModel: aTagModel [
	cache at: #classes put: aMooseModel allModelClasses asArray.
	cache at: #packages ifAbsentPut: aMooseModel allModelPackages asArray.
	factory := aMooseModel factory.

	tagRoot := aTagModel tagNamed: (self rootTagNamedAt: DateAndTime now).

	"add a new architecture first"
	architecture := CPPSArchitectureLayer newRoot.

	self parseAndExtractModelFrom: aFileReference.

	^ architecture
]

{ #category : #architectureActions }
CPPSArchitectureXMIImporter >> generateRootPackage [
	"I generate a package whose parent will be a moose model."

	self currentComponent: (CPPSArchitectureLayer named: self elementName linkedTo: (self findEntityNamed: self elementName in: self packages)).
	architecture addChild: self currentComponent
]

{ #category : #architectureActions }
CPPSArchitectureXMIImporter >> generateSubPackage [
	"I generate a package whose parent will be another package."

	| nextCurrentComponent |
	nextCurrentComponent := CPPSArchitectureLayer named: self elementName linkedTo: (self findEntityNamed: self elementName in: self packages).
	self currentComponent addChild: nextCurrentComponent.
	self tagEntityWithParentEntity: nextCurrentComponent.
	self currentComponent: nextCurrentComponent
]

{ #category : #initialization }
CPPSArchitectureXMIImporter >> initialize [
	super initialize.
	cache := Dictionary new.
	classPrefix := ''
]

{ #category : #accessing }
CPPSArchitectureXMIImporter >> packages [
	"Returns all the model packages from the model."

	"Cache for performances."

	^ cache at: #packages
]

{ #category : #parsing }
CPPSArchitectureXMIImporter >> parseAndExtractModelFrom: aFileReference [
	| umlModel |
	XMLParserLimits defaultReadLimit: 60000000.
	umlModel := (XMLDOMParser parse: aFileReference contents) root elements second.	"selecting just the <uml:Model> node with its children"

	self inferTypesIn: umlModel.

	CPPSArchitectureXAInstanceGeneratingVisitor visit: umlModel with: self.

	self resolveReferences
]

{ #category : #architectureActions }
CPPSArchitectureXMIImporter >> pointToModelEntity: architectureElement [
	| modelEntity |
	(modelEntity := self findEntityNamed: self elementName in: self classes) isTag
		ifTrue: [ architectureElement modelLink: modelEntity ]
		ifFalse: [ architectureElement linkTo: modelEntity ]
]

{ #category : #accessing }
CPPSArchitectureXMIImporter >> rootTagNamedAt: date [
	^ 'arch_{1}-{2}-{3}-{4}' format: {date dayOfMonth asString . date monthAbbreviation . date year asString . (date asTime print24 first: 8)}
]

{ #category : #architectureActions }
CPPSArchitectureXMIImporter >> tagEntityWithParentEntity: architectureElement [
	| parentEntity |
	parentEntity := architectureElement parent modelEntity.
	parentEntity isTag
		ifTrue: [ [ architectureElement modelEntity tagWith: parentEntity ]
				on: FamixTagOnTagFailure
				do: [ parentEntity addSubTag: architectureElement modelEntity ] ]
]

{ #category : #visiting }
CPPSArchitectureXMIImporter >> visitComment: aComment [
]

{ #category : #visiting }
CPPSArchitectureXMIImporter >> visitInheritance: aFamixInheritance [
]

{ #category : #visiting }
CPPSArchitectureXMIImporter >> visitModel: aMooseModel [
]

{ #category : #visiting }
CPPSArchitectureXMIImporter >> visitPackage: aPackage [
	"parent is not root model so it a child package"

	parent isMooseModel
		ifFalse: [ self generateSubPackage ]
		ifTrue: [ self generateRootPackage ]
]

{ #category : #visiting }
CPPSArchitectureXMIImporter >> visitType: aType [
	| architectureElement |
	architectureElement := CPPSArchitectureComponent named: self elementName.
	self pointToModelEntity: architectureElement.
	currentComponent addChild: architectureElement.
	self tagEntityWithParentEntity: architectureElement
]
