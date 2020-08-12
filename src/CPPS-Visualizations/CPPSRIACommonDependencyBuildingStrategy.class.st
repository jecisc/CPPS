"
Description
--------------------

I am responsible of an interaction of the RIA. My goal is to find the common dependencies at X sublevel of an entity and to show them in a visualisation without flooding the user with the non common dependencies.

I works with a RIA visualisation. I could be directly into this visu but this would add a lot of behaviour that would make the API hard to read. 
 
Internal Representation and Key Implementation Points.
--------------------

    Instance Variables
	allNodesCache:					<aCollection>			A cache of all the nodes of the visu. This is used because it takes time to get all the nodes and this is used a lot.
	commonDependenciesFound:		<aCollection>			The entities that are common to at least 2 roots entities.
	dependenciesTree:				<aKeyedTree>				A tree with all the dependences of the roots elements (Not just the commons)
	visu:								<aVisualisation>		A RefactoringImpactAnalyzer visualisation

"
Class {
	#name : #CPPSRIACommonDependencyBuildingStrategy,
	#superclass : #Object,
	#instVars : [
		'visu',
		'allNodesCache',
		'commonDependenciesFound',
		'dependenciesTree'
	],
	#category : #'CPPS-Visualizations-Visualizations-RefactoringImpactAnalyzer'
}

{ #category : #generation }
CPPSRIACommonDependencyBuildingStrategy class >> for: aVisu findUntil: aLevel [

	^ self new
		  visu: aVisu;
		  findUntil: aLevel
]

{ #category : #adding }
CPPSRIACommonDependencyBuildingStrategy >> addEntitesNeededFor: anEntity values: aCollection toCommonDependencyTree: aTree [

	| valuesToAdd |

	"We first check if there is children to show for the entity"
	valuesToAdd := aCollection
		               ifKeyedTree:
			               [ | newTree |

			               newTree := KeyedTree new.
			               aCollection keysAndValuesDo:
				               [ :key :values | 
				               self
					               addEntitesNeededFor: key
					               values: values
					               toCommonDependencyTree: newTree
				               ].
			               newTree
			               ]
		               ifNot: [ aCollection intersection: commonDependenciesFound ].

	"If there is children found, we add the entity because it will be needed to get to the children."
	valuesToAdd ifNotEmpty:
		[ ^ aTree
			  at: anEntity
			  put: valuesToAdd
		].

	"If the entity has no children, we add it only if it is a common dependency."
	(commonDependenciesFound includes: anEntity) ifTrue:
		[ aTree
			at: anEntity
			put: #(  )
		]
]

{ #category : #'common dependencies' }
CPPSRIACommonDependencyBuildingStrategy >> allConnectableNodesFor: anEntity until: aLevel into: aTree [

	aTree
		at: anEntity
		put: (aLevel = 1
				 ifTrue: [ "Au dernier niveau nous avons les feuilles qui ne sont pas des trees." visu getAllConnectableEntitiesFor: anEntity ]
				 ifFalse:
					 [ (visu getAllConnectableEntitiesFor: anEntity)
						 inject: KeyedTree new
						 into:
							 [ :tree :each | 
							 self
								 allConnectableNodesFor: each
								 until: aLevel - 1
								 into: tree.
							 tree
							 ]
					 ])
]

{ #category : #'common dependencies' }
CPPSRIACommonDependencyBuildingStrategy >> createTree: aCollection linkedTo: parentNode currentLevel: anInteger [

	aCollection
		ifKeyedTree:
			[ aCollection keysAndValuesDo:
				[ :key :values | 
				| keyNode |

				keyNode := self
					           getOrCreateNodeFor: key
					           atLevel: anInteger.
				visu
					createLinksFor: parentNode
					toNode: keyNode.
				self
					createTree: values
					linkedTo: keyNode
					currentLevel: anInteger + 1
				]
			]
		ifNot:
			[ visu
				createLinksFor: parentNode
				toNodes: (aCollection
						 collect:
							 [ :each | 
							 self
								 getOrCreateNodeFor: each
								 atLevel: anInteger
							 ]
						 as: TLDrawableCollection)
			]
]

{ #category : #'common dependencies' }
CPPSRIACommonDependencyBuildingStrategy >> finalTreeToCreate [

	| commonTree |

	commonTree := KeyedTree new.
	dependenciesTree keysAndValuesDo:
		[ :k :v | 
		self
			addEntitesNeededFor: k
			values: v
			toCommonDependencyTree: commonTree
		].
	^ commonTree
]

{ #category : #'common dependencies' }
CPPSRIACommonDependencyBuildingStrategy >> findUntil: aLevel [

	| bag |

	"First we begun to build a tree representing all the dependencies of our roots, not only the common."
	dependenciesTree := (visu groupAtLevel: 0) nodes
		                    inject: KeyedTree new
		                    into:
			                    [ :tree :node | 
			                    self
				                    allConnectableNodesFor: node entity
				                    until: aLevel
				                    into: tree.
			                    tree
			                    ].

	"Now we can find the common dependencies. The common dependencies will be those present in more than one branch originated from the roots of the tree. We need to be careful with those branches, we need to remove the duplicated elements, else we can detect a common dependency that does not exist. For example if our roots are A and B. If a call C that call D that call C, C will be detected but will not be a dependency of B. To correct this, I used a Set to remove the duplicated."
	bag := Bag new.
	dependenciesTree valuesDo:
		[ :values | 
		bag addAll: (self
				 flatten: values
				 into: Set new)
		].
	commonDependenciesFound := (bag select: [ :e | (bag occurrencesOf: e) > 1 ]) asSet.

	"Since it is long to get all the nodes of a visu and that we need to do it a lot, we save them as a cache. Do not forget to add entities to the cache when they are added to the visu."
	allNodesCache := visu obtain recursively nodes.

	"Now we recreate a tree containing only the node to really add to the visu and we create the missing nodes."
	self finalTreeToCreate keysAndValuesDo:
		[ :key :values | 
		self
			createTree: values
			linkedTo: ((visu groupAtLevel: 0) nodeForEntity: key)
			currentLevel: 1
		]
]

{ #category : #'common dependencies' }
CPPSRIACommonDependencyBuildingStrategy >> flatten: aTreeOrCollection into: res [

	"My goal is to flatten the tree to get all its elements."

	aTreeOrCollection
		ifKeyedTree:
			[ aTreeOrCollection keysAndValuesDo:
				[ :key :values | 
				res add: key.
				self
					flatten: values
					into: res
				].
			res
			]
		ifNot: [ res addAll: aTreeOrCollection ].
	^ res
]

{ #category : #'common dependencies' }
CPPSRIACommonDependencyBuildingStrategy >> getOrCreateNodeFor: key atLevel: anInteger [

	^ allNodesCache
		  detect: [ :node | node entity = key ]
		  ifNone:
			  [ | node |

			  node := visu
				          createNodeFor: key
				          atLevel: anInteger.
			  allNodesCache add: node.
			  allNodesCache addAll: node childrenGroup obtain recursively nodes.
			  node
			  ]
]

{ #category : #accessing }
CPPSRIACommonDependencyBuildingStrategy >> visu: anObject [

	visu := anObject
]
