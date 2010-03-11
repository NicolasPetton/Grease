GRCollectionTest subclass: GRAbstractDictionaryTest [
    | associations |
    
    <comment: nil>
    <category: 'Grease-Tests-Core'>

    GRAbstractDictionaryTest class >> isAbstract [
	<category: 'testing'>
	^self name = #GRAbstractDictionaryTest
    ]

    allowsDuplicateValues [
	<category: 'configuration'>
	^true
    ]

    arbitraryAssociations [
	<category: 'configuration'>
	^associations ifNil: [associations := self createArbitraryAssociations]
    ]

    arbitraryCollection [
	<category: 'configuration'>
	| dict |
	dict := self emptyCollection.
	self arbitraryAssociations do: [:each | dict at: each key put: each value].
	^dict
    ]

    createArbitraryAssociations [
	<category: 'configuration'>
	self subclassResponsibility
    ]

    isKey: anObject equivalentTo: anotherObject [
	<category: 'configuration'>
	self subclassResponsibility
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
	^false
    ]

    testAssociationsDo [
	<category: 'tests'>
	| collection assocs count |
	collection := self arbitraryCollection.
	assocs := self arbitraryAssociations copy.
	count := 0.
	collection associationsDo: 
		[:assoc | 
		| size |
		count := count + 1.
		size := assocs size.
		assocs := assocs reject: 
				[:each | 
				(self isKey: each key equivalentTo: assoc key) 
				    and: [each value = assoc value]].
		self assert: size - 1 = assocs size].
	self assert: assocs isEmpty.
	self assert: count = self arbitraryAssociations size
    ]

    valuesOf: aCollection [
	<category: 'private'>
	^aCollection values
    ]
]

