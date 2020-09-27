Class {
	#name : #CPPSGeneratorDeploymentPresenter,
	#superclass : #CPPSAbstractPresenter,
	#instVars : [
		'text'
	],
	#category : #'CPPS-Toolkit-Server'
}

{ #category : #specs }
CPPSGeneratorDeploymentPresenter class >> defaultSpec [
	^ SpBoxLayout newVertical
		add:
			(SpBoxLayout newHorizontal
				add: #text;
				yourself)
			withConstraints: [ :constraints | constraints height: self buttonHeight ];
		yourself
]

{ #category : #'instance creation' }
CPPSGeneratorDeploymentPresenter class >> open [

	<script>
	^ super open
]

{ #category : #initialization }
CPPSGeneratorDeploymentPresenter >> initializeWidgets [

	super initializeWidgets.
	text := self newText
		        text: 'Generation in progress...';
		        yourself
]

{ #category : #accessing }
CPPSGeneratorDeploymentPresenter >> text [

	^ text
]
