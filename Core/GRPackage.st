GRObject subclass: GRPackage [
    | name description dependencies license url |
    
    <comment: nil>
    <category: 'Grease-Core'>


    GRPackage class >> greasePharoCore [
	<category: '*grease-pharo-core'>
	^(self new)
	    name: 'Grease-Pharo-Core';
	    addDependency: 'Grease-Core';
	    url: #seasideUrl;
	    yourself
    ]

    GRPackage class >> greaseTestsCore [
	<category: '*grease-tests-core'>
	^(self new)
	    name: 'Grease-Tests-Core';
	    description: 'Unit tests for the package Grease-Core.';
	    addDependency: 'Grease-Core';
	    url: #seasideUrl;
	    yourself
    ]

    GRPackage class >> greaseTestsPharoCore [
	<category: '*grease-tests-pharo-core'>
	^(self new)
	    name: 'Grease-Tests-Pharo-Core';
	    description: 'Unit tests for the package Grease-Pharo-Core.';
	    addDependency: 'Grease-Pharo-Core';
	    addDependency: 'Grease-Tests-Core';
	    url: #seasideUrl;
	    yourself
    ]

    GRPackage class >> greaseCore [
	<category: 'accessing'>
	^(self new)
	    name: 'Grease-Core';
	    description: 'The main package of the Grease compatibility layer.';
	    url: #seasideUrl;
	    yourself
    ]

    GRPackage class >> packages [
	"Answer a list of all registered packages. 
	A package is registered by adding a class extension to the receiving class answering an instance of the receiving class."

	<category: 'querying'>
	| packages package |
	packages := Dictionary new.
	self class selectors do: 
		[:each | 
		(each numArgs = 0 and: [each ~= #packages]) 
		    ifTrue: 
			[package := self perform: each.
			packages at: package name put: package]].
	packages do: [:each | each resolveWith: packages].
	^packages values
    ]

    initialize [
	<category: 'initialization'>
	super initialize.
	dependencies := OrderedCollection new.
	license := #MIT
    ]

    description [
	"Answer a short description of the package."

	<category: 'accessing'>
	^description
    ]

    description: aString [
	<category: 'accessing'>
	description := aString
    ]

    license [
	"Answer the current license of this package, by default MIT is used."

	<category: 'accessing'>
	^license
    ]

    license: aSymbol [
	<category: 'accessing'>
	license := aSymbol
    ]

    name [
	"Answer the name of the package. This string should be useable to identify the platform specific native package object, e.g. the Monticello package name."

	<category: 'accessing'>
	^name
    ]

    name: aString [
	<category: 'accessing'>
	name := aString
    ]

    url [
	"Answer the base-URL of the package. This string is only meaningful for platforms that can directly access Monticello repositories."

	<category: 'accessing'>
	^url isSymbol ifTrue: [self perform: url] ifFalse: [url]
    ]

    url: aStringOrSymbol [
	"Set the base-URL of the package, or a symbol referring to a method in this class that answers the URL. This setting is only meaningful for platforms that can directly access Monticello repositories."

	<category: 'accessing'>
	url := aStringOrSymbol
    ]

    addDependency: aString [
	<category: 'dependencies'>
	dependencies add: aString
    ]

    allDependencies [
	"Answer all dependencies on which this package depends."

	<category: 'dependencies'>
	^self addDependenciesTo: OrderedCollection new
    ]

    dependencies [
	"Return a collection of package names on which this package depends."

	<category: 'dependencies'>
	^dependencies
    ]

    resolveWith: aDictionary [
	<category: 'dependencies'>
	dependencies := dependencies collect: 
			[:each | 
			aDictionary at: each
			    ifAbsent: 
				[self error: self name printString , ' depends on unknown package ' 
					    , each printString]]
    ]

    printOn: aStream [
	<category: 'printing'>
	super printOn: aStream.
	aStream
	    nextPut: $(;
	    nextPutAll: self name;
	    nextPut: $)
    ]

    isLGPL [
	<category: 'testing'>
	^self license = #LGPL
    ]

    isMIT [
	<category: 'testing'>
	^self license = #MIT
    ]

    addDependenciesTo: aCollection [
	<category: 'private'>
	(aCollection includes: self) 
	    ifFalse: 
		[self dependencies do: [:each | each addDependenciesTo: aCollection].
		aCollection add: self].
	^aCollection
    ]

    seasideLGPLUrl [
	<category: 'accessing-repositories'>
	^'http://www.squeaksource.com/Seaside30LGPL'
    ]

    seasideUrl [
	<category: 'accessing-repositories'>
	^'http://www.squeaksource.com/Seaside30'
    ]
]

