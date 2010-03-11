GRError subclass: GRErrorStub [
    | foo |
    
    <category: 'Grease-Tests-Core'>
    <comment: nil>

    initialize [
	<category: 'initialization'>
	super initialize.
	foo := true
    ]

    foo [
	<category: 'accessing'>
	^foo
    ]
]
