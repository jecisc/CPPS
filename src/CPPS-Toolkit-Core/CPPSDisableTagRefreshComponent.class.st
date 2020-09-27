"
Description
--------------------

I am a simple component to configure the option ""refresh on tag"". In the tools it is sometimes possible to tag entities with a ""current tag"". This refresh the page to keep a coherent state on the page. This option allow the user to disable this refresh.

"
Class {
	#name : #CPPSDisableTagRefreshComponent,
	#superclass : #CPPSComponent,
	#category : #'CPPS-Toolkit-Core-Components'
}

{ #category : #rendering }
CPPSDisableTagRefreshComponent >> renderContentOn: html [

	html div
		class: 'smallComponent';
		with:
			[ html heading
				level: 2;
				with: (self translate: ('Tag refresh' french: 'Rafraichissement au tagging')).
			self renderFormOn: html
			]
]

{ #category : #rendering }
CPPSDisableTagRefreshComponent >> renderDescriptionOn: html [

	html small
		mdlTypographyTextJustify;
		with: (self
				 english:
					 'When applying a tag on one entity, the page is usually refreshed to ensure the coherence of the page. For exemple, if a tagged entity is present in two places in the page, the refresh will ensure the tag appears on both places. This option can disable this refresh during a tagging session. Be careful: It will not ensure the coherence of the tags before a page refresh. This option will be reset each session.'
				 french:
					 'Durant l''application d''un tag sur une entité, la page est rafraichie pour s''assurer de la coherence de la page. Par exemple, si une entité tagguée est présente à deux endroits sur la page, le rafraichissement va assurer que le tag apparait aux deux endroits. Cette option permet de désactiver le rafraichissement durant une session de tag. Attention: La coherence des tags ne sera pas assurée avant de rafraichir la page. Cette option sera remise à zero avec chaque session.')
]

{ #category : #rendering }
CPPSDisableTagRefreshComponent >> renderFormOn: html [

	html form
		paddedForm;
		with:
			[ html div
				class: 'form-wrap';
				with:
					[ self renderDescriptionOn: html.
					html mdlCheckboxContainer
						for: html nextId;
						style: 'width: 200px; margin-top: 20px;';
						with:
							[ | session |

							session := self session.
							html mdlCheckbox
								id: html lastId;
								onChange: html jQuery ajax serializeThisWithHidden;
								callback: [ :confirmation | session refreshOnTagging: confirmation ];
								value: session refreshOnTagging.
							html mdlCheckboxLabel: (self
									 english: 'Activate tag refresh'
									 french: 'Activer le refresh au tagging')
							]
					]
			]
]
