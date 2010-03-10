GRDelayedSend subclass: GRBoundDelayedSend [
    | arguments |
    
    <comment: 'A delayed send that has some or all of the arguments defined in advance. Additionally supplied arguments will be added, if possible, to these when the object is evaluate.
    
    Instance Variables
    arguments:		<Array>
    
    arguments
    - the predefined arguments'>
    <category: 'Grease-Core-Utilities'>

    argumentCount [
	<category: 'accessing'>
	^selector numArgs - arguments size
    ]

    valueWithArguments: anArray [
	<category: 'evaluating'>
	^arguments size + anArray size = selector numArgs 
	    ifTrue: [receiver perform: selector withArguments: arguments , anArray]
	    ifFalse: [self invalidArgumentCount]
    ]

    valueWithPossibleArguments: anArray [
	<category: 'evaluating'>
	| composed |
	^(composed := arguments , anArray) size < selector numArgs 
	    ifTrue: [self invalidArgumentCount]
	    ifFalse: 
		[receiver perform: selector
		    withArguments: (composed first: selector numArgs)]
    ]

    initializeWithReceiver: anObject selector: aSymbol arguments: anArray [
	<category: 'initialization'>
	self initializeWithReceiver: anObject selector: aSymbol.
	arguments := anArray asArray
    ]

    printOn: aStream [
	<category: 'printing'>
	super printOn: aStream.
	aStream
	    nextPutAll: ' arguments: ';
	    print: arguments
    ]
]
