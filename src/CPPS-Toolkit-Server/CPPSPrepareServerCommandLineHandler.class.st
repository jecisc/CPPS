"
Description
--------------------

Does the exact same job as the superclass, except that the image is saved and shutdown at  the end of the process.
Purpose is to generate the moose model once if project files are present, and then always re-open the image on top of this model.
Can be used to generate demo images.
"
Class {
	#name : #CPPSPrepareServerCommandLineHandler,
	#superclass : #CPPSLaunchServerCommandLineHandler,
	#category : #'CPPS-Toolkit-Server-Commands'
}

{ #category : #accessing }
CPPSPrepareServerCommandLineHandler class >> commandName [

	^ 'prepareServer'
]

{ #category : #accessing }
CPPSPrepareServerCommandLineHandler class >> description [

	^ 'If project files are present from a previous project generation, I generate a moose model from mse, save the image and quit.'
]

{ #category : #testing }
CPPSPrepareServerCommandLineHandler class >> requireDeploymentPassword [

	^ true
]

{ #category : #activation }
CPPSPrepareServerCommandLineHandler >> activate [

	super activate.
	self makeProjectPathRelative.
	Smalltalk
		snapshot: true
		andQuit: true
]
