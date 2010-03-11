TestCase subclass: GRCollectionTest [
    
    <comment: nil>
    <category: 'Grease-Tests-Core'>

    GRCollectionTest class >> isAbstract [
	<category: 'testing'>
	^self name = #GRCollectionTest
    ]

    allowsDuplicateValues [
	"Does the tested collection allow storage of duplicate (equal) values."

	<category: 'configuration'>
	self subclassResponsibility
    ]

    arbitraryCollection [
	"An general collection for testing. It should meet the needs of #duplicateElement,
	 #excludedElement, #includedElement, and so on where appropriate."

	<category: 'configuration'>
	^self collectionClass withAll: #(3 1 2 1 4)
    ]

    collectionClass [
	"Answer the collection class that is being tested."

	<category: 'configuration'>
	self subclassResponsibility
    ]

    duplicateElement [
	"Answer an element that appears multiple times in #arbitraryCollection."

	<category: 'configuration'>
	^1
    ]

    emptyCollection [
	"Answer an empty collection."

	<category: 'configuration'>
	^self collectionClass new
    ]

    excludedElement [
	"Answer an element that does not appear in #arbitraryCollection."

	<category: 'configuration'>
	^19
    ]

    includedElement [
	"Answer a (non-duplicate) element that does appear in #arbitraryCollection."

	<category: 'configuration'>
	^2
    ]

    isValidNewSequencedResponseClass: aClass [
	"Answer whether aClass is a valid return type for methods that return a new sequenced
	 collection. These are methods such as #copyFrom:to: or #reversed, which are
	 defined by ANSI for most classes to return the same class as the receiver.
	 For Interval (and may other cases), however, ANSI specifies that the response
	 may be any <sequencedReadableCollection."

	<category: 'configuration'>
	^self isSequencedReadable 
	    ifTrue: 
		[aClass == self collectionClass 
		    or: [aClass allSuperclasses includes: self collectionClass]]
	    ifFalse: [aClass == Array or: [aClass allSuperclasses includes: Array]]
    ]

    assert: aCollection sortedWith: sortBlock [
	"Assert that aCollection is correctly sorted according to sortBlock."

	<category: 'asserting'>
	1 to: aCollection size - 1
	    do: 
		[:index | 
		| a b |
		a := aCollection at: index.
		b := aCollection at: index + 1.
		self assert: ((sortBlock value: a value: b) 
			    or: [(sortBlock value: b value: a) not])]
    ]

    assert: responseCollection validSequencedNewResponseFrom: receiverCollection [
	"Assert that the returned object is, in fact a new object, and that it is
	 of a valid response class for the tested collection."

	<category: 'asserting'>
	self deny: responseCollection == receiverCollection.
	self 
	    assert: (self isValidNewSequencedResponseClass: responseCollection class)
    ]

    isExtensible [
	"Answer whether the tested Collection implements the <extensibleCollection>
	 protocol as defined in ANSI 5.7.5	."

	<category: 'testing-ansi'>
	self subclassResponsibility
    ]

    isInitializable [
	"Answer whether the tested Collection implements the <initializableCollection factory>
	 protocol as defined in ANSI 5.7.23."

	<category: 'testing-ansi'>
	self subclassResponsibility
    ]

    isSequenced [
	"Answer whether the tested Collection implements the <sequencedCollection>
	 protocol as defined in ANSI 5.7.12."

	<category: 'testing-ansi'>
	self subclassResponsibility
    ]

    isSequencedReadable [
	"Answer whether the tested Collection implements the <sequencedReadableCollection>
	 protocol as defined in ANSI 5.7.8."

	<category: 'testing-ansi'>
	self subclassResponsibility
    ]

    testAddFirst [
	<category: 'tests'>
	| collection |
	(self isExtensible and: [self isSequenced]) ifFalse: [^self].
	collection := self arbitraryCollection.
	collection addFirst: self excludedElement.
	self assert: (collection at: 1) = self excludedElement.
	self assert: (collection copyFrom: 2 to: collection size) 
		    = self arbitraryCollection
    ]

    testAny [
	<category: 'tests'>
	| collection |
	collection := self arbitraryCollection.
	self assert: ((self valuesOf: collection) includes: collection any)
    ]

    testCopyUpTo [
	<category: 'tests'>
	| collection sub |
	self isSequencedReadable ifFalse: [^self].

	"match first element"
	collection := self arbitraryCollection.
	sub := collection copyUpTo: (collection at: 1).
	self assert: sub validSequencedNewResponseFrom: collection.
	self assert: sub isEmpty.

	"no match"
	sub := collection copyUpTo: self excludedElement.
	self assert: sub validSequencedNewResponseFrom: collection.
	self assert: sub size = collection size.
	self assert: sub = collection.

	"match an element"
	sub := collection copyUpTo: self includedElement.
	self assert: sub validSequencedNewResponseFrom: collection.
	self assert: sub = (collection copyFrom: 1 to: sub size).
	self assert: (collection at: sub size + 1) = self includedElement.
	self allowsDuplicateValues 
	    ifTrue: 
		[sub := collection copyUpTo: self duplicateElement.
		self assert: sub validSequencedNewResponseFrom: collection.
		self assert: sub = (collection copyFrom: 1 to: sub size).
		self assert: (collection at: sub size + 1) = self duplicateElement.
		self deny: (sub includes: self duplicateElement)].

	"Make sure we're using equality"
	self isInitializable 
	    ifTrue: 
		[collection := self collectionClass withAll: #(1 '1').
		sub := collection copyUpTo: '1'.
		self assert: sub size = 1.
		self assert: (sub at: 1) = 1]
    ]

    testCopyUpToLast [
	<category: 'tests'>
	| collection sub |
	self isSequencedReadable ifFalse: [^self].

	"match first element"
	collection := self arbitraryCollection.
	sub := collection copyUpToLast: collection first.
	self assert: sub validSequencedNewResponseFrom: collection.
	self assert: sub isEmpty.

	"no match"
	sub := collection copyUpToLast: self excludedElement.
	self assert: sub validSequencedNewResponseFrom: collection.
	self assert: sub size = collection size.
	self assert: sub = collection.

	"match an element"
	sub := collection copyUpToLast: self includedElement.
	self assert: sub validSequencedNewResponseFrom: collection.
	self assert: sub = (collection copyFrom: 1 to: sub size).
	self assert: (collection at: sub size + 1) = self includedElement.
	self allowsDuplicateValues 
	    ifTrue: 
		[sub := collection copyUpToLast: self duplicateElement.
		self assert: sub validSequencedNewResponseFrom: collection.
		self assert: sub = (collection copyFrom: 1 to: sub size).
		self assert: (collection at: sub size + 1) = self duplicateElement.
		self assert: (sub includes: self duplicateElement)].

	"Make sure we're using equality"
	self isInitializable 
	    ifTrue: 
		[collection := self collectionClass withAll: #(1 '1').
		sub := collection copyUpToLast: '1'.
		self assert: sub size = 1.
		self assert: sub first = 1]
    ]

    testEmptyAny [
	<category: 'tests'>
	| collection |
	collection := self emptyCollection.
	self should: [(self valuesOf: collection) includes: collection any]
	    raise: Error
    ]

    testIsCollection [
	<category: 'tests'>
	self assert: self arbitraryCollection isCollection
    ]

    testNoneSatisfy [
	<category: 'tests'>
	| excluded included |
	excluded := self excludedElement.
	self 
	    assert: (self arbitraryCollection noneSatisfy: [:each | each = excluded]).
	included := self includedElement.
	self 
	    deny: (self arbitraryCollection noneSatisfy: [:each | each = included]).
	self assert: (self emptyCollection noneSatisfy: [:each | true])
    ]

    testNotEmpty [
	<category: 'tests'>
	self assert: self arbitraryCollection notEmpty.
	self deny: self emptyCollection notEmpty.
	self assert: self arbitraryCollection notEmpty.
	self deny: self emptyCollection notEmpty
    ]

    testSort [
	<category: 'tests'>
	| collection |
	self isSequenced ifFalse: [^self].
	collection := self arbitraryCollection.
	collection sort.
	self assert: collection sortedWith: [:a :b | a <= b].
	collection sort: [:a :b | a > b].
	self assert: collection sortedWith: [:a :b | a > b]
    ]

    testSorted [
	<category: 'tests'>
	| sorted collection |
	collection := self arbitraryCollection.
	sorted := collection sorted.
	self assert: sorted validSequencedNewResponseFrom: collection.
	self assert: sorted sortedWith: [:a :b | a <= b].
	sorted := collection sorted: [:a :b | a > b].
	self assert: sorted validSequencedNewResponseFrom: collection.
	self assert: sorted sortedWith: [:a :b | a > b]
    ]

    valuesOf: aCollection [
	"Answer the values of aCollecion. Dictionary tests override this."

	<category: 'private'>
	^aCollection
    ]
]

