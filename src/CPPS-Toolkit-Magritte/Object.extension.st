Extension { #name : #Object }

{ #category : #'*CPPS-Toolkit-Magritte-Components' }
Object >> asMagritteComponent [

	| description component |

	description := self magritteDescription
		               componentRenderer: CPPSAjaxMDLTableRenderer;
		               componentClass: CPPSContainerWithFeedbackComponent;
		               validator: CPPSValidatorVisitor;
		               yourself.
	component := description componentClass memento: (CPPSAjaxMemento
			              model: self
			              description: description).
	^ component
]
