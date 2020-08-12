Extension { #name : #FamixTHasModifiers }

{ #category : #'*CPPS-Entities' }
FamixTHasModifiers >> optionalDisplayInfo [
	self isPublic ifTrue: [ ^ 'public' ].
	
	self isPrivate ifTrue: [ ^ 'private' ].
	
	self isProtected ifTrue: [ ^ 'protected' ].
	
	self isPackage ifTrue: [ ^ 'package' ].
	
	^ nil
	
]
