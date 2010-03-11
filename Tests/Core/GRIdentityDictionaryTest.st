GRAbstractDictionaryTest subclass: GRIdentityDictionaryTest [
    
    <comment: nil>
    <category: 'Grease-Tests-Core'>

    collectionClass [
	<category: 'configuration'>
	^IdentityDictionary
    ]

    createArbitraryAssociations [
	<category: 'configuration'>
	^(OrderedCollection new)
	    add: 'c' -> 3;
	    add: 'a' -> 1;
	    add: 'b' -> 2;
	    add: 'd' -> 1;
	    add: 'b' copy -> 4;
	    yourself
    ]

    isKey: anObject equivalentTo: anotherObject [
	<category: 'configuration'>
	^anObject == anotherObject
    ]
]

