GRSmallDictionaryTest subclass: GROrderedMultiMapTest [
    
    <comment: nil>
    <category: 'Grease-Tests-Core'>

    GROrderedMultiMapTest class >> shouldInheritSelectors [
	<category: 'testing'>
	^true
    ]

    allowsDuplicateKeys [
	<category: 'configuration'>
	^true
    ]

    collectionClass [
	<category: 'configuration'>
	^GROrderedMultiMap
    ]

    testAllAt [
	<category: 'tests-accessing'>
	self assert: (collection allAt: '1') = #().
	collection at: '1' add: 'foo'.
	collection at: '1' add: 'bar'.
	self assert: (collection allAt: '1') = #('foo' 'bar')
    ]

    testAllAtIfAbsent [
	<category: 'tests-accessing'>
	self assert: (collection allAt: '1' ifAbsent: ['absent']) = 'absent'.
	collection at: '1' add: 'foo'.
	collection at: '1' add: 'bar'.
	self assert: (collection allAt: '1' ifAbsent: ['absent']) = #('foo' 'bar')
    ]

    testAtAdd [
	<category: 'tests-accessing'>
	collection at: '1' add: 'foo'.
	collection at: '1' add: 'bar'.
	self assertAssociations: (Array with: '1' -> 'foo' with: '1' -> 'bar')
    ]
]

