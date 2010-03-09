GRPrinter subclass: GRNumberPrinter [
    | characters base delimiter digits infinite nan padding accuracy precision separator |
    
    <comment: 'A GRNumberPrinter is prints numbers (integers and floats) in various formats in a platform independent way.
    
    Instance Variables
    accuracy:		<UndefinedObject|Float>
    base:			<Integer>
    delimiter:		<UndefinedObject|Charater>
    digits:			<UndefinedObject|Integer>
    infinite:		<UndefinedObject|String>
    nan:			<UndefinedObject|String>
    padding:		<UndefinedObject|Charater>
    precision:		<Integer>
    separator:		<UndefinedObject|Charater>'>
    <category: 'Grease-Core-Text'>

    NumbersToCharactersLowercase := nil.
    NumbersToCharactersUppercase := nil.

    GRNumberPrinter class >> initialize [
	<category: 'initialization'>
	NumbersToCharactersLowercase := '0123456789abcdefghijklmnopqrstuvwxyz'.
	NumbersToCharactersUppercase := '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ'
    ]

    accuracy: aFloat [
	"Round towards the nearest number that is a multiple of aFloat."

	<category: 'accessing'>
	accuracy := aFloat
    ]

    base: anInteger [
	"The numeric base to which the number should be printed."

	<category: 'accessing'>
	base := anInteger
    ]

    characters: aString [
	"The characters to be used to convert a number to a string."

	<category: 'accessing'>
	characters := aString
    ]

    delimiter: aCharacter [
	"The delimiter to separate the integer and fraction part of the number."

	<category: 'accessing'>
	delimiter := aCharacter
    ]

    digits: anInteger [
	"The number of digits to be printed in the integer part."

	<category: 'accessing'>
	digits := anInteger
    ]

    infinite: aString [
	"The string that should be displayed if the number is positive or negative infinity."

	<category: 'accessing'>
	infinite := aString
    ]

    nan: aString [
	"The string that should be displayed if the number is not a number."

	<category: 'accessing'>
	nan := aString
    ]

    padding: aCharacter [
	"The padding for the integer part."

	<category: 'accessing'>
	padding := aCharacter
    ]

    precision: anInteger [
	"The number of digits to be printed in the fraction part."

	<category: 'accessing'>
	precision := anInteger
    ]

    separator: aCharacter [
	"Separator character to be used to group digits."

	<category: 'accessing'>
	separator := aCharacter
    ]

    lowercase [
	"Use lowercase characters for numbers of base 10 and higher."

	<category: 'actions'>
	self characters: NumbersToCharactersLowercase
    ]

    uppercase [
	"Use uppercase characters for numbers of base 10 and higher."

	<category: 'actions'>
	self characters: NumbersToCharactersUppercase
    ]

    initialize [
	<category: 'initialization'>
	super initialize.
	self lowercase.
	self base: 10.
	self delimiter: $..
	self infinite: 'Infinite'.
	self nan: 'NaN'.
	self padding: $ .
	self precision: 0
    ]

    print: aNumber on: aStream [
	<category: 'printing'>
	aNumber isNaN ifTrue: [^self printNaN: aNumber on: aStream].
	aNumber isInfinite ifTrue: [^self printInfinite: aNumber on: aStream].
	precision = 0 
	    ifTrue: [self printInteger: aNumber on: aStream]
	    ifFalse: [self printFloat: aNumber on: aStream]
    ]

    printFloat: aNumber on: aStream [
	<category: 'printing'>
	| multiplier rounded |
	multiplier := base asFloat raisedTo: precision.
	rounded := aNumber roundTo: (accuracy ifNil: [1.0 / multiplier]).
	self printInteger: rounded on: aStream.
	delimiter isNil ifFalse: [aStream nextPut: delimiter].
	self printFraction: rounded fractionPart abs * multiplier on: aStream
    ]

    printFraction: aNumber on: aStream [
	<category: 'printing'>
	| result |
	result := self 
	    pad: (self digitsOf: aNumber rounded base: base)
	    left: $0
	    to: precision.
	separator isNil ifFalse: [result := self separate: result left: separator].
	aStream nextPutAll: result
    ]

    printInfinite: aNumber on: aStream [
	<category: 'printing'>
	infinite isNil ifFalse: [aStream nextPutAll: infinite]
    ]

    printInteger: aNumber on: aStream [
	<category: 'printing'>
	| result |
	result := self digitsOf: aNumber integerPart base: base.
	separator isNil 
	    ifFalse: [result := self separate: result right: separator].
	(digits isNil or: [padding isNil]) 
	    ifFalse: [result := self 
		pad: result
		left: padding
		to: digits].
	aStream nextPutAll: result
    ]

    printNaN: anInteger on: aStream [
	<category: 'printing'>
	nan isNil ifFalse: [aStream nextPutAll: nan]
    ]

    digitsOf: aNumber base: aBaseInteger [
	"Answer the absolute digits of aNumber in the base aBaseInteger."

	<category: 'utilities'>
	| integer stream next |
	integer := aNumber truncated abs.
	integer = 0 ifTrue: [^'0'].
	stream := WriteStream on: (String new: 10).
	[integer > 0] whileTrue: 
	    [next := integer quo: aBaseInteger.
	    stream nextPut: (characters at: 1 + integer - (next * aBaseInteger)).
	    integer := next].
	^stream contents reversed
    ]

    separate: aString left: aCharacter [
	"Separate from the left side every 3 characters with aCharacter."

	<category: 'utilities'>
	| size stream |
	size := aString size.
	stream := WriteStream on: (String new: 2 * size).
	1 
	    to: size
	    do: [:index | 
		(index ~= 1 and: [index \\ 3 = 1]) ifTrue: [stream nextPut: aCharacter].
		stream nextPut: (aString at: index)].
	^stream contents
    ]

    separate: aString right: aCharacter [
	"Separate from the right side every 3 characters with aCharacter."

	<category: 'utilities'>
	| size stream |
	size := aString size.
	stream := WriteStream on: (String new: 2 * size).
	1 
	    to: size
	    do: [:index | 
		(index ~= 1 and: [(size - index) \\ 3 = 2]) 
		    ifTrue: [stream nextPut: aCharacter].
		stream nextPut: (aString at: index)].
	^stream contents
    ]
]



Eval [
    GRNumberPrinter initialize
]
