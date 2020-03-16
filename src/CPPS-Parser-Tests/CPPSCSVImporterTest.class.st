Class {
	#name : #CPPSCSVImporterTest,
	#superclass : #TestCase,
	#instVars : [
		'model'
	],
	#category : #'CPPS-Parser-Tests'
}

{ #category : #helpers }
CPPSCSVImporterTest >> missingDeclarationFile [
	^ '#Files
fileId,path
#Namespaces
id,name,parentId,file,line,column
#Types
id,name
#Classes
id,name,typeId,parentId,file,line,column,abstract,trivial,kind
#Funcs
id,name,typeId,parentId,file,line,column,lineE,vindex
#Vars
id,name,typeId,parentId,file,line,column
#Edges
sourceId,targetId,file,line,column,edgeType' 
]

{ #category : #helpers }
CPPSCSVImporterTest >> onlyDeclarationFile [
	^ '#Files
fileId,path
#Namespaces
id,name,parentId,file,line,column
#Packages
id,name,parentId
#Types
id,name
#Classes
id,name,typeId,parentId,file,line,column,abstract,trivial,kind,packageId
#Enums
id,name,typeId,parentId,file,line,column,packageId
#Funcs
id,name,typeId,parentId,file,line,column,lineE,vindex
#Vars
id,name,typeId,parentId,file,line,column
#Edges
sourceId,targetId,file,line,column,edgeType' 
]

{ #category : #running }
CPPSCSVImporterTest >> setUp [
	super setUp.
	model := CPPSModel new
]

{ #category : #tests }
CPPSCSVImporterTest >> testMissingDeclarationFile [
	self should: [ CPPSCSVImporter runOn: nil withRefFile: self missingDeclarationFile withModel: model ] raise: Error
]

{ #category : #tests }
CPPSCSVImporterTest >> testOnlyDeclarations [
	self shouldnt: [ CPPSCSVImporter runOn: nil withRefFile: self onlyDeclarationFile withModel: model ] raise: Error
]
