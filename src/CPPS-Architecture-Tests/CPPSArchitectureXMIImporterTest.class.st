Class {
	#name : #CPPSArchitectureXMIImporterTest,
	#superclass : #TestCase,
	#instVars : [
		'architecture'
	],
	#category : #'CPPS-Architecture-Tests-Importers'
}

{ #category : #helpers }
CPPSArchitectureXMIImporterTest >> classMocks [
	| mocks mock |
	mocks := OrderedCollection new.
	mock := Mock new.
	mock stub name willReturn: 'B2B0'.
	mocks add: mock.
	mock := Mock new.
	mock stub name willReturn: 'B2B1'.
	mocks add: mock.
	mock := Mock new.
	mock stub name willReturn: 'CU1ContentHandlerBase'.
	mocks add: mock.
	mock := Mock new.
	mock stub name willReturn: 'CU1FileHandleBase'.
	mocks add: mock.
	
	^ mocks
]

{ #category : #helpers }
CPPSArchitectureXMIImporterTest >> mockModel [
	| mock |
	mock := Mock new.
	mock stub allPackages willReturn: self packageMocks.
	mock stub allModelClasses willReturn: self classMocks.
	mock stub factory willReturn: CPPSModel factory.

	^ mock
]

{ #category : #helpers }
CPPSArchitectureXMIImporterTest >> packageMocks [
	| mocks mock|
	mocks := OrderedCollection new.
	mock := Mock new.
	mock stub name willReturn: 'NIVEAU1'.
	mocks add: mock.
	mock := Mock new.
	mock stub name willReturn: 'NIVEAU2'.
	mocks add: mock.
	
	^ mocks 
]

{ #category : #running }
CPPSArchitectureXMIImporterTest >> setUp [
	super setUp.
	architecture := CPPSArchitectureXMIImporter generateArchitectureFrom: self xmi model: self mockModel tagModel: FamixTagModel new
]

{ #category : #tests }
CPPSArchitectureXMIImporterTest >> testArchitectureChildren [
	
	self assert: architecture children size equals: 2
]

{ #category : #tests }
CPPSArchitectureXMIImporterTest >> testClassNumberAndPosition [
	| class |
	class := architecture children flatCollect: [ :each | each children flatCollect: [ :e | e children reject: [ :child | child isKindOf: CPPSArchitectureLayer ] ] ].
	self assert: class size equals: 4
]

{ #category : #tests }
CPPSArchitectureXMIImporterTest >> testDeep3 [
	| deep3 |
	deep3 := architecture children flatCollect: [ :each | each children flatCollect: [ :e | e children ] ].
	self assert: (deep3 reject: [ :child | child isKindOf: CPPSArchitectureLayer ]) size equals: 4.
	self assert: (deep3 select: [ :child | child isKindOf: CPPSArchitectureLayer ]) first name equals: 'B11O89UnitTest'
]

{ #category : #tests }
CPPSArchitectureXMIImporterTest >> testLastDeep [
	| deep3Layer deep4 |
	deep3Layer := architecture children
		flatCollect: [ :each | each children flatCollect: [ :e | e children select: [ :child | child isKindOf: CPPSArchitectureLayer ] ] ].
	deep4 := deep3Layer flatCollect: [ :each | each children ].
	self assert: (deep4 reject: [ :child | child isKindOf: CPPSArchitectureLayer ]) size equals: 2.
	self assert: (deep4 select: [ :child | child isKindOf: CPPSArchitectureLayer ]) size equals: 0
]

{ #category : #tests }
CPPSArchitectureXMIImporterTest >> testTagDeep [
	| deep3Layer deep3 aTagClass |
	deep3 := architecture children flatCollect: [ :each | each children flatCollect: [ :e | e children ] ].
	deep3Layer := deep3 select: [ :child | child isKindOf: CPPSArchitectureLayer ].
	aTagClass := (deep3Layer flatCollect: [ :each | each children ]) first.
	"self assert: aClass modelLink entity allTags first name equals: ''."
	self flag: 'wait Cyril to correct mock of entity'.
	self assert: aTagClass modelEntity parentTag equals: deep3Layer first modelEntity
]

{ #category : #helpers }
CPPSArchitectureXMIImporterTest >> xmi [
  ^ '<?xml version=''1.0'' encoding=''UTF-8''?>

<xmi:XMI xmlns:uml=''http://www.omg.org/spec/UML/20110701'' xmlns:xmi=''http://www.omg.org/spec/XMI/20110701'' xmlns:Validation_Profile=''http://www.magicdraw.com/schemas/Validation_Profile.xmi'' xmlns:StandardProfileL3=''http://www.omg.org/spec/UML/20110701/StandardProfileL3'' xmlns:DSL_Customization=''http://www.magicdraw.com/schemas/DSL_Customization.xmi'' xmlns:MagicDraw_Profile=''http://www.omg.org/spec/UML/20110701/MagicDrawProfile''>
<xmi:Documentation>
	<xmi:exporter>MagicDraw UML</xmi:exporter>
	<xmi:exporterVersion>17.0.4</xmi:exporterVersion>
</xmi:Documentation>

<uml:Model xmi:type="uml:Model" xmi:id="NCK_id_0" name="NCK@@/NCK103">
<packagedElement xmi:type="uml:Package" xmi:id="nck_p_/NIVEAU1" name="NIVEAU1">
<ownedComment xmi:type="uml:Comment" xmi:id="nck_cm_nck_p_/NIVEAU1" body="@FG: @MA:@New Name: @Comment:"> 	<annotatedElement xmi:idref="nck_p_/NIVEAU1"/>
</ownedComment>
<packagedElement xmi:type="uml:Package" xmi:id="nck_p_NIVEAU1/B11O89" name="B11O89"><ownedComment xmi:type="uml:Comment" xmi:id="nck_cm_nck_p_NIVEAU1/B11O89" body="@FG:
@MA:
@New Name:
@Comment:
"><annotatedElement xmi:idref="nck_p_NIVEAU1/B11O89"/></ownedComment><packagedElement xmi:type="uml:Package" xmi:id="nck_p_NIVEAU1/B11O89/B11O89UnitTest" name="B11O89UnitTest"><ownedComment xmi:type="uml:Comment" xmi:id="nck_cm_nck_p_NIVEAU1/B11O89/B11O89UnitTest" body="@FG:
@MA:
@New Name:
@Comment:
"><annotatedElement xmi:idref="nck_p_NIVEAU1/B11O89/B11O89UnitTest"/></ownedComment><packagedElement xmi:type="uml:Class" xmi:id="nck_c_B2B0_Test" name="B2B0_Test"><ownedComment xmi:type="uml:Comment" xmi:id="nck_cm_nck_c_B2B0_Test" body="@FG: Groupe7
@MA: collegue23
@Weight: 10
@Files: dsafd.hh dsafd.cc
@new File:
@New Name:
@Comment:
"><annotatedElement xmi:idref="nck_c_B2B0_Test"/></ownedComment></packagedElement><packagedElement xmi:type="uml:Class" xmi:id="nck_c_B2B1_Test" name="B2B1_Test"><ownedComment xmi:type="uml:Comment" xmi:id="nck_cm_nck_c_B2B1_Test" body="@FG: Groupe7
@MA: collegue23
@Weight: 10
@Files: dsafd.hh dsafd.cc
@new File:
@New Name:
@Comment:
"><annotatedElement xmi:idref="nck_c_B2B1_Test"/></ownedComment></packagedElement></packagedElement><packagedElement xmi:type="uml:Class" xmi:id="nck_c_B2B0" name="B2B0"><ownedComment xmi:type="uml:Comment" xmi:id="nck_cm_nck_c_B2B0" body="@FG: Groupe7
@MA: collegue23
@Weight: 10
@Files: dsafd.hh dsafd.cc
@new File:
@New Name:
@Comment:
"><annotatedElement xmi:idref="nck_c_B2B0"/></ownedComment></packagedElement><packagedElement xmi:type="uml:Class" xmi:id="nck_c_B2B1" name="B2B1"><ownedComment xmi:type="uml:Comment" xmi:id="nck_cm_nck_c_B2B1" body="@FG: Groupe7
@MA: collegue23
@Weight: 19
@Files: dsafdh.hh dsafd.cc dsafd.icc
@new File:
@New Name:
@Comment:
"><annotatedElement xmi:idref="nck_c_B2B1"/></ownedComment></packagedElement>
</packagedElement>
</packagedElement>

<packagedElement xmi:type="uml:Package" xmi:id="nck_p_/NIVEAU2" name="NIVEAU2"><ownedComment xmi:type="uml:Comment" xmi:id="nck_cm_nck_p_/NIVEAU2" body="@FG:
@MA:
@New Name:
@Comment:
"><annotatedElement xmi:idref="nck_p_/NIVEAU2"/></ownedComment><packagedElement xmi:type="uml:Package" xmi:id="nck_p_NIVEAU2/U1w1" name="U1w1"><ownedComment xmi:type="uml:Comment" xmi:id="nck_cm_nck_p_NIVEAU2/U1w1" body="@FG:
@MA:
@New Name:
@Comment:
"><annotatedElement xmi:idref="nck_p_NIVEAU2/U1w1"/></ownedComment><packagedElement xmi:type="uml:Class" xmi:id="nck_c_CU1ContentHandlerBase" name="CU1ContentHandlerBase"><ownedComment xmi:type="uml:Comment" xmi:id="nck_cm_nck_c_CU1ContentHandlerBase" body="@FG: Groupe6
@MA: Collegue1
@Weight: 0
@Files: U1contentbase.h
@new File:
@New Name:
@Comment:
"><annotatedElement xmi:idref="nck_c_CU1ContentHandlerBase"/></ownedComment></packagedElement><packagedElement xmi:type="uml:Class" xmi:id="nck_c_CU1FileHandleBase" name="CU1FileHandleBase"><ownedComment xmi:type="uml:Comment" xmi:id="nck_cm_nck_c_CU1FileHandleBase" body="@FG: Groupe6
@MA: Collegue1
@Weight: 0
@Files: U1filesysbase.h
@new File:
@New Name:
@Comment:
"><annotatedElement xmi:idref="nck_c_CU1FileHandleBase"/></ownedComment></packagedElement>
</packagedElement>
</packagedElement>
</uml:Model>
	<xmi:Extension extender=''MagicDraw UML 17.0.4''>
		<filePart name=''com.nomagic.ci.persistence.local.proxy.privatedependencylist'' type=''XML'' header=''&lt;?xml version=&quot;1.0&quot; encoding=&quot;ASCII&quot;?&gt;''>
<snapshot:PrivateDependenciesContainer xmi:version="2.0" xmlns:xmi="http://www.omg.org/XMI" xmlns:snapshot="http://www.nomagic.com/ns/cameo/client/snapshot/1.0" xmi:id="_VgrfIBkrEeaJI7IeBYGY0w">
  <referencedResources xmi:id="_ltnLUBksEeaJI7IeBYGY0w" originalResourceURI="local:/PROJECT-631c24ed3cb4862a41995f242a7c5?resource=com.nomagic.magicdraw.uml_umodel.model">
    <referencedObjects>NCK_id_0</referencedObjects>
  </referencedResources>
</snapshot:PrivateDependenciesContainer>
</filePart>
	</xmi:Extension>
</xmi:XMI>'
]

{ #category : #helpers }
CPPSArchitectureXMIImporterTest >> xmiModel [
  ^ '
<uml:Model xmi:type="uml:Model" xmi:id="NCK_id_0" name="NCK@@/NCK103">
<packagedElement xmi:type="uml:Package" xmi:id="nck_p_/NIVEAU1" name="NIVEAU1">
<ownedComment xmi:type="uml:Comment" xmi:id="nck_cm_nck_p_/NIVEAU1" body="@FG: @MA:@New Name: @Comment:"> 	<annotatedElement xmi:idref="nck_p_/NIVEAU1"/>
</ownedComment>
<packagedElement xmi:type="uml:Package" xmi:id="nck_p_NIVEAU1/B11O89" name="B11O89"><ownedComment xmi:type="uml:Comment" xmi:id="nck_cm_nck_p_NIVEAU1/B11O89" body="@FG: 
@MA: 
@New Name: 
@Comment: 
"><annotatedElement xmi:idref="nck_p_NIVEAU1/B11O89"/></ownedComment><packagedElement xmi:type="uml:Package" xmi:id="nck_p_NIVEAU1/B11O89/B11O89UnitTest" name="B11O89UnitTest"><ownedComment xmi:type="uml:Comment" xmi:id="nck_cm_nck_p_NIVEAU1/B11O89/B11O89UnitTest" body="@FG: 
@MA: 
@New Name: 
@Comment: 
"><annotatedElement xmi:idref="nck_p_NIVEAU1/B11O89/B11O89UnitTest"/></ownedComment></packagedElement><packagedElement xmi:type="uml:Class" xmi:id="nck_c_B2B0" name="B2B0"><ownedComment xmi:type="uml:Comment" xmi:id="nck_cm_nck_c_B2B0" body="@FG: Groupe7
@MA: collegue23
@Weight: 10
@Files: dsafd.hh dsafd.cc
@new File: 
@New Name: 
@Comment: 
"><annotatedElement xmi:idref="nck_c_B2B0"/></ownedComment></packagedElement><packagedElement xmi:type="uml:Class" xmi:id="nck_c_B2B1" name="B2B1"><ownedComment xmi:type="uml:Comment" xmi:id="nck_cm_nck_c_B2B1" body="@FG: Groupe7
@MA: collegue23
@Weight: 19
@Files: dsafdh.hh dsafd.cc dsafd.icc
@new File: 
@New Name: 
@Comment: 
"><annotatedElement xmi:idref="nck_c_B2B1"/></ownedComment></packagedElement>
</packagedElement>
</packagedElement>

<packagedElement xmi:type="uml:Package" xmi:id="nck_p_/NIVEAU2" name="NIVEAU2"><ownedComment xmi:type="uml:Comment" xmi:id="nck_cm_nck_p_/NIVEAU2" body="@FG: 
@MA: 
@New Name: 
@Comment: 
"><annotatedElement xmi:idref="nck_p_/NIVEAU2"/></ownedComment><packagedElement xmi:type="uml:Package" xmi:id="nck_p_NIVEAU2/U1w1" name="U1w1"><ownedComment xmi:type="uml:Comment" xmi:id="nck_cm_nck_p_NIVEAU2/U1w1" body="@FG: 
@MA: 
@New Name: 
@Comment: 
"><annotatedElement xmi:idref="nck_p_NIVEAU2/U1w1"/></ownedComment><packagedElement xmi:type="uml:Class" xmi:id="nck_c_CU1ContentHandlerBase" name="CU1ContentHandlerBase"><ownedComment xmi:type="uml:Comment" xmi:id="nck_cm_nck_c_CU1ContentHandlerBase" body="@FG: Groupe6
@MA: Collegue1
@Weight: 0
@Files: U1contentbase.h
@new File: 
@New Name: 
@Comment: 
"><annotatedElement xmi:idref="nck_c_CU1ContentHandlerBase"/></ownedComment></packagedElement><packagedElement xmi:type="uml:Class" xmi:id="nck_c_CU1FileHandleBase" name="CU1FileHandleBase"><ownedComment xmi:type="uml:Comment" xmi:id="nck_cm_nck_c_CU1FileHandleBase" body="@FG: Groupe6
@MA: Collegue1
@Weight: 0
@Files: U1filesysbase.h
@new File: 
@New Name: 
@Comment: 
"><annotatedElement xmi:idref="nck_c_CU1FileHandleBase"/></ownedComment></packagedElement>
</packagedElement>
</packagedElement>
</uml:Model>'
]

{ #category : #helpers }
CPPSArchitectureXMIImporterTest >> xmiPackage [
  ^ '
<uml:Model xmi:type="uml:Model" xmi:id="NCK_id_0" name="NCK@@/NCK103">
<packagedElement xmi:type="uml:Package" xmi:id="nck_p_/NIVEAU1" name="NIVEAU1">
<ownedComment xmi:type="uml:Comment" xmi:id="nck_cm_nck_p_/NIVEAU1" body="@FG: @MA:@New Name: @Comment:"> 	<annotatedElement xmi:idref="nck_p_/NIVEAU1"/>
</ownedComment>
<packagedElement xmi:type="uml:Package" xmi:id="nck_p_NIVEAU1/B11O89" name="B11O89"><ownedComment xmi:type="uml:Comment" xmi:id="nck_cm_nck_p_NIVEAU1/B11O89" body="@FG: 
@MA: 
@New Name: 
@Comment: 
"><annotatedElement xmi:idref="nck_p_NIVEAU1/B11O89"/></ownedComment><packagedElement xmi:type="uml:Package" xmi:id="nck_p_NIVEAU1/B11O89/B11O89UnitTest" name="B11O89UnitTest"><ownedComment xmi:type="uml:Comment" xmi:id="nck_cm_nck_p_NIVEAU1/B11O89/B11O89UnitTest" body="@FG: 
@MA: 
@New Name: 
@Comment: 
"><annotatedElement xmi:idref="nck_p_NIVEAU1/B11O89/B11O89UnitTest"/></ownedComment></packagedElement><packagedElement xmi:type="uml:Class" xmi:id="nck_c_B2B0" name="B2B0"><ownedComment xmi:type="uml:Comment" xmi:id="nck_cm_nck_c_B2B0" body="@FG: Groupe7
@MA: collegue23
@Weight: 10
@Files: dsafd.hh dsafd.cc
@new File: 
@New Name: 
@Comment: 
"><annotatedElement xmi:idref="nck_c_B2B0"/></ownedComment></packagedElement><packagedElement xmi:type="uml:Class" xmi:id="nck_c_B2B1" name="B2B1"><ownedComment xmi:type="uml:Comment" xmi:id="nck_cm_nck_c_B2B1" body="@FG: Groupe7
@MA: collegue23
@Weight: 19
@Files: dsafdh.hh dsafd.cc dsafd.icc
@new File: 
@New Name: 
@Comment: 
"><annotatedElement xmi:idref="nck_c_B2B1"/></ownedComment></packagedElement>
</packagedElement>
</packagedElement>

<packagedElement xmi:type="uml:Package" xmi:id="nck_p_/NIVEAU2" name="NIVEAU2"><ownedComment xmi:type="uml:Comment" xmi:id="nck_cm_nck_p_/NIVEAU2" body="@FG: 
@MA: 
@New Name: 
@Comment: 
"><annotatedElement xmi:idref="nck_p_/NIVEAU2"/></ownedComment><packagedElement xmi:type="uml:Package" xmi:id="nck_p_NIVEAU2/U1w1" name="U1w1"><ownedComment xmi:type="uml:Comment" xmi:id="nck_cm_nck_p_NIVEAU2/U1w1" body="@FG: 
@MA: 
@New Name: 
@Comment: 
"><annotatedElement xmi:idref="nck_p_NIVEAU2/U1w1"/></ownedComment><packagedElement xmi:type="uml:Class" xmi:id="nck_c_CU1ContentHandlerBase" name="CU1ContentHandlerBase"><ownedComment xmi:type="uml:Comment" xmi:id="nck_cm_nck_c_CU1ContentHandlerBase" body="@FG: Groupe6
@MA: Collegue1
@Weight: 0
@Files: U1contentbase.h
@new File: 
@New Name: 
@Comment: 
"><annotatedElement xmi:idref="nck_c_CU1ContentHandlerBase"/></ownedComment></packagedElement><packagedElement xmi:type="uml:Class" xmi:id="nck_c_CU1FileHandleBase" name="CU1FileHandleBase"><ownedComment xmi:type="uml:Comment" xmi:id="nck_cm_nck_c_CU1FileHandleBase" body="@FG: Groupe6
@MA: Collegue1
@Weight: 0
@Files: U1filesysbase.h
@new File: 
@New Name: 
@Comment: 
"><annotatedElement xmi:idref="nck_c_CU1FileHandleBase"/></ownedComment></packagedElement>
</packagedElement>
</packagedElement>
</uml:Model>'
]
