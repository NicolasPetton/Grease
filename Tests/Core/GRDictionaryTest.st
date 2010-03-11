GRAbstractDictionaryTest subclass: GRDictionaryTest [
    
    <comment: nil>
    <category: 'Grease-Tests-Core'>

    collectionClass [
	<category: 'configuration'>
	^Dictionary
    ]

    createArbitraryAssociations [
	<category: 'configuration'>
	^(OrderedCollection new)
	    add: #c -> 3;
	    add: #a -> 1;
	    add: #b -> 2;
	    add: #e -> 1;
	    add: #d -> 4;
	    yourself
    ]

    isKey: anObject equivalentTo: anotherObject [
	<category: 'configuration'>
	^anObject = anotherObject
    ]
]

