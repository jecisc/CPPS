Extension { #name : #MooseModel }

{ #category : #'*CPPS-Toolkit-Server' }
MooseModel >> postLoadingActionImportReplicationFrom: aFolder [

	<postLoadingMooseProjectActionPriority: 5>
	self importReplicationFrom: aFolder / 'duplication.ston'
]

{ #category : #'*CPPS-Toolkit-Server' }
MooseModel >> preLoadingActionExportReplicationTo: aFolder [

	"To speedup the reading during duplication computing, we detect all encoding before."

	<preLoadingMooseProjectActionPriority: 5>
	self exportReplicationTo: aFolder / 'duplication.ston'
]
