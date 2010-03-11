GRCollectionTest subclass: GRSetTest [
    
    <comment: nil>
    <category: 'Grease-Tests-Core'>

    allowsDuplicateValues [
	<category: 'configuration'>
	^false
    ]

    collectionClass [
	<category: 'configuration'>
	^Set
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

