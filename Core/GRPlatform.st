GRObject subclass: GRPlatform [
    
    <comment: 'The abstract platform implementation. Each platform should provide a subclass implementing any abstract methods and overriding any other methods as necessary.
    
    Default implementations should be provided here when possible/useful but default implementations MUST be valid on ALL PLATFORMS so it is rarely practical. VA Smalltalk flags sends of uknown messages so even these must be known to exist on all platforms.
    
    Common cases where default implementations *are* appropriate are where there is a standard implementation that is valid on all platforms but one or more platforms have an additional, optimized implementation that should be used instead.
    
    All classes and methods used by methods of this class should be either:
    + included in the Seaside-Platform package;
    + defined by the ANSI Smalltalk standard; or
    + (not ideal) referenced via ''Smalltalk at: #ClassName''.'>

    <category: 'Grease-Core'>

    Current := nil.

    GRPlatform class >> current [
	<category: 'registration'>
	^Current
    ]

    GRPlatform class >> current: aPlatform [
	<category: 'registration'>
	Current := aPlatform
    ]

    GRPlatform class >> select [
	<category: 'registration'>
	GRPlatform current: self new
    ]

    GRPlatform class >> unselect [
	<category: 'registration'>
	GRPlatform current class = self ifTrue: [GRPlatform current: nil]
    ]

    secureHashFor: aString [
	<category: 'cryptography'>
	self subclassResponsibility
    ]

    base64Decode: aString [
	<category: 'encoding'>
	self subclassResponsibility
    ]

    openDebuggerOn: anError [
	<category: 'exceptions'>
	self subclassResponsibility
    ]

    stackDepth [
	<category: 'exceptions'>
	self subclassResponsibility
    ]

    newRandom [
	"Answers the random number generator to be used to create session and continuation keys. Make sure it is seeded. The only methods that will be sent to it are:
	 #nextInt: - should answer a random integer in the interval [1, anInteger]
	 #randomFrom: - should answer a random element from the given collection
	 
	 Make sure that both methods are safe under heavy concurrent load.
	 
	 Used by Gemstone/S traditional Randoms which cannot be persisted.
	 Used by Squeak to use a secure random when avaiable."

	<category: 'factory'>
	self subclassResponsibility
    ]

    readWriteByteStream [
	"Return a ReadWriteStream on a ByteArray that stores integers 0..255
	 ^ReadWriteStream on: ByteArray new
	 "

	<category: 'factory'>
	^self subclassResponsibility
    ]

    readWriteCharacterStream [
	"Return a ReadWriteStream on a String that stores characters
	 ^ReadWriteStream on: String new
	 "

	<category: 'factory'>
	^self subclassResponsibility
    ]

    reducedConflictDictionary [
	"used by Gemstone/S reduced conflict classes that can be used to avoid transaction conflicts"

	<category: 'factory'>
	^Dictionary
    ]

    semaphoreClass [
	"used by Gemstone/S traditional Semaphores which cannot be persisted"

	<category: 'factory'>
	self subclassResponsibility
    ]

    weakDictionaryOfSize: aNumber [
	<category: 'factory'>
	self subclassResponsibility
    ]

    asMethodReturningByteArray: aByteArrayOrString named: aSymbol [
	"Generates the source of a method named aSymbol that returns aByteArrayOrString as a ByteArray"

	<category: 'file library'>
	self subclassResponsibility
    ]

    compile: aString into: aClass classified: aSymbol [
	"The trick here is to be as silently a possible so that the package is not marked dirty when running WAFileLibrary test.
	 This also makes running tests much faster."

	<category: 'file library'>
	self subclassResponsibility
    ]

    contentsOfFile: aString binary: aBoolean [
	<category: 'file library'>
	self subclassResponsibility
    ]

    convertToSmalltalkNewlines: aString [
	"convert any line endings (CR, CRLF, LF) to CR"

	<category: 'file library'>
	self subclassResponsibility
    ]

    ensureExistenceOfFolder: aString [
	"creates a folder named aString in the image directory"

	<category: 'file library'>
	self subclassResponsibility
    ]

    filesIn: aPathString [
	"Return a collection of absolute paths for all the files (no directories) in the directory given by aPathString
	 must not include file names that start with ."

	<category: 'file library'>
	self subclassResponsibility
    ]

    localNameOf: aFilename [
	"Answers the local name of a file indentified by an absolute file path.
	 
	 Eg.
	 If the platform is Windwos and aFilename is 'C:\Windows\win32.dll' then it would answer 'win32.dll'.
	 If the platform is Unix and aFilename is '/usr/bin/vim' then it would answer 'vim'."

	<category: 'file library'>
	self subclassResponsibility
    ]

    removeSelector: aSymbol from: aClass [
	<category: 'file library'>
	self subclassResponsibility
    ]

    write: aStringOrByteArray toFile: aFileNameString inFolder: aFolderString [
	"writes aStringOrByteArray to a file named aFilenameString in the folder aFolderString"

	<category: 'file library'>
	self subclassResponsibility
    ]

    isProcessTerminated: aProcess [
	"Return a boolean indicating whether aProcess has been terminated."

	<category: 'processes'>
	self subclassResponsibility
    ]

    terminateProcess: aProcess [
	"Permanently terminate the process, unwinding first to execute #ensure: and #ifCurtailed: blocks."

	<category: 'processes'>
	self subclassResponsibility
    ]

    addToShutDownList: anObject [
	"Add anObject to the shutdown-list of the system. On shutdown the message #shutDown will be sent to anObject."

	<category: 'startup'>
	self subclassResponsibility
    ]

    addToStartUpList: anObject [
	"Add anObject to the startup-list of the system. On startup the message #startUp will be sent to anObject."

	<category: 'startup'>
	self subclassResponsibility
    ]

    removeFromShutDownList: anObject [
	"Remove anObject from the shutdown list in the system."

	<category: 'startup'>
	self subclassResponsibility
    ]

    removeFromStartUpList: anObject [
	"Remove anObject from the startup list in the system."

	<category: 'startup'>
	self subclassResponsibility
    ]

    doTransaction: aBlock [
	"for Gemstone/S compatibility
	 http://gemstonesoup.wordpress.com/2007/05/10/porting-application-specific-seaside-threads-to-gemstone/
	 use when modifying an object from an outside thread"

	<category: 'transactions'>
	^aBlock value
    ]

    label [
	"Answer a descriptive label string for the platform implementation"

	<category: 'version info'>
	self subclassResponsibility
    ]

    version [
	"Answer the Grease version"

	<category: 'version info'>
	^(GRVersion major: 1 minor: 0)
	    beAlpha: 6;
	    yourself
    ]

    versionString [
	<category: 'version info'>
	^String streamContents: 
		[:stream | 
		stream
		    nextPutAll: self version greaseString;
		    nextPutAll: ' (';
		    nextPutAll: self label;
		    nextPut: $)]
    ]
]

