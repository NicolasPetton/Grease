GRCollectionTest subclass: GRArrayTest [
    
    <comment: nil>
    <category: 'Grease-Tests-Core'>

    allowsDuplicateValues [
	<category: 'configuration'>
	^true
    ]

    collectionClass [
	<category: 'configuration'>
	^Array
    ]

    isExtensible [
	<category: 'testing-ansi'>
	^false
    ]

    isInitializable [
	<category: 'testing-ansi'>
	^true
    ]

    isSequenced [
	<category: 'testing-ansi'>
	^true
    ]

    isSequencedReadable [
	<category: 'testing-ansi'>
	^true
    ]
]

