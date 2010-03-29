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

Time class extend [

    totalSeconds [
	<category: '*Grease-GST-Core'>
	^self secondClock
    ]
]

Date class extend [
    
    year: y month: m day: d [
	<category: '*Grease-GST-Core'>
	^self new setDay: d monthIndex: m year: y
    ]
]

PositionableStream extend [
    
    greaseUpToAll: aCollection [
	"Needed for Seaside ports to other dialects where #upToAll: may have
	different semantics"
	^ self upToAll: aCollection
    ]
]

WriteStream extend [
    
    crlf [
	<category: '*Grease-GST-Core'>
	self 
	    nextPut: Character cr; 
	    nextPut: Character lf
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

    isKeyword [
	<category: '*Grease-GST-Core'>
	^self last = $:
    ]

    isUnary [
	<category: '*Grease-GST-Core'>
	^self isKeyword not and: [
	    self first isLetter]
    ]

    asMutator [
	<category: '*Grease-GST-Core'>
	"Return a setter message from a getter message. For example,
	#name asMutator returns #name:"
	^ (self copyWith: $:) asSymbol
    ]
]

String extend [

    reversed [
	<category: '*Grease-GST-Core'>
	^self reverse
    ]

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

    isFraction [
	<category: '*Grease-GST-Core'>
	^false
    ]

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

Integer extend [
    isZero [
	<category: '*Grease-GST-Core'>
	^self == 0
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

