GRPrinter subclass: GRSignPrinter [
    | negativePrinter positivePrinter |
    
    <comment: nil>
    <category: 'Grease-Core-Text'>

    negativePrinter: aPrinter [
	"The printer to be used when the number is negative."

	<category: 'accessing'>
	negativePrinter := aPrinter
    ]

    positivePrinter: aPrinter [
	"The printer to be used when the number is zero or positive."

	<category: 'accessing'>
	positivePrinter := aPrinter
    ]

    initialize [
	<category: 'initialization'>
	super initialize.
	self negativePrinter: $-.
	self positivePrinter: nil
    ]

    print: anObject on: aStream [
	<category: 'printing'>
	anObject negative 
	    ifTrue: [negativePrinter print: anObject on: aStream]
	    ifFalse: [positivePrinter print: anObject on: aStream]
    ]
]

