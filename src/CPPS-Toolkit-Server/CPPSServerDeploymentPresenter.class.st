Class {
	#name : #CPPSServerDeploymentPresenter,
	#superclass : #CPPSAbstractPresenter,
	#instVars : [
		'quitButton',
		'openBrowserButton'
	],
	#category : #'CPPS-Toolkit-Server'
}

{ #category : #specs }
CPPSServerDeploymentPresenter class >> defaultSpec [
	^ SpBoxLayout newVertical
		add:
			(SpBoxLayout newHorizontal
				add: #quitButton;
				yourself)
			withConstraints: [ :constraints | constraints height: self buttonHeight ];
		yourself
]

{ #category : #'instance creation' }
CPPSServerDeploymentPresenter class >> open [

	<script>
	^ super open
]

{ #category : #initialization }
CPPSServerDeploymentPresenter >> initializePresenter [

	self flag: #todo. "This should probably move in another package"
	quitButton action:
		[ Smalltalk
			snapshot: false
			andQuit: true
		].
	openBrowserButton action: [ WebBrowser openOn: 'http://localhost:' , CPPSServer current configuration serverPort asString , '/siemensToolkit' ]
]

{ #category : #initialization }
CPPSServerDeploymentPresenter >> initializeWidgets [
	super initializeWidgets.
	openBrowserButton := self newButton
		label: 'Open Browser';
		icon:
			(self iconNamed: #morph);
		yourself.
	quitButton := self newButton
		label: 'Quit';
		icon:
			(self iconNamed: #smallExport);
		yourself.
	self focusOrder
		add: openBrowserButton;
		add: quitButton
]

{ #category : #accessing }
CPPSServerDeploymentPresenter >> openBrowserButton [

	^ openBrowserButton
]

{ #category : #accessing }
CPPSServerDeploymentPresenter >> quitButton [

	^ quitButton
]
