GRCollectionTest subclass: GRBagTest [
    
    <comment: nil>
    <category: 'Grease-Tests-Core'>

    allowsDuplicateValues [
	<category: 'configuration'>
	^true
    ]

    collectionClass [
	<category: 'configuration'>
	^Bag
    ]

    isExtensible [
	<category: 'testing-ansi'>
	^true
    ]

    isInitializable [
	<category: 'testing-ansi'>
	^true
    ]

    isSequenced [
	<category: 'testing-ansi'>
	^false
    ]

    isSequencedReadable [
	<category: 'testing-ansi'>
	^false
    ]
]

