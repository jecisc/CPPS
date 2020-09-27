"
Description
--------------------

I am the admin browser to change parameters in application
"
Class {
	#name : #CPPSAdminBrowser,
	#superclass : #CPPSComponent,
	#instVars : [
		'rightManagementComponent',
		'resetGeneratorComponent'
	],
	#category : #'CPPS-Toolkit-Core-Core'
}

{ #category : #rendering }
CPPSAdminBrowser >> renderContentOn: html [

	html div
		class: #adminTools;
		with:
			[ html render: self rightManagementComponent.
			self renderGenrationResetOn: html
			]
]

{ #category : #rendering }
CPPSAdminBrowser >> renderGenrationResetOn: html [

	self server project generationInProgress ifFalse: [ ^ self ].
	html render: self resetGeneratorComponent
]

{ #category : #accessing }
CPPSAdminBrowser >> resetGeneratorComponent [

	^ resetGeneratorComponent ifNil: [ resetGeneratorComponent := CPPSResetGeneratorComponent new ]
]

{ #category : #accessing }
CPPSAdminBrowser >> resetGeneratorComponent: anObject [

	resetGeneratorComponent := anObject
]

{ #category : #accessing }
CPPSAdminBrowser >> rightManagementComponent [

	^ rightManagementComponent ifNil:
		  [ rightManagementComponent := CPPSRightsManagementComponent
			                              on: CPPSUserManager singleton users
			                              rights: self server rightsList
			                              groups: self server allGroups
		  ]
]

{ #category : #accessing }
CPPSAdminBrowser >> rightManagementComponent: anObject [

	rightManagementComponent := anObject
]
