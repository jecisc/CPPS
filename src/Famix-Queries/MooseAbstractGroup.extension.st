Extension { #name : #MooseAbstractGroup }

{ #category : #'*Famix-Queries' }
MooseAbstractGroup >> allAssociationTypes [
	^ self lookUpPropertyNamed: #allAssociationTypes computedAs: [ (self collectAsSet: #class) select: [ :each | each isComposedBy: TAssociationMetaLevelDependency ] ]
]

{ #category : #'*Famix-Queries' }
MooseAbstractGroup >> allEntityTypes [
	^ self lookUpPropertyNamed: #allEntityTypes computedAs: [ (self collectAsSet: #class) select: [ :each | each isComposedBy: TEntityMetaLevelDependency ] ]
]

{ #category : #'*Famix-Queries' }
MooseAbstractGroup >> allWithTypeWithoutStub: aSmalltalkClass [
	^ self
		lookUpPropertyNamed: aSmalltalkClass asString , 'WithoutStub'
		computedAs: [ (self allWithType: aSmalltalkClass) reject: #isStub ]
]
