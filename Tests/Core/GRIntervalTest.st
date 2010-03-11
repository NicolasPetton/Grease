GRCollectionTest subclass: GRIntervalTest [
    
    <comment: nil>
    <category: 'Grease-Tests-Core'>

    allowsDuplicateValues [
	<category: 'configuration'>
	^false
    ]

    arbitraryCollection [
	<category: 'configuration'>
	^1 to: 4
    ]

    collectionClass [
	<category: 'configuration'>
	^Interval
    ]

    emptyCollection [
	<category: 'configuration'>
	^1 to: 0
    ]

    isValidNewSequencedResponseClass: aClass [
	<category: 'configuration'>
	^aClass == SequenceableCollection 
	    or: [aClass allSuperclasses includes: SequenceableCollection]
    ]

    isExtensible [
	<category: 'testing-ansi'>
	^false
    ]

    isInitializable [
	<category: 'testing-ansi'>
	^false
    ]

    isSequenced [
	<category: 'testing-ansi'>
	^false
    ]

    isSequencedReadable [
	<category: 'testing-ansi'>
	^true
    ]
]

