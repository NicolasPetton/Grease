GRNotification subclass: GRNotificationStub [
    | foo |
    
    <comment: nil>
    <category: 'Grease-Tests-Core'>

    defaultAction [
	<category: 'accessing'>
	^#returnValue
    ]

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

