Class {
	#name : #CPPSDeployGeneratorCommandLineHandler,
	#superclass : #CPPSDeployCommandLineHandler,
	#category : #'CPPS-Toolkit-Server-Commands'
}

{ #category : #accessing }
CPPSDeployGeneratorCommandLineHandler class >> commandName [

	^ 'deployGenerator'
]

{ #category : #activation }
CPPSDeployGeneratorCommandLineHandler >> openCustomFullscreenPresenter [

	CPPSGeneratorDeploymentPresenter openFull
]
