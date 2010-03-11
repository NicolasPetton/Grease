GRObject subclass: GRObjectStub [
    | foo |
    
    <comment: nil>
    <category: 'Grease-Tests-Core'>

    foo [
	<category: 'accessing'>
	^foo
    ]

    initialize [
	<category: 'initialization'>
	super initialize.
	foo := true
    ]
]

