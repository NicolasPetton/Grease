GRCollectionTest subclass: GROrderedCollectionTest [
    
    <comment: nil>
    <category: 'Grease-Tests-Core'>

    allowsDuplicateValues [
	<category: 'configuration'>
	^true
    ]

    collectionClass [
	<category: 'configuration'>
	^OrderedCollection
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
	^true
    ]

    isSequencedReadable [
	<category: 'testing-ansi'>
	^true
    ]
]

