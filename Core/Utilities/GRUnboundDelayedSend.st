GRDelayedSend subclass: GRUnboundDelayedSend [
    
    <comment: 'A delayed send that has none of the arguments defined in advance.'>
    <category: 'Grease-Core-Utilities'>

    argumentCount [
	<category: 'accessing'>
	^selector numArgs
    ]

    valueWithArguments: anArray [
	<category: 'evaluating'>
	^anArray size = selector numArgs 
	    ifTrue: [receiver perform: selector withArguments: anArray]
	    ifFalse: [self invalidArgumentCount]
    ]

    valueWithPossibleArguments: anArray [
	<category: 'evaluating'>
	^anArray size < selector numArgs 
	    ifTrue: [self invalidArgumentCount]
	    ifFalse: [self valueWithArguments: (anArray first: selector numArgs)]
    ]
]

