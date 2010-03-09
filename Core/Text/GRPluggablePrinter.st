GRPrinter subclass: GRPluggablePrinter [
    | block |
    
    <comment: nil>
    <category: 'Grease-Core-Text'>

    GRPluggablePrinter class >> on: aBlock [
	<category: 'instance creation'>
	^self new block: aBlock
    ]

    block: aBlock [
	<category: 'accessing'>
	block := aBlock
    ]

    initialize [
	<category: 'initialization'>
	super initialize.
	self block: [:value | String new]
    ]

    print: anObject on: aStream [
	<category: 'printing'>
	aStream nextPutAll: (block value: anObject)
    ]
]

