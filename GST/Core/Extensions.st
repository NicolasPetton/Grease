GRPackage class extend [ 
    
    greaseGSTCore [
	<category: '*Grease-GST-Core'>
	^(self new)
	    name: 'Grease-GST-Core';
	    addDependency: 'Grease-Core';
	    url: #gstUrl;
	    yourself
    ]

    greaseTestsGSTCore [
	<category: '*Grease-Tests-GST-Core'>
	^(self new)
	    name: 'Grease-Tests-GST-Core';
	    description: 'Unit tests for the package Grease-GST-Core.';
	    addDependency: 'Grease-GST-Core';
	    addDependency: 'Grease-Tests-Core';
	    url: #gstUrl;
	    yourself
    ]
]

GRPackage extend [
    
    gstUrl [
	<category: '*Grease-GST-Core'>
	^'http://git.savannah.gnu.org/r/smalltalk.git/'
    ]
]

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

Interval extend [
    
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

Random extend [
    
    nextInt: anInteger [
	<category: '*Grease-GST-Core'>
	anInteger strictlyPositive ifFalse: [ self error: 'Range must be positive' ].
	^(self next * anInteger) truncated + 1
    ]

]

DirectedMessage extend [

    value: firstArgument value: secondArgument [
	<category: '*Grease-GST-Core'>
	self valueWithArguments: (Array with: firstArgument with: secondArgument)
    ]

    valueWithPossibleArguments: anArray [
	<category: '*Grease-GST-Core'>
	| arguments |
	arguments := Array new: self selector numArgs.
	arguments replaceFrom: 1
		to: (args size min: arguments size)
		with: args
		startingAt: 1.
	arguments size > args size ifTrue: [
		arguments replaceFrom: args size + 1
			to: (args size + anArray size min: arguments size)
			with: anArray
			startingAt: 1].
	^self valueWithArguments: arguments
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
	^(UnicodeCharacter codePoint: self codePoint) value
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

Float class extend [
    
    nan [
	<category: '*Grease-GST-Core'>
	"Why a FloatD?"
	^FloatD nan
    ]

    infinity [
	<category: '*Grease-GST-Core'>
	"Why a FloatD?"
	^FloatD infinity
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

