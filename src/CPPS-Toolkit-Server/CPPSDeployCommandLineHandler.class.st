Class {
	#name : #CPPSDeployCommandLineHandler,
	#superclass : #CommandLineHandler,
	#category : #'CPPS-Toolkit-Server-Commands'
}

{ #category : #accessing }
CPPSDeployCommandLineHandler class >> commandName [

	^ 'deploy'
]

{ #category : #activation }
CPPSDeployCommandLineHandler >> activate [

	DUFacade
		cleanUpSystem;
		resetRepositoryUsersAndPasswords;
		closeAllWindows;
		setHostWindowNameTo: 'Inventive Toolkit';
		disableDeprecationWarnings.
	self shouldLetSourcesOpen ifFalse:
		[ DUFacade
			allowToRunWithoutChangesAndSources;
			forceOmissionOfStartupPreferences;
			removeDecompiler;
			removeTestPackages;
			removeRepositories;
			disableMonticelloCache;
			disableGlobalShortcuts;
			disableWorldMenu;
			disableProgressBarInteruptionButton;
			disableProcessInteruption;
			disableDragAndDropInWorld;
			disableEpicea;
			hideTaskbar;
			disableMorphHalos;
			addCommandLinesPassword: 'CPPSToolPassword'
			pepper: 'Toolkit'
			iterations: 10;
			activateServerMode;
			disableDebugger.
		self openCustomFullscreenPresenter
		].
	self garbageCollectToRemoveDeadObjects.
	Smalltalk
		snapshot: true
		andQuit: true
]

{ #category : #activation }
CPPSDeployCommandLineHandler >> garbageCollectToRemoveDeadObjects [

	'Clean memory (3 full GC)' record.
	3 timesRepeat: [ Smalltalk garbageCollect ]
]

{ #category : #activation }
CPPSDeployCommandLineHandler >> openCustomFullscreenPresenter [

	"Depending on the image kind (server/generator), open a window in fullscreen. The server will have a quit option for example and the generator only a logo and a text asking to wait."

	self subclassResponsibility
]

{ #category : #activation }
CPPSDeployCommandLineHandler >> shouldLetSourcesOpen [

	^ self hasOption: 'without-obfuscation'
]
