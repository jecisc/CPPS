Extension { #name : #CPPSArchitectureComponent }

{ #category : #'*CPPS-Visualizations' }
CPPSArchitectureComponent >> asTLNode [

	^ TLSimpleNode new
		  entity: self;
		  style: #component;
		  addInteraction: ((TLCustomAction block:
					    [ :node | 
					    node entity remove.
					    node remove
					    ]) withMenu: 'Remove');
		  yourself
]

{ #category : #'*CPPS-Visualizations' }
CPPSArchitectureComponent class >> backgroundColor [

	^ MDLColor
		  tint: #yellow
		  code: '200'
]

{ #category : #'*CPPS-Visualizations' }
CPPSArchitectureComponent class >> nameTranslations [

	^ Dictionary
		  with: #english -> 'Component'
		  with: #french -> 'Composant'
]

{ #category : #'*CPPS-Visualizations' }
CPPSArchitectureComponent >> style [

	^ #component
]
