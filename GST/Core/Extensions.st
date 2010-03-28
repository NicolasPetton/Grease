Object extend [
    isEmptyOrNil [
	<category: '*Grease-GST-Core'>
	^false
    ]
]

Collection extend [
    isEmptyOrNil [
	<category: '*Grease-GST-Core'>
	^self isEmpty
    ]
]

UndefinedObject extend [
    isEmptyOrNil [
	<category: '*Grease-GST-Core'>
	^true
    ]
]

BlockClosure extend [
    fixCallbackTemps [
	<category: '*Grease-GST-Core'>
    ]
]

Behavior extend [
    
    fullName [
	<category: '*Grease-GST-Core'>
	^self nameIn: Smalltalk
    ]

    startUp: aBoolean [
	"StartUo/ShutDown. See GRGSTPlatform class methods about startUpList and shutDownList"
	<category: '*Grease-GST-Core'>
    ]

    shutDown: aBoolean [
	"StartUo/ShutDown. See GRGSTPlatform class methods about startUpList and shutDownList"
	<category: '*Grease-GST-Core'>
    ]
]

DirectedMessage extend [
    
    valueWithPossibleArguments: aCollection [
	<category: '*Grease-GST-Core'>
	| args |
	(aCollection size == self selector numArgs)
	    ifTrue: [^self valueWithArguments: aCollection].
	args := Array new: self selector numArgs.
	args replaceFrom: 1
		to: (aCollection size min: args size)
		with: aCollection
		startingAt: 1.
	^self valueWithArguments: args
    ]
]

BlockClosure extend [

    argumentCount [
	<category: '*Grease-GST-Core'>
	^self numArgs
    ]

    valueWithPossibleArguments: aCollection [
	<category: '*Grease-GST-Core'>
	| args |
	(aCollection size == self numArgs)
	    ifTrue: [^self valueWithArguments: aCollection].
	args := Array new: self numArgs.
	args replaceFrom: 1
		to: (aCollection size min: args size)
		with: aCollection
		startingAt: 1.
	^self valueWithArguments: args
    ]
]

Symbol extend [

    capitalized [
	<category: '*Grease-GST-Core'>
	^self asString capitalized asSymbol
    ]
]

String extend [

    beginsWith: aString [
	<category: '*Grease-GST-Core'>
	^self startsWith: aString
    ]

    sort [
	<category: '*Grease-GST-Core'>
	^self asArray sort asString
    ]

    sort: aBlock [
	<category: '*Grease-GST-Core'>
	^(self asArray sort: aBlock) asString
    ]

    capitalized [
	<category: '*Grease-GST-Core'>
	| cap |
	self isEmpty ifTrue: [^self].
	cap := self copy.
	cap at: 1 put: (self at: 1) asUppercase.
	^cap
    ]
]

Character extend [
    
    greaseInteger [
	<category: '*Grease-GST-Core'>
	^self codePoint
    ]

    asUnicode [
	<category: '*Grease-GST-Core'>
	^UnicodeCharacter value: self value
    ]
]

Number extend [

    weeks [
	<category: '*Grease-GST-Core'>
	^Duration weeks: self
    ]

    days [
	<category: '*Grease-GST-Core'>
	^Duration days: self
    ]

    hours [
	<category: '*Grease-GST-Core'>
	^Duration hours: self
    ]

    minutes [
	<category: '*Grease-GST-Core'>
	^Duration minutes: self
    ]

    seconds [
	<category: '*Grease-GST-Core'>
	^Duration seconds: self
    ]

    milliseconds [
	<category: '*Grease-GST-Core'>
	^Duration milliseconds: self
    ]
]

Collection extend [

    any [
	<category: '*Grease-GST-Core'>
	^self anyOne
    ]

    sorted [
	<category: '*Grease-GST-Core'>
	^self asArray sort
    ]

    sorted: aBlock [
	<category: '*Grease-GST-Core'>
	^self asArray sort: aBlock
    ]

    isCollection [
	<category: '*Grease-GST-Core'>
	^true
    ]
]

Duration extend [
    
    milliseconds [
	<category: '*Grease-GST-Core'>
	^0
    ]
]

