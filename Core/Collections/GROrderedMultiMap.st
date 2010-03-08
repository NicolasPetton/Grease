GRSmallDictionary subclass: GROrderedMultiMap [
    
    <comment: 'I am an implementation of an ordered multi-map. I allow multiple values to be associated with the same key and maintain the order of addition. #at: and its derivatives all operate on the first matching key, while #allAt: returns the complete list of values for a key in the order they were added.'>
    <category: 'Grease-Core-Collections'>

    add: anAssociation [
	<category: 'accessing'>
	self privateAt: anAssociation key put: anAssociation value.
	^anAssociation
    ]

    allAt: aKey [
	<category: 'accessing'>
	^Array streamContents: [:stream | 
	    1 to: size do: [:index | 
		(keys at: index) = aKey ifTrue: [
		    stream nextPut: (values at: index)]]]
    ]

    allAt: aKey ifAbsent: absentBlock [
	<category: 'accessing'>
	| results |
	results := self allAt: aKey.
	^results isEmpty ifTrue: [absentBlock value] ifFalse: [results]
    ]

    at: aKey add: aValue [
	"Add an association between aKey and aValue. Do not replace existing
	 values with the same key."

	<category: 'accessing'>
	^self privateAt: aKey put: aValue
    ]

    removeKey: aKey ifAbsent: aBlock [
	"Remove aKey from the receiver, evaluate aBlock if the element is missing."

	"This is inefficient and could be optimized."

	<category: 'accessing'>
	| removed |
	removed := Array streamContents: [:stream | | index |
	    [(index := self findIndexFor: aKey) = 0] 
		whileFalse: [stream nextPut: (self removeIndex: index)]].
	^removed isEmpty ifTrue: [aBlock value] ifFalse: [removed]
    ]
]

