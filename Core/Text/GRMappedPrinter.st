GRPrinter subclass: GRMappedPrinter [
    | next block |
    
    <comment: nil>
    <category: 'Grease-Core-Text'>

    GRMappedPrinter class >> block: aBlock next: aPrinter [
	<category: 'instance creation'>
	^(self new)
	    block: aBlock;
	    next: aPrinter;
	    yourself
    ]

    block: aBlock [
	<category: 'accessing'>
	block := aBlock
    ]

    next: aPrinter [
	<category: 'accessing'>
	next := aPrinter
    ]

    initialize [
	<category: 'initialization'>
	super initialize.
	self block: [:value | value]
    ]

    print: anObject on: aStream [
	<category: 'printing'>
	next print: (block value: anObject) on: aStream
    ]
]

