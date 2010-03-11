TestCase subclass: GRPackageTest [
    | package |
    
    <comment: nil>
    <category: 'Grease-Tests-Core'>

    setUp [
	<category: 'running'>
	super setUp.
	package := GRPackage new
    ]

    testAllDependencies [
	<category: 'testing-dependencies'>
	| packages |
	packages := Dictionary new.
	packages 
	    at: 'Lust'
		put: ((GRPackage new)
		    name: 'Lust';
		    addDependency: 'Gluttony';
		    addDependency: 'Greed';
		    yourself);
	    at: 'Gluttony'
		put: ((GRPackage new)
		    name: 'Gluttony';
		    addDependency: 'Greed';
		    yourself);
	    at: 'Greed'
		put: ((GRPackage new)
		    name: 'Greed';
		    yourself).
	packages values do: [:each | each resolveWith: packages].
	self assert: (packages at: 'Lust') allDependencies size = 3.
	self assert: (packages at: 'Gluttony') allDependencies size = 2.
	self assert: (packages at: 'Greed') allDependencies size = 1
    ]

    testDependencies [
	<category: 'testing-dependencies'>
	self assert: package dependencies isEmpty.
	package addDependency: 'Lust'.
	package addDependency: 'Envy'.
	self assert: package dependencies size = 2.
	self assert: package dependencies first = 'Lust'.
	self assert: package dependencies last = 'Envy'
    ]

    testDescription [
	<category: 'testing'>
	self assert: package description isNil.
	package description: 'A hopeless pacakge'.
	self assert: package description = 'A hopeless pacakge'
    ]

    testLicense [
	<category: 'testing'>
	self assert: package license = #MIT.
	self assert: package isMIT.
	package license: #LGPL.
	self assert: package license = #LGPL.
	self assert: package isLGPL
    ]

    testName [
	<category: 'testing'>
	self assert: package name isNil.
	package name: 'Gimme-Hope'.
	self assert: package name = 'Gimme-Hope'
    ]

    testUrl [
	<category: 'testing'>
	self assert: package url isNil.
	package url: #seasideLGPLUrl.
	self assert: package url = GRPackage new seasideLGPLUrl.
	package url: 'http://www.seaside.st/distributions'.
	self assert: package url = 'http://www.seaside.st/distributions'
    ]

    testPackages [
	<category: 'testing-packages'>
	| packages |
	packages := GRPackage packages.
	self assert: packages notEmpty.
	packages do: [:each | 
	    self assert: each name notEmpty.
	    self assert: each license notNil.
	    self assert: each url notNil]
    ]
]

