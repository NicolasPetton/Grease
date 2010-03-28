Behavior extend [
    
    fullName [
	<category: '*Grease-GST-Core'>
	^self nameIn: Smalltalk
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

