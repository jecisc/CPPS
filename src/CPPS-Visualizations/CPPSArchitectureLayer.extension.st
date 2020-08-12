Extension { #name : #CPPSArchitectureLayer }

{ #category : #'*CPPS-Visualizations' }
CPPSArchitectureLayer >> asTLNode [

	^ TLCompositeNode new
		  entity: self;
		  addStyle: #layer;
		  addStyle: #transparent
		  if: [ self parent isNotNil and: [ self isTransparent ] ];
		  addInteraction: ((TLCustomWithParameterAction block:
					    [ :node :choice | 
					    choice = #Horizontal
						    ifTrue: [ node entity horizontal ]
						    ifFalse: [ node entity vertical ].
					    node childrenGroup requireUpdateAndLayoutApplication
					    ])
				   withMultipleChoices: [ :aNode | #( 'Horizontal' 'Vertical' ) ]
				   menu: 'Display') yourself;
		  addInteraction: ((TLCustomWithParameterAction block:
					    [ :node :choice | 
					    node addChildNode: (node entity addChild: (choice = #Layer
										      ifTrue: [ CPPSArchitectureLayer new ]
										      ifFalse: [ CPPSArchitectureComponent new ])) asTLNode
					    ])
				   withMultipleChoices: [ :aNode | #( 'Layer' 'Component' ) ]
				   menu: 'Add') yourself;
		  addInteraction: ((TLCustomAction
				    block:
					    [ :node | 
					    node entity remove.
					    node remove
					    ]
				    condition: [ :node | node entity hasParent ]) withMenu: 'Remove') yourself;
		  addInteraction: ((TLCustomWithParameterAction block:
					    [ :node :choice | 
					    node entity isTransparent: choice.
					    node generator
						    executeCallBack: [ :n |  ]
						    onDrawable: node
						    newTab: false
					    ])
				   withMultipleChoices: [ :aNode | #( true false ) ]
				   menu: 'Transparent');
		  yourself
]

{ #category : #'*CPPS-Visualizations' }
CPPSArchitectureLayer class >> backgroundColor [

	^ MDLColor blue alpha: 0.2
]

{ #category : #'*CPPS-Visualizations' }
CPPSArchitectureLayer class >> nameTranslations [

	^ Dictionary
		  with: #english -> 'Layer'
		  with: #french -> 'Couche'
]

{ #category : #'*CPPS-Visualizations' }
CPPSArchitectureLayer >> style [

	^ #layer
]
