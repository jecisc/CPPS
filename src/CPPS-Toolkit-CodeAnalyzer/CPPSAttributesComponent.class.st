"
Description
--------------------

I am a component to display attributes for an entity
"
Class {
	#name : #CPPSAttributesComponent,
	#superclass : #CPPSEntityCentricInfoComponent,
	#category : #'CPPS-Toolkit-CodeAnalyzer-RightPanels'
}

{ #category : #accessing }
CPPSAttributesComponent >> attributesListComponent [

	^ MDLSortableTable new
		  beCompact;
		  header: { 'Tag'. 'Attribute'. 'Accesses' };
		  rows:
			  [ (self entity
				   ifNil: [ #(  ) ]
				   ifNotNil: [ :ent | ent dataEntitiesForQuickTagging sorted: #name ascending ]) collect:
					  [ :ent | 
					  { 
						  (CPPSListIconComponent entityToTag: ent).
						  ent name.
						  ent incomingAccesses size }
					  ]
			  ];
		  noPagination;
		  yourself
]

{ #category : #testing }
CPPSAttributesComponent >> isUseful [

	^ self entity dataEntitiesForQuickTagging isNotEmpty
]

{ #category : #rendering }
CPPSAttributesComponent >> renderContentOn: html [

	html div
		class: 'attributes';
		class: 'infoComponent';
		style: self customStyle;
		with: [ html render: self attributesListComponent ]
]
