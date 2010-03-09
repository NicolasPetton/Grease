GRPrinter subclass: GRSequentialPrinter [
    | parts |
    
    <comment: nil>
    <category: 'Grease-Core-Text'>

    initialize [
	<category: 'initialization'>
	super initialize.
	parts := OrderedCollection new
    ]

    , aConverter [
	<category: 'operators'>
	parts add: aConverter
    ]

    print: anObject on: aStream [
	<category: 'printing'>
	parts do: [:each | each print: anObject on: aStream]
    ]
]
