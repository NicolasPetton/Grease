GRPlatform subclass: GRGSTPlatform [
    
    <comment: 'A WASqueakPlatform is the Squeak implementation of 
    SeasidePlatformSupport, the Seaside class that provides functionality 
    that can not be implemented in a platform independent way.'>
    <category: 'Grease-Gst-Core'>

    GRGSTPlatform class [
	| startUpList shutdownList |

	initialize [
	    <category: 'class initialization'>
	    startUpList := OrderedCollection new.
	    shutdownList := OrderedCollection new.
	    self select
	]

	unload [
	    <category: 'class initialization'>
	    self unselect
	]

	update: anAspect [
	    <category: 'startup'>
	    anAspect == #returnFromSnapshot ifTrue: [
		startUpList do: [:each | each startUp: true]].
	    anAspect == #aboutToQuit ifTrue: [
		shutdownList do: [:each | each shutDown: true]]
	]

	addToStartUpList: anObject [
	    <category: 'startup'>
	    (startUpList includes: anObject) ifFalse: [
		startUpList add: anObject]
	]

	addToShutDownList: anObject [
	    <category: 'startup'>
	    (shutdownList includes: anObject) ifFalse: [
		shutdownList add: anObject]
	]

	removeFromStartUpList: anObject [
	    <category: 'startup'>
	    (startUpList includes: anObject) ifTrue: [
		startUpList remove: anObject]
	]

	removeFromShutDownList: anObject [
	    <category: 'startup'>
	    (shutdownList includes: anObject) ifTrue: [
		shutdownList remove: anObject]
	]
    ]

    addToShutDownList: anObject [
	"Add anObject to the shutdown-list of the system. On shutdown the 
	message #shutDown will be sent to anObject."

	<category: 'startup'>
	self class addToShutDownList: anObject
    ]

    addToStartUpList: anObject [
	"Add anObject to the startup-list of the system. On startup the message
	#startUp will be sent to anObject."

	<category: 'startup'>
	self class addToStartUpList: anObject
    ]

    removeFromShutDownList: anObject [
	"Remove anObject from the shutdown list in the system."

	<category: 'startup'>
	self class removeFromShutDownList: anObject
    ]

    removeFromStartUpList: anObject [
	"Remove anObject from the startup list in the system."

	<category: 'startup'>
	self class removeFromStartUpList: anObject
    ]

    asMethodReturningByteArray: aByteArrayOrString named: aSymbol [
	"Generates the source of a method named aSymbol that returns 
	aByteArrayOrString as a ByteArray"

	<category: 'file library'>
	^self useByteArrayLiterals 
	    ifTrue: 
		[self asMethodReturningByteArrayLiteral: aByteArrayOrString named: aSymbol]
	    ifFalse: 
		[self asMethodReturningByteArrayWithCache: aByteArrayOrString named: aSymbol]
    ]

    compile: aString into: aClass classified: aSymbol [
	<category: 'file library'>
	aClass compile: aString classified: aSymbol
    ]

    contentsOfFile: aString binary: aBoolean [
	<category: 'file library'>
	| data |
	data := (File name: aString) contents.
	aBoolean ifTrue: [ data := data asByteArray ].
	^data
    ]

    convertToSmalltalkNewlines: aString [
	"Convert any line endings (CR, CRLF, LF) to CR."

	<category: 'file library'>
	aString isNil ifTrue: [^nil].
	^aString class streamContents: 
		[:writeStream | 
		| readStream |
		readStream := aString readStream.
		[readStream atEnd] whileFalse: 
			[| next |
			next := readStream next.
			next = Character cr 
			    ifTrue: 
				[readStream peek = Character lf ifTrue: [readStream skip: 1].
				writeStream nextPut: Character cr]
			    ifFalse: 
				[next = Character lf 
				    ifTrue: [writeStream nextPut: Character cr]
				    ifFalse: [writeStream nextPut: next]]]]
    ]

    ensureExistenceOfFolder: aString [
	"creates a folder named aString in the image directory"

	<category: 'file library'>
	FileDirectory default assureExistenceOfPath: aString
    ]

    filesIn: aPathString [
	"Return a collection of absolute paths for all the files (no directories) in the directory given by aPathString
	 must not include file names that start with ."

	<category: 'file library'>
	| directory |
	directory := FileDirectory default directoryNamed: aPathString.
	^(directory fileNames reject: [:each | each first = $.]) 
	    collect: [:each | directory fullNameFor: each]
    ]

    localNameOf: aFilename [
	<category: 'file library'>
	^(FileDirectory on: aFilename) localName
    ]

    removeSelector: aSymbol from: aClass [
	<category: 'file library'>
	aClass removeSelectorSilently: aSymbol
    ]

    write: aStringOrByteArray toFile: aFileNameString inFolder: aFolderString [
	"writes aStringOrByteArray to a file named aFilenameString in the folder aFolderString"

	<category: 'file library'>
	| folder stream fullFilePath |
	folder := FileDirectory default directoryNamed: aFolderString.
	fullFilePath := folder fullNameFor: aFileNameString.
	stream := aStringOrByteArray isString 
		    ifTrue: 
			[(CrLfFileStream forceNewFileNamed: fullFilePath)
			    ascii;
			    wantsLineEndConversion: true;
			    yourself]
		    ifFalse: [(FileStream forceNewFileNamed: fullFilePath) binary].
	[stream nextPutAll: aStringOrByteArray] ensure: [stream close]
    ]

    asMethodReturningByteArrayLiteral: aByteArrayOrString named: aSymbol [
	"Generates the source of a method named aSymbol that returns 
	aByteArrayOrString as a byte array using VW/NewCompiler byte array 
	literal syntax."

	<category: 'private-file library'>
	^String streamContents: 
		[:stream | 
		stream
		    nextPutAll: aSymbol;
		    nextPut: Character cr.
		stream
		    tab;
		    nextPutAll: '^ #['.
		aByteArrayOrString asByteArray do: [:each | each printOn: stream]
		    separatedBy: [stream space].
		stream nextPutAll: ']']
    ]

    asMethodReturningByteArrayWithCache: aByteArrayOrString named: aSymbol [
	"Generates the source of a method named aSymbol that returns 
	aByteArrayOrString as a byte array and caching this array in 
	a literal array of size 1."

	<category: 'private-file library'>
	^String streamContents: 
		[:stream | 
		stream
		    nextPutAll: aSymbol;
		    nextPut: Character cr.
		stream
		    tab;
		    nextPutAll: '^ #('.
		aByteArrayOrString asByteArray do: [:each | each printOn: stream]
		    separatedBy: [stream space].
		stream nextPutAll: ') asByteArray']
    ]

    useByteArrayLiterals [
	"whether ByteArray literals can/should be used"

	<category: 'private-file library'>
	^Preferences valueOfFlag: #compileUseNewCompiler ifAbsent: [false]
    ]

    base64Decode: aString [
	<category: 'encoding'>
	^(Base64MimeConverter mimeDecodeToChars: aString readStream) contents
    ]

    isProcessTerminated: aProcess [
	"Return a boolean indicating whether aProcess has been terminated."

	<category: 'processes'>
	^aProcess isTerminated
    ]

    terminateProcess: aProcess [
	"Permanently terminate the process, unwinding first to execute #ensure:
	and #ifCurtailed: blocks."

	<category: 'processes'>
	aProcess terminate
    ]

    label [
	<category: 'version info'>
	^'Pharo'
    ]

    newRandom [
	"Answers the random number generator to be used to create session and 
	continuation keys. Make sure it is seeded. They only methods that will 
	be sent to it are:
	#nextInt: - should answer a random integer in the interval [1, anInteger]
	#randomFrom: - should answer a random element from the given collection
	 
	 Make sure that both methods are safe under heavy concurrent load.
	 
	 Used by Gemstone/S traditional Randoms which cannot be persisted.
	 Used by Squeak to use a secure random when avaiable."

	<category: 'factory'>
	^GRGSTRandomProvider
    ]

    readWriteByteStream [
	"ByteArray based read write stream"

	<category: 'factory'>
	^ReadWriteStream on: (ByteArray new: 4096)
    ]

    readWriteCharacterStream [
	"String based read write stream"

	<category: 'factory'>
	^ReadWriteStream on: (String new: 4096)
    ]

    semaphoreClass [
	"used by Gemstone/S traditional Semaphores which cannot be persisted"

	<category: 'factory'>
	^Semaphore
    ]

    weakDictionaryOfSize: aNumber [
	<category: 'factory'>
	^IdentityDictionary new: aNumber
    ]

    openDebuggerOn: anError [
	<category: 'exceptions'>
	| process |
	process := Processor activeProcess.
	"If we are running in the UI process, we don't want to suspend the active process. The
	 error was presumably triggered while stepping in the Debugger. If we simply immediately
	 signal an UnhandledError, the debugger will catch this and display the signaling context.
	 It isn't perfect or pretty but it works."
	(ProcessBrowser isUIProcess: process) 
	    ifTrue: [UnhandledError signalForException: anError]
	    ifFalse: 
		[WorldState addDeferredUIMessage: 
			[process 
			    debug: anError signalerContext
			    title: anError description
			    full: true].
		process suspend]
    ]

    stackDepth [
	<category: 'exceptions'>
	| depth current |
	depth := 0.
	current := thisContext.
	[current isNil] whileFalse: 
		[current := current sender.
		depth := depth + 1].
	^depth - 1
    ]

    secureHashFor: aString [
	<category: 'cryptography'>
	^SecureHashAlgorithm new hashMessage: aString
    ]
]



Eval [
    GRGSTPlatform initialize
]

