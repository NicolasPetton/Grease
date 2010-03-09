Eval [
    'From PharoCore1.0rc1 of 19 October 2009 [Latest update: #10505] on 9 March 2010 at 6:45:25 pm'
]



GRPrinter subclass: GRUnitPrinter [
    | integerPrinter fractionPrinter units base |
    
    <comment: nil>
    <category: 'Grease-Core-Text'>

    GRUnitPrinter class >> base: anInteger units: anArray [
	<category: 'instance creation'>
	^(self new)
	    base: anInteger;
	    units: anArray;
	    yourself
    ]

    base: anInteger [
	<category: 'accessing'>
	base := anInteger
    ]

    fractionPrinter: aPrinter [
	<category: 'accessing'>
	fractionPrinter := aPrinter
    ]

    integerPrinter: aPrinter [
	<category: 'accessing'>
	integerPrinter := aPrinter
    ]

    units: anArray [
	<category: 'accessing'>
	units := anArray
    ]

    initialize [
	<category: 'initialization'>
	super initialize.
	self integerPrinter: ((GRNumberPrinter new)
		    precision: 0;
		    yourself).
	self fractionPrinter: ((GRNumberPrinter new)
		    precision: 1;
		    yourself)
    ]

    print: anObject on: aStream [
	<category: 'printing'>
	anObject = 1 
	    ifTrue: 
		[^self 
		    print: anObject
		    unit: units first
		    on: aStream].
	units allButFirst inject: anObject asFloat
	    into: 
		[:value :each | 
		value < base 
		    ifFalse: [value / base]
		    ifTrue: 
			[^self 
			    print: value
			    unit: each
			    on: aStream]]
    ]

    print: aNumber unit: aString on: aStream [
	<category: 'printing'>
	(units first = aString or: [units second = aString]) 
	    ifTrue: [integerPrinter print: aNumber on: aStream]
	    ifFalse: [fractionPrinter print: aNumber on: aStream].
	aStream
	    nextPut: $ ;
	    nextPutAll: aString
    ]
]

