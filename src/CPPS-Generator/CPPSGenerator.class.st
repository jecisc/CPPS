Class {
	#name : #CPPSGenerator,
	#superclass : #FamixMetamodelGenerator,
	#instVars : [
		'access',
		'attribute',
		'containerEntity',
		'globalVariable',
		'inheritance',
		'invocation',
		'method',
		'namespace',
		'package',
		'function',
		'type',
		'behavioralEntity',
		'namedEntity',
		'entity',
		'sourceAnchor',
		'sourcedEntity',
		'fileAnchor',
		'multipleFileAnchor'
	],
	#category : #'CPPS-Generator'
}

{ #category : #'world menu' }
CPPSGenerator class >> menuCommandOn: aBuilder [
	<worldMenu>
	(aBuilder item: #'Regenerate CPPS MM')
		order: 200;
		parent: #Moose;
		action: [ self generate ]
]

{ #category : #accessing }
CPPSGenerator class >> packageName [
	^ #'CPPS-Entities'
]

{ #category : #accessing }
CPPSGenerator class >> prefix [
	^ #CPPS
]

{ #category : #accessing }
CPPSGenerator class >> submetamodels [
	^ { FamixGenerator }
]

{ #category : #definition }
CPPSGenerator >> defineClasses [
	super defineClasses.
	
	entity := builder newClassNamed: #Entity.
	sourceAnchor := builder newClassNamed: #SourceAnchor.
	sourcedEntity := builder newClassNamed: #SourcedEntity.
	namedEntity := builder newClassNamed: #NamedEntity.

	fileAnchor := builder newClassNamed: #FileAnchor.
	multipleFileAnchor := builder newClassNamed: #MultipleFileAnchor.

	access := builder newClassNamed: #Access.
	attribute := builder newClassNamed: #Attribute.
	behavioralEntity := builder newClassNamed: #BehavioralEntity.
	containerEntity := builder newClassNamed: #ContainerEntity.
	function := builder newClassNamed: #Function.
	globalVariable := builder newClassNamed: #GlobalVariable.
	inheritance := builder newClassNamed: #Inheritance.
	invocation := builder newClassNamed: #Invocation.
	method := builder newClassNamed: #Method.
	namespace := builder newClassNamed: #Namespace.
	package := builder newClassNamed: #Package.
	type := builder newClassNamed: #Type.
]

{ #category : #definition }
CPPSGenerator >> defineHierarchy [
	super defineHierarchy.

	access --|> #TAccess.

	attribute --|> namedEntity.
	attribute --|> #TAttribute.
	attribute --|> #TWithClassScope.

	behavioralEntity --|> containerEntity.

	containerEntity --|> namedEntity.

	globalVariable --|> namedEntity.
	globalVariable --|> #TGlobalVariable.

	fileAnchor --|> sourceAnchor.
	fileAnchor --|> #TFileAnchor.
	fileAnchor --|> #TFileNavigation.

	self flag: #todo. "Clean after integration of: https://github.com/moosetechnology/Moose/pull/2149"
	function --|> behavioralEntity.
	function --|> #TFunction.
	function --|> #THasSignature.
	function --|> #TTypedEntity.

	inheritance --|> #TInheritance.

	invocation --|> #TInvocation.

	method --|> behavioralEntity.
	method --|> #TMethod.
	method --|> #THasModifiers.

	multipleFileAnchor --|> sourceAnchor.
	multipleFileAnchor --|> #TMultipleFileAnchor.

	namedEntity --|> sourcedEntity.
	namedEntity --|> #TNamedEntity.
	namedEntity --|> #TDependencyQueries.
	namedEntity --|> #TEntityMetaLevelDependency.

	namespace --|> containerEntity.
	namespace --|> #TNamespace.
	namespace --|> #TWithFunctions.

	package --|> containerEntity.
	package --|> #TPackage.
	package --|> #TWithFunctions.

	sourceAnchor --|> entity.
	sourceAnchor --|> #TSourceAnchor.

	sourcedEntity --|> entity.
	sourcedEntity --|> #TSourceEntity.

	type --|> containerEntity.
	type --|> #TType.
	type --|> #THasModifiers.
	type --|> #TWithMethods.
	type --|> #TPackageable.
]
