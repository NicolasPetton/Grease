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
	String streamContents: [ :stream |
		stream nextPutAll: aSymbol; nextPutAll: ' [ '; nl.
		stream tab; nextPutAll: '    ^#['.
		aByteArrayOrString asByteArray
			do: [ :each | each printOn: stream ]
			separatedBy: [ stream space ].
		stream nextPutAll: ']'; nl; nextPutAll: ']' ]
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
	aString isNil ifTrue: [ ^ nil ].
	^aString class streamContents: [ :writeStream |
		| readStream |
		readStream := aString readStream.
		[ readStream atEnd ] whileFalse: [
			| next |
			next := readStream next.
			next = Character cr
				ifTrue: [
					readStream peek = Character lf
						ifTrue: [ readStream skip: 1 ].
					writeStream nextPut: Character cr ]
				ifFalse: [
					next = Character lf
						ifTrue: [ writeStream nextPut: Character cr ]
						ifFalse: [ writeStream nextPut: next ] ] ] ]
    ]

    ensureExistenceOfFolder: aString [
	"creates a folder named aString in the image directory"

	<category: 'file library'>
	(Directory image / aString) create
    ]

    filesIn: aPathString [
	"Return a collection of absolute paths for all the files (no directories) in the directory given by aPathString
	 must not include file names that start with ."

	<category: 'file library'>
	| directory |
	directory := File name: aPathString.
	^(directory files
		reject: [ :each | each first = $. ])
		collect: [ :each | each asString ]
    ]

    localNameOf: aFilename [
	<category: 'file library'>
	^File fullNameFor: aFilename
    ]

    removeSelector: aSymbol from: aClass [
	<category: 'file library'>
	aClass removeSelector: aSymbol
    ]

    write: aStringOrByteArray toFile: aFileNameString inFolder: aFolderString [
	"writes aStringOrByteArray to a file named aFilenameString in the folder aFolderString"

	<category: 'file library'>
	| stream fileName |
	aFolderString / aFileNameString withWriteStreamDo: [ :stream |
	    stream nextPutAll: aStringOrByteArray ]
    ]

    base64Decode: aString [
	<category: 'encoding'>
	| codeChars decoder output index nl endChars end limit padding data sz |
        codeChars := 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'.
        decoder := (0 to: 255)
                    collect: [:n | (codeChars indexOf: (n + 1) asCharacter) - 1].
        decoder replaceAll: -1 with: 0.
        output := (data := String new: aString size * 3 // 4)
                    writeStream.
        index := 1.
        nl := Character nl.
        "There is padding at the end of a base64 message if the content is not a multiple of
         3 bytes in length.  The padding is either two ='s to pad-out a trailing byte, 1 = to
         pad out a trailing pair of bytes, or no padding.  Here we count the padding.  After
         processing the message we cut-back by the amount of padding."
        sz := end := aString size.
        endChars := codeChars , (String with: $=).

        [(endChars includes: (aString at: end))
            and: [end = sz or: [(aString at: end + 1) = nl]]]
                whileFalse: [end := end - 1].
        limit := end.
        padding := 0.
        [(aString at: end) == $=] whileTrue:
                [padding := padding - 1.
                end := end - 1].
        [index <= limit] whileTrue:
                [| triple |
                triple := ((decoder at: (aString at: index) asInteger) bitShift: 18)
                            + ((decoder at: (aString at: index + 1) asInteger) bitShift: 12)
                                + ((decoder at: (aString at: index + 2) asInteger) bitShift: 6)
                                + (decoder at: (aString at: index + 3) asInteger).
                output nextPut: (Character value: (triple digitAt: 3)).
                output nextPut: (Character value: (triple digitAt: 2)).
                output nextPut: (Character value: (triple digitAt: 1)).
                index := index + 4.
                [(index > sz or: [(aString at: index) = nl]) and: [index <= limit]]
                    whileTrue: [index := index + 1]].
        padding ~= 0 ifTrue: [output skip: padding].
        ^data copyFrom: 1 to: output position
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
	^'GNU Smalltalk'
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
	^ReadWriteStream on: ByteArray new
    ]

    readWriteCharacterStream [
	"String based read write stream"

	<category: 'factory'>
	^ReadWriteStream on: ''
    ]

    semaphoreClass [
	"used by Gemstone/S traditional Semaphores which cannot be persisted"

	<category: 'factory'>
	^Semaphore
    ]

    weakDictionaryOfSize: aNumber [
	<category: 'factory'>
	^WeakKeyIdentityDictionary new: aNumber
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
		[current := current parentContext.
		depth := depth + 1].
	^depth - 1
    ]

    secureHashFor: aString [
	<category: 'cryptography'>
	^MD5 digestOf: aString
    ]
]



Eval [
    GRGSTPlatform initialize
]

