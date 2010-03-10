GRObject subclass: GRDelayedSend [
    | receiver selector |
    
    <comment: 'A WADelayedSend is a future message send of a message to an object. Some of the arguments can be predefined. Instances are intended to be interchangeable with blocks.
    
    This class should conform the ANSI valuable protocol.
    
    This is an abstract class. Use the methods in the ''instance-creation'' protocol on the class side to create intances.
    
    Instance Variables
    receiver:		<Object>
    selector:		<Symbol>
    
    receiver
    - the object receiving the message
    
    selector
    - the message selector sent to the receiver'>
    <category: 'Grease-Core-Utilities'>

    GRDelayedSend class >> receiver: anObject selector: aSymbol [
	<category: 'instance creation'>
	^GRUnboundDelayedSend basicNew initializeWithReceiver: anObject
	    selector: aSymbol
    ]

    GRDelayedSend class >> receiver: anObject selector: aSymbol argument: aParameter [
	<category: 'instance creation'>
	^self 
	    receiver: anObject
	    selector: aSymbol
	    arguments: (Array with: aParameter)
    ]

    GRDelayedSend class >> receiver: anObject selector: aSymbol arguments: anArray [
	<category: 'instance creation'>
	^GRBoundDelayedSend basicNew 
	    initializeWithReceiver: anObject
	    selector: aSymbol
	    arguments: anArray
    ]

    argumentCount [
	"Answer the number of arguments that must be provided to the receiver when sending it."

	<category: 'accessing'>
	self subclassResponsibility
    ]

    fixCallbackTemps [
	"For polymorphism with BlockContext>>#fixCallbackTemps."

	<category: 'accessing'>
	
    ]

    value [
	<category: 'evaluating'>
	^self valueWithArguments: #()
    ]

    value: anObject [
	<category: 'evaluating'>
	^self valueWithArguments: (Array with: anObject)
    ]

    value: aFirstObject value: aSecondObject [
	<category: 'evaluating'>
	^self valueWithArguments: (Array with: aFirstObject with: aSecondObject)
    ]

    valueWithArguments: anArray [
	<category: 'evaluating'>
	self subclassResponsibility
    ]

    valueWithPossibleArguments: anArray [
	<category: 'evaluating'>
	self subclassResponsibility
    ]

    initializeWithReceiver: anObject selector: aSymbol [
	<category: 'initialization'>
	self initialize.
	receiver := anObject.
	selector := aSymbol
    ]

    printOn: aStream [
	<category: 'printing'>
	super printOn: aStream.
	aStream
	    nextPutAll: ' receiver: ';
	    print: receiver.
	aStream
	    nextPutAll: ' selector: ';
	    print: selector
    ]

    invalidArgumentCount [
	<category: 'private'>
	GRInvalidArgumentCount signal
    ]
]
