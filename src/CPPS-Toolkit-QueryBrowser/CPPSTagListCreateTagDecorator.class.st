Class {
	#name : #CPPSTagListCreateTagDecorator,
	#superclass : #CPPSTagListToolComponent,
	#instVars : [
		'syncComponent'
	],
	#category : #'CPPS-Toolkit-QueryBrowser-TagManager'
}

{ #category : #rendering }
CPPSTagListCreateTagDecorator >> componentTool [

	^ CPPSAddTagComponent withAction:
		  [ :html | 
		  (html jQuery id: #'tag-list-decorator') load
			  html:
				  [ :htm | 
				  html render: (CPPSTagCreatorComponent new ajaxSubmitBlock:
								   [ :r | 
								   r jQuery script:
										   [ :s | 
										   s
											   << ((r jQuery id: #'tag-list-decorator') load html:
														    [ :rend | 
														    self launchSync.
														    self syncComponent renderTagListOn: rend
														    ]);
											   << (self refreshCurrentTagScriptFrom: r)
										   ]
								   ])
				  ];
			  onComplete: 'componentHandler.upgradeDom();' js
		  ]
]

{ #category : #initialization }
CPPSTagListCreateTagDecorator >> launchSync [

	syncComponent synchElements
]

{ #category : #initialization }
CPPSTagListCreateTagDecorator >> launchSyncOn: aTagListComponant [

	syncComponent := aTagListComponant
]

{ #category : #accessing }
CPPSTagListCreateTagDecorator >> syncComponent [

	^ syncComponent
]
