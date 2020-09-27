"
Description
--------------------

I am a right management component for web tools.

I allow the users to manage the right of the users of the server but also the groups defined on the server. I also allow to attribut some groups to users.

Example
--------------------

			CPPSRightsManagementComponent
				on: CPPSUserManager singleton users
				rights: self server rightsList
				groups: self server allGroups
 
Internal Representation and Key Implementation Points.
--------------------

    Instance Variables
	groups:		<aCollection>	I am a collection of groups the users can get in.
	rights:		<aCollection>	I am the possible right that can have each user.
	users:		<aCollection>	I am the list of the users of the application.
"
Class {
	#name : #CPPSRightsManagementComponent,
	#superclass : #CPPSComponent,
	#instVars : [
		'users',
		'rights',
		'groups'
	],
	#category : #'CPPS-Toolkit-Core-Components'
}

{ #category : #'instance creation' }
CPPSRightsManagementComponent class >> on: users rights: rights groups: groups [

	^ self new
		  users: users;
		  rights: rights;
		  groups: groups;
		  yourself
]

{ #category : #accessing }
CPPSRightsManagementComponent >> groups [

	^ groups
]

{ #category : #accessing }
CPPSRightsManagementComponent >> groups: anObject [

	groups := anObject
]

{ #category : #rendering }
CPPSRightsManagementComponent >> renderAssignationOfUsers: usersCollection inGroups: groupsCollection on: html [

	html mdlTable with:
		[ html tableHead:
			[ html tableRow:
				[ html mdlTableHeading: (self translate: usersCollection anyOne class translatedKind).
				groupsCollection do: [ :aGroup | html mdlTableHeading: aGroup name ]
				]
			].
		html tableBody:
			[ usersCollection do:
				[ :anUser | 
				html tableRow:
					[ html mdlTableCell: anUser name.
					groupsCollection do:
						[ :aGroup | 
						html mdlTableCell:
							[ self
								switch: html
								group: aGroup
								forUser: anUser
							]
						]
					]
				]
			]
		]
]

{ #category : #rendering }
CPPSRightsManagementComponent >> renderContentOn: html [

	html mdlTabs
		rippleEffect;
		with:
			[ self renderTabHeaderOn: html.
			self renderTabContentOn: html
			]
]

{ #category : #rendering }
CPPSRightsManagementComponent >> renderPossessors: rightPossessors rights: rightsCollection on: html [

	html mdlTable with:
		[ html tableHead:
			[ html tableRow:
				[ html mdlTableHeading: (self translate: rightPossessors anyOne class translatedKind).
				rightsCollection do: [ :aRight | html mdlTableHeading: aRight asString ]
				]
			].
		html tableBody:
			[ rightPossessors do:
				[ :anUser | 
				html tableRow:
					[ html mdlTableCell: anUser name.
					rightsCollection do:
						[ :aRight | 
						html mdlTableCell:
							[ self
								switch: html
								right: aRight
								forUser: anUser
							]
						]
					]
				]
			]
		]
]

{ #category : #rendering }
CPPSRightsManagementComponent >> renderTabContentOn: html [

	html mdlTabsPanel
		id: 'userRight';
		isActive;
		with:
			[ self
				renderPossessors: self users
				rights: self rights
				on: html
			].
	html mdlTabsPanel
		id: 'groupRight';
		with:
			[ self
				renderPossessors: self groups
				rights: self rights
				on: html
			].
	html mdlTabsPanel
		id: 'groupManagement';
		with:
			[ self
				renderAssignationOfUsers: self users
				inGroups: self groups
				on: html
			]
]

{ #category : #rendering }
CPPSRightsManagementComponent >> renderTabHeaderOn: html [

	html mdlTabBar:
		[ html mdlTab
			isActive;
			url: '#userRight';
			with: (self
					 english: 'Users Rights'
					 french: 'Droits des Utilisateurs').
		html mdlTab
			url: '#groupRight';
			with: (self
					 english: 'Group Rights'
					 french: 'Droit des Groupes').
		html mdlTab
			url: '#groupManagement';
			with: (self
					 english: 'Group users'
					 french: 'Groupes d''utilisateur')
		]
]

{ #category : #accessing }
CPPSRightsManagementComponent >> rights [

	^ rights
]

{ #category : #accessing }
CPPSRightsManagementComponent >> rights: anObject [

	rights := anObject
]

{ #category : #rendering }
CPPSRightsManagementComponent >> switch: html group: aGroup forUser: anUser [

	| id |

	id := 'switch' , html nextId.
	html mdlSwitchContainer
		for: id;
		with:
			[ html mdlSwitch
				id: id;
				onClick: (html jQuery ajax callback:
							 [ self flag: #TODO. "Known bug if two admin connect at the same time, use Mutex"
							 anUser toggleGroup: aGroup
							 ]);
				value: (anUser isPartOf: aGroup).
			html mdlSwitchLabel
			]
]

{ #category : #rendering }
CPPSRightsManagementComponent >> switch: html right: aRight forUser: anUser [

	| id |

	id := 'switch' , html nextId.
	html mdlSwitchContainer
		for: id;
		with:
			[ html mdlSwitch
				id: id;
				onClick: (html jQuery ajax callback:
							 [ self flag: #TODO. "Known bug if two admin connect at the same time, use Mutex"
							 anUser toggleRight: aRight
							 ]);
				value: (anUser possessRight: aRight).
			html mdlSwitchLabel
			]
]

{ #category : #accessing }
CPPSRightsManagementComponent >> users [

	^ users
]

{ #category : #accessing }
CPPSRightsManagementComponent >> users: anObject [

	users := anObject
]
