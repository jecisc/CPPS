"
Description
--------------------

Unlike my superclass, I do not catch Warning.\
To used by ""deployment"" images.
We do not want the user to be blocked each time a warning is raised.
"
Class {
	#name : #CPPSHtmlErrorHandler,
	#superclass : #WAHtmlErrorHandler,
	#category : #'CPPS-Toolkit-Core-Exceptions'
}

{ #category : #'exception handling' }
CPPSHtmlErrorHandler class >> exceptionSelector [

	"We don't want to catch warnings and deprecations"

	^ ExceptionSet new , Error
]
