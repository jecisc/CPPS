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
		'multipleFileAnchor',
		'association',
		'block',
		'condition',
		'conditional',
		'for',
		'if',
		'switch',
		'while'
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
	
	association := builder newClassNamed: #Association.
	entity := builder newClassNamed: #Entity.
	sourceAnchor := builder newClassNamed: #SourceAnchor.
	sourcedEntity := builder newClassNamed: #SourcedEntity.
	namedEntity := builder newClassNamed: #NamedEntity.

	fileAnchor := builder newClassNamed: #FileAnchor.
	multipleFileAnchor := builder newClassNamed: #MultipleFileAnchor.

	access := builder newClassNamed: #Access.
	attribute := builder newClassNamed: #Attribute.
	behavioralEntity := builder newClassNamed: #BehaviouralEntity.
	containerEntity := builder newClassNamed: #ContainerEntity.
	function := builder newClassNamed: #Function.
	globalVariable := builder newClassNamed: #GlobalVariable.
	inheritance := builder newClassNamed: #Inheritance.
	invocation := builder newClassNamed: #Invocation.
	method := builder newClassNamed: #Method.
	namespace := builder newClassNamed: #Namespace.
	package := builder newClassNamed: #Package.
	type := builder newClassNamed: #Type.
	

	block := builder newClassNamed: #Block.
	condition := builder newClassNamed: #Condition.
	conditional  := builder newClassNamed: #Conditional.
	for := builder newClassNamed: #For.
	if := builder newClassNamed: #If.
	switch := builder newClassNamed: #Switch.
	while := builder newClassNamed: #While
]

{ #category : #definition }
CPPSGenerator >> defineHierarchy [
	super defineHierarchy.

	access --|> association.
	access --|> #TAccess.
	
	association --|> sourcedEntity.
	association --|> #TAssociation.

	attribute --|> namedEntity.
	attribute --|> #TAttribute.
	attribute --|> #TWithClassScope.

	behavioralEntity --|> containerEntity.
	behavioralEntity --|> #TWithInvocations.
	behavioralEntity --|> #TInvocable.
	behavioralEntity --|> #TWithAccesses.
	behavioralEntity --|> #TWithStatements.

	containerEntity --|> namedEntity.

	globalVariable --|> namedEntity.
	globalVariable --|> #TGlobalVariable.

	fileAnchor --|> sourceAnchor.
	fileAnchor --|> #TFileNavigation.

	function --|> behavioralEntity.
	function --|> #TFunction.

	inheritance --|> association.
	inheritance --|> #TInheritance.

	invocation --|> association.
	invocation --|> #TInvocation.

	method --|> behavioralEntity.
	method --|> #TMethod.
	method --|> #THasModifiers.
	method --|> #TWithTypes.

	multipleFileAnchor --|> sourceAnchor.
	multipleFileAnchor --|> #TMultipleFileAnchor.

	namedEntity --|> sourcedEntity.
	namedEntity --|> #TNamedEntity.
	namedEntity --|> #TDependencyQueries.
	namedEntity --|> #TEntityMetaLevelDependency.

	namespace --|> containerEntity.
	namespace --|> #TNamespace.
	namespace --|> #TWithFunctions.
	namespace --|> #TScopingEntity.
	namespace --|> #TWithTypes.
	namespace --|> #TWithGlobalVariables.

	package --|> containerEntity.
	package --|> #TPackage.
	package --|> #TWithFunctions.
	package --|> #TPackageable.

	sourceAnchor --|> entity.
	sourceAnchor --|> #TSourceAnchor.

	sourcedEntity --|> entity.
	sourcedEntity --|> #TSourceEntity.

	type --|> containerEntity.
	type --|> #TClass.
	type --|> #THasModifiers.
	type --|> #TWithTypes.
	
	block --|> behavioralEntity.
	block testingSelector: #isCPPSBlock.
	
	condition --|> block.

	conditional --|> block.

	for --|> conditional.
	
	if --|> conditional.
	
	switch --|> conditional.
	
	while --|> conditional
]

{ #category : #definition }
CPPSGenerator >> defineRelations [
	((behavioralEntity property: #innerBlocks) comment: 'Blocks declared in this behavioural')
		*- ((block property: #parentBlock) comment: '"Block" containing this block. belongsTo implementation')
]
