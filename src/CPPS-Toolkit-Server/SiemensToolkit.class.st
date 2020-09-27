Class {
	#name : #SiemensToolkit,
	#superclass : #Object,
	#category : #'CPPS-Toolkit-Server'
}

{ #category : #initialization }
SiemensToolkit class >> customizeClassifier [

	"We want to classify methods of the form `jsBlaBlaOn:` in javascript protocol"

	MethodClassifier prefixMapping
		at: 'js'
		put: 'javascript'
]

{ #category : #accessing }
SiemensToolkit class >> defaultLoggerFileName [

	^ 'SiemensToolkit.log'
]

{ #category : #initialization }
SiemensToolkit class >> initialize [

	self
		customizeClassifier;
		initializeLogger.
	SessionManager default registerUserClassNamed: self name.
	self startUp: true
]

{ #category : #initialization }
SiemensToolkit class >> initializeLogger [

	TinyLogger default
		ensureStdoutLogger;
		ensureFileLoggerNamed: self defaultLoggerFileName;
		timestampFormatBlock:
			[ :aStream :timestamp | 
			timestamp asDate printOn: aStream.
			aStream << ' '.
			timestamp asTime
				print24: true
				on: aStream
			]
]

{ #category : #utilities }
SiemensToolkit class >> mainMenuCommandOn: aBuilder [

	<worldMenu>
	aBuilder item: #SiemensToolkit
]

{ #category : #'system startup' }
SiemensToolkit class >> startUp: isImageStarting [

	isImageStarting ifTrue:
		[ self
			execute:
				[ "Increase growth headroom. When the memory will need to grow, it will directly allocate more room."
				Smalltalk vm
					parameterAt: 25
					put: 33554432.

				"Increase shrinking threashold to shrink the memory less often"
				Smalltalk vm
					parameterAt: 24
					put: 67108864.

				"Change the full GC ratio to only GC when the heap grows by 70% instead of 33% before."
				Smalltalk vm
					parameterAt: 55
					put: 0.7
				]
			recordedAs: 'Tune GC parameters.'
		]
]
