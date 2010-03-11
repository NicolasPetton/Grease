TestCase subclass: GRSmallDictionaryTest [
    | collection |
    
    <comment: nil>
    <category: 'Grease-Tests-Core'>

    allowsDuplicateKeys [
	<category: 'configuration'>
	^false
    ]

    collectionClass [
	<category: 'configuration'>
	^GRSmallDictionary
    ]

    isKey: anObject equivalentTo: anotherObject [
	<category: 'configuration'>
	^anObject = anotherObject
    ]

    newCollection [
	<category: 'configuration'>
	^self collectionClass new
    ]

    assertAssociations: anOrderedCollection [
	<category: 'asserting'>
	| associations iterated |
	associations := collection associations.
	iterated := Array 
		    streamContents: [:stream | collection associationsDo: [:each | stream nextPut: each]].
	self assert: associations size = anOrderedCollection size.
	self assert: iterated size = anOrderedCollection size.
	1 to: anOrderedCollection size
	    do: 
		[:index | 
		self assert: (associations at: index) = (anOrderedCollection at: index).
		self assert: (iterated at: index) = (anOrderedCollection at: index)]
    ]

    setUp [
	<category: 'running'>
	super setUp.
	collection := self newCollection
    ]

    testAddAll [
	<category: 'tests-accessing'>
	| dict result |
	dict := (Dictionary new)
		    at: '1' put: 'foo';
		    yourself.
	result := collection addAll: dict.
	self assert: result == dict.
	self assertAssociations: (Array with: '1' -> 'foo').
	dict := (GROrderedMultiMap new)
		    at: '1' put: 'foo';
		    at: '1' add: 'bar';
		    yourself.
	collection := self newCollection.
	result := collection addAll: dict.
	self assert: result == dict.
	self assertAssociations: (self allowsDuplicateKeys 
		    ifFalse: [Array with: '1' -> 'bar']
		    ifTrue: [Array with: '1' -> 'foo' with: '1' -> 'bar'])
    ]

    testAddAndAssociations [
	<category: 'tests-accessing'>
	| association |
	association := collection add: '1' -> 'foo'.
	self assert: association key = '1'.
	self assert: association value = 'foo'.
	self assertAssociations: (Array with: '1' -> 'foo').
	association := collection add: '2' -> 'bar'.
	self assert: association key = '2'.
	self assert: association value = 'bar'.
	self assertAssociations: (Array with: '1' -> 'foo' with: '2' -> 'bar').
	association := collection add: '1' -> 'baz'.
	self assert: association key = '1'.
	self assert: association value = 'baz'.
	self assertAssociations: (self allowsDuplicateKeys 
		    ifFalse: [Array with: '1' -> 'baz' with: '2' -> 'bar']
		    ifTrue: 
			[Array 
			    with: '1' -> 'foo'
			    with: '2' -> 'bar'
			    with: '1' -> 'baz'])
    ]

    testAt [
	<category: 'tests-accessing'>
	self should: [collection at: '1'] raise: Error.
	collection add: '1' -> 'foo'.
	collection add: '1' -> 'bar'.
	self assert: (collection at: '1') 
		    = (self allowsDuplicateKeys ifTrue: ['foo'] ifFalse: ['bar'])
    ]

    testAtIfAbsent [
	<category: 'tests-accessing'>
	self assert: (collection at: '1' ifAbsent: ['foo']) = 'foo'.
	collection add: '1' -> 'bar'.
	collection add: '1' -> 'baz'.
	self assert: (collection at: '1' ifAbsent: ['foo']) 
		    = (self allowsDuplicateKeys ifTrue: ['bar'] ifFalse: ['baz'])
    ]

    testAtIfAbsentPut [
	<category: 'tests-accessing'>
	self assert: (collection at: '1' ifAbsentPut: ['foo']) = 'foo'.
	self assertAssociations: (Array with: '1' -> 'foo').
	self assert: (collection at: '1' ifAbsentPut: ['bar']) = 'foo'.
	self assertAssociations: (Array with: '1' -> 'foo')
    ]

    testAtIfPresent [
	<category: 'tests-accessing'>
	collection add: '1' -> 'foo'.
	collection add: '1' -> 'bar'.
	self assert: (collection at: '1' ifPresent: [:v | v , 'baz']) 
		    = (self allowsDuplicateKeys ifTrue: ['foobaz'] ifFalse: ['barbaz']).
	self assert: (collection at: '2' ifPresent: [:v | v , 'baz']) isNil
    ]

    testAtPut [
	<category: 'tests-accessing'>
	collection at: '1' put: 'foo'.
	collection at: '2' put: 'bar'.
	self assertAssociations: (Array with: '1' -> 'foo' with: '2' -> 'bar').
	collection at: '1' put: 'baz'.
	self assertAssociations: (Array with: '1' -> 'baz' with: '2' -> 'bar')
    ]

    testRemoveKey [
	<category: 'tests-accessing'>
	self should: [collection removeKey: '1'] raise: Error.
	collection add: '1' -> 'foo'.
	collection add: '1' -> 'bar'.
	collection add: '2' -> 'baz'.
	self assert: (collection removeKey: '1') 
		    = (self allowsDuplicateKeys ifTrue: [#('foo' 'bar')] ifFalse: ['bar']).
	self assertAssociations: (Array with: '2' -> 'baz').
	self assert: (collection removeKey: '2') 
		    = (self allowsDuplicateKeys ifTrue: [#('baz')] ifFalse: ['baz']).
	self assertAssociations: #()
    ]

    testRemoveKeyIfAbsent [
	<category: 'tests-accessing'>
	self assert: (collection removeKey: '1' ifAbsent: ['absent']) = 'absent'.
	collection add: '1' -> 'foo'.
	collection add: '1' -> 'bar'.
	collection add: '2' -> 'baz'.
	self assert: (collection removeKey: '1' ifAbsent: ['absent']) 
		    = (self allowsDuplicateKeys ifTrue: [#('foo' 'bar')] ifFalse: ['bar']).
	self assertAssociations: (Array with: '2' -> 'baz').
	self assert: (collection removeKey: '2' ifAbsent: ['absent']) 
		    = (self allowsDuplicateKeys ifTrue: [#('baz')] ifFalse: ['baz']).
	self assertAssociations: #()
    ]

    testSize [
	<category: 'tests-accessing'>
	self assert: collection size = 0.
	collection add: '1' -> 'foo'.
	self assert: collection size = 1.
	collection add: '2' -> 'bar'.
	self assert: collection size = 2.
	collection add: '1' -> 'baz'.
	self assert: collection size 
		    = (self allowsDuplicateKeys ifTrue: [3] ifFalse: [2])
    ]

    testCopy [
	<category: 'tests'>
	| other |
	collection
	    at: 1 put: 'foo';
	    at: 2 put: 'bar'.
	other := collection copy.
	collection
	    at: 1 put: 'zork';
	    at: 3 put: 'zonk'.
	other at: 2 put: 'other'.
	self assert: collection size = 3.
	self assert: (collection at: 1) = 'zork'.
	self assert: (collection at: 2) = 'bar'.
	self assert: (collection at: 3) = 'zonk'.
	self assert: other size = 2.
	self assert: (other at: 1) = 'foo'.
	self assert: (other at: 2) = 'other'
    ]

    testGrow [
	<category: 'tests'>
	1 to: 100
	    do: 
		[:i | 
		collection at: i put: i negated.
		self assert: collection size = i.
		
		[:array :factor | 
		self assert: array size = i.
		1 to: i do: [:j | self assert: (array at: j) = (factor * j)]]
		    value: collection keys value: 1;
		    value: collection values value: -1]
    ]

    testWithAll [
	<category: 'tests'>
	| dict |
	dict := (Dictionary new)
		    at: '1' put: 'foo';
		    yourself.
	collection := self collectionClass withAll: dict.
	self assertAssociations: (Array with: '1' -> 'foo').
	dict := (GROrderedMultiMap new)
		    at: '1' put: 'foo';
		    at: '1' add: 'bar';
		    yourself.
	collection := self collectionClass withAll: dict.
	self assertAssociations: (self allowsDuplicateKeys 
		    ifFalse: [Array with: '1' -> 'bar']
		    ifTrue: [Array with: '1' -> 'foo' with: '1' -> 'bar'])
    ]

    testDo [
	<category: 'tests-enumerating'>
	| result |
	result := OrderedCollection new.
	collection
	    at: '1' put: 'foo';
	    at: '2' put: 'bar'.
	collection do: [:each | result add: each].
	self assert: result asArray = #('foo' 'bar')
    ]

    testKeys [
	<category: 'tests-enumerating'>
	collection
	    add: '1' -> 'foo';
	    add: '2' -> 'bar';
	    add: '1' -> 'baz'.
	self assert: collection keys 
		    = (self allowsDuplicateKeys ifTrue: [#('1' '2' '1')] ifFalse: [#('1' '2')])
    ]

    testKeysAndValuesDo [
	<category: 'tests-enumerating'>
	| iterated |
	collection keysAndValuesDo: [:key :value | self assert: false].
	collection
	    add: '1' -> 'foo';
	    add: '2' -> 'bar';
	    add: '1' -> 'baz'.
	iterated := Array streamContents: 
			[:stream | 
			collection keysAndValuesDo: [:key :value | stream nextPut: key -> value]].
	self 
	    assert: iterated size = (self allowsDuplicateKeys ifTrue: [3] ifFalse: [2]).
	self assert: iterated first 
		    = (self allowsDuplicateKeys ifTrue: ['1' -> 'foo'] ifFalse: ['1' -> 'baz']).
	self assert: iterated second = ('2' -> 'bar').
	self allowsDuplicateKeys 
	    ifTrue: [self assert: iterated third = ('1' -> 'baz')]
    ]

    testKeysDo [
	<category: 'tests-enumerating'>
	| result |
	result := OrderedCollection new.
	collection
	    add: '1' -> 'foo';
	    add: '2' -> 'bar';
	    add: '1' -> 'baz'.
	collection keysDo: [:each | result add: each].
	self assert: result asArray 
		    = (self allowsDuplicateKeys ifTrue: [#('1' '2' '1')] ifFalse: [#('1' '2')])
    ]

    testValues [
	<category: 'tests-enumerating'>
	collection
	    add: '1' -> 'foo';
	    add: '2' -> 'bar';
	    add: '1' -> 'baz'.
	self 
	    assert: collection values = (self allowsDuplicateKeys 
			    ifTrue: [#('foo' 'bar' 'baz')]
			    ifFalse: [#('baz' 'bar')])
    ]

    testIncludesKey [
	<category: 'tests-testing'>
	self deny: (collection includesKey: '1').
	collection add: '1' -> 'foo'.
	collection add: '1' -> 'bar'.
	self assert: (collection includesKey: '1')
    ]

    testIsCollection [
	<category: 'tests-testing'>
	self assert: collection isCollection
    ]

    testIsDictionary [
	<category: 'tests-testing'>
	self assert: collection isDictionary
    ]

    testIsEmpty [
	<category: 'tests-testing'>
	self assert: collection isEmpty.
	collection add: '1' -> 'foo'.
	collection add: '1' -> 'bar'.
	self deny: collection isEmpty
    ]
]

