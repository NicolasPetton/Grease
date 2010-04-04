GRObject subclass: GRSmallDictionary [
    | size keys values  |
    
    <category: 'Grease-Core-Collections'>
    <comment: 'I am an implementation of a dictionary. Compared to other dictionaries I am very efficient for small sizes, speed- and space-wise. I also remember the order in which elements are added, some of my users might depend on that. My implementation features some ideas from the RefactoringBrowser.'>

    GRSmallDictionary class [

	new [
	    <category: 'instance-creation'>
	    ^self new: 3
	]

	new: anInteger [
	    <category: 'instance-creation'>
	    ^self basicNew initialize: anInteger
	]

	withAll: aCollection [
	    <category: 'instance creation'>
	    ^self new addAll: aCollection; yourself
	]
]

    initialize: anInteger [
        <category: 'initialization'>
        size := 0.
        keys := Array new: anInteger.
        values := Array new: anInteger
    ]

    isEmpty [
        <category: 'testing'>
        ^size = 0
    ]

    isDictionary [
	<category: 'testing'>
	^true
    ]

    isCollection [
	<category: 'testing'>
	^true
    ]

    add: anAssociation [
	<category: 'accessing'>
	self at: anAssociation key put: anAssociation value.
	^anAssociation
    ]

    addAll: aDictionary [
	<category: 'accessing'>
	aDictionary keysAndValuesDo: [ :key :value | self add: key -> value ].
	^aDictionary
    ]

    at: aKey [
        "Answer the value associated with aKey. Raise an exception, if no such key is defined."
    
        <category: 'accessing'>
        ^self at: aKey ifAbsent: [self errorKeyNotFound]
    ]

    at: aKey ifAbsent: aBlock [
        "Answer the value associated with aKey. Evaluate aBlock, if no such key is defined."
    
        <category: 'accessing'>
        | index |
        index := self findIndexFor: aKey.
        ^index = 0 ifFalse: [values at: index] ifTrue: [aBlock value]
    ]

    at: aKey ifAbsentPut: aBlock [
        "Answer the value associated with aKey. Evaluate aBlock, if no such key is defined and store the return value."
    
        <category: 'accessing'>
        | index |
        index := self findIndexFor: aKey.
        ^index = 0 
            ifFalse: [values at: index]
            ifTrue: [self privateAt: aKey put: aBlock value]
    ]

    at: aKey ifPresent: aBlock [
        "Lookup aKey in the receiver. If it is present, answer the value of evaluating the given block with the value associated with the key. Otherwise, answer nil."
    
        <category: 'accessing'>
        | index |
        index := self findIndexFor: aKey.
        ^index = 0 ifFalse: [aBlock value: (values at: index)]
    ]

    at: aKey put: aValue [
        "Set the value of aKey to be aValue."
    
        <category: 'accessing'>
        | index |
        index := self findIndexFor: aKey.
        ^index = 0 
            ifFalse: [values at: index put: aValue]
            ifTrue: [self privateAt: aKey put: aValue]
    ]

    includesKey: aKey [
        "Answer whether the receiver has a key equal to aKey."
    
        <category: 'testing'>
        ^(self findIndexFor: aKey) ~= 0
    ]

    keys [
        <category: 'enumerating'>
        ^keys copyFrom: 1 to: size
    ]

    associations [
        "Answer a Collection containing the receiver's associations."
    
        <category: 'accessing'>
        | result |
        result := WriteStream on: (Array new: self size).
        self associationsDo: [:assoc | result nextPut: assoc].
        ^result contents
    ]

    associationsDo: aBlock [
        <category: 'enumerating'>
        self keysAndValuesDo: [:key :value | aBlock value: key -> value]
    ]

    do: aBlock [
	<category: 'enumerating'>
	1 to: size do: [ :index | aBlock value: (values at: index) ]
    ]

    keysAndValuesDo: aBlock [
        <category: 'enumerating'>
        1 to: size
            do: [:index | aBlock value: (keys at: index) value: (values at: index)]
    ]

    postCopy [
        <category: 'copying'>
        super postCopy.
        keys := keys copy.
        values := values copy
    ]

    size [
        <category: 'accessing'>
        ^size
    ]

    grow [
        <category: 'private'>
        | newKeys newValues |
        newKeys := Array new: 2 * size.
        newValues := Array new: 2 * size.
        1 to: size
            do: 
            [:index | 
            newKeys at: index put: (keys at: index).
            newValues at: index put: (values at: index)].
        keys := newKeys.
        values := newValues
    ]

    errorKeyNotFound [
        <category: 'private'>
        self error: 'Key not found'
    ]

    findIndexFor: aKey [
        <category: 'private'>
        1 to: size do: [:index | (keys at: index) = aKey ifTrue: [^index]].
        ^0
    ]

    removeIndex: index [
	<category: 'private'>
	| value |
	value := values at: index.
	index to: size - 1 do:
			[ :i | 
			keys at: i put: (keys at: i + 1).
			values at: i put: (values at: i + 1) ].
	keys at: size put: nil.
	values at: size put: nil.
	size := size - 1.
	^ value
    ]

    privateAt: aKey put: aValue [
        <category: 'private'>
        size = keys size ifTrue: [self grow].
        keys at: (size := size + 1) put: aKey.
        ^values at: size put: aValue
    ]

    values [
        <category: 'enumerating'>
        ^values copyFrom: 1 to: size
    ]

    valuesDo: aBlock [
        <category: 'enumerating'>
        1 to: size do: [:index | aBlock value: (values at: index)]
    ]

    removeKey: aKey [
        "Remove aKey from the receiver, raise an exception if the element is missing."
    
        <category: 'accessing'>
        ^self removeKey: aKey ifAbsent: [self errorKeyNotFound]
    ]

    keysDo: aBlock [
        <category: 'enumerating'>
        1 to: size do: [:each | aBlock value: (keys at: each)]
    ]

    removeKey: aKey ifAbsent: aBlock [
        "Remove aKey from the receiver, evaluate aBlock if the element is missing."
    
        <category: 'accessing'>
        | index value |
        index := self findIndexFor: aKey.
        index = 0 ifTrue: [^aBlock value].
        value := values at: index.
        index to: size - 1
            do: 
            [:i | 
            keys at: i put: (keys at: i + 1).
            values at: i put: (values at: i + 1)].
        keys at: size put: nil.
        values at: size put: nil.
        size := size - 1.
        ^value
    ]

]

