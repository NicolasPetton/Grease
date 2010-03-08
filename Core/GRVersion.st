GRObject subclass: GRVersion [
    | major minor revision stageLabel stageNumber |
    
    <comment: nil>
    <category: 'Grease-Core'>

    GRVersion class >> major: majorInteger [
	<category: 'instance creation'>
	^self major: majorInteger minor: nil
    ]

    GRVersion class >> major: majorInteger minor: minorInteger [
	<category: 'instance creation'>
	^self 
	    major: majorInteger
	    minor: minorInteger
	    revision: nil
    ]

    GRVersion class >> major: majorInteger minor: minorInteger revision: revisionInteger [
	<category: 'instance creation'>
	^(self basicNew)
	    initializeWithMajor: majorInteger
		minor: minorInteger
		revision: revisionInteger;
	    yourself
    ]

    GRVersion class >> new [
	<category: 'instance creation'>
	^self major: 1
    ]

    initializeWithMajor: majorInteger minor: minorInteger revision: revisionInteger [
	<category: 'initialization'>
	self initialize.
	major := majorInteger.
	minor := minorInteger.
	revision := revisionInteger
    ]

    < otherVersion [
	<category: 'comparing'>
	major < otherVersion major ifTrue: [^true].
	otherVersion major < major ifTrue: [^false].
	(minor ifNil: [0]) < (otherVersion minor ifNil: [0]) ifTrue: [^true].
	(otherVersion minor ifNil: [0]) < (minor ifNil: [0]) ifTrue: [^false].
	(revision ifNil: [0]) < (otherVersion revision ifNil: [0]) ifTrue: [^true].
	(otherVersion revision ifNil: [0]) < (revision ifNil: [0]) 
	    ifTrue: [^false].
	stageLabel = otherVersion stage 
	    ifTrue: [^(stageNumber ifNil: [1]) < (otherVersion stageNumber ifNil: [1])].
	stageLabel isNil ifTrue: [^false].
	otherVersion stage isNil ifTrue: [^true].
	^stageLabel < otherVersion stage
    ]

    <= otherVersion [
	<category: 'comparing'>
	^(self > otherVersion) not
    ]

    = otherVersion [
	<category: 'comparing'>
	^major = otherVersion major and: 
		[(minor ifNil: [0]) = (otherVersion minor ifNil: [0]) and: 
			[(revision ifNil: [0]) = (otherVersion revision ifNil: [0]) and: 
				[stageLabel = otherVersion stage 
				    and: [(stageNumber ifNil: [1]) = (otherVersion stageNumber ifNil: [1])]]]]
    ]

    > otherVersion [
	<category: 'comparing'>
	^otherVersion < self
    ]

    >= otherVersion [
	<category: 'comparing'>
	^(self < otherVersion) not
    ]

    hash [
	<category: 'comparing'>
	^(major hash bitXor: minor hash) bitXor: revision hash
    ]

    beAlpha [
	<category: 'convenience'>
	self beAlpha: nil
    ]

    beAlpha: anInteger [
	<category: 'convenience'>
	self stage: #alpha number: anInteger
    ]

    beBeta [
	<category: 'convenience'>
	self beBeta: nil
    ]

    beBeta: anInteger [
	<category: 'convenience'>
	self stage: #beta number: anInteger
    ]

    beFinal [
	<category: 'convenience'>
	self stage: nil number: nil
    ]

    greaseString [
	<category: 'converting'>
	^String streamContents: 
		[:stream | 
		stream nextPutAll: major greaseString.
		stream nextPut: $..
		stream nextPutAll: (minor ifNil: [0]) greaseString.
		revision isNil 
		    ifFalse: 
			[stream nextPut: $..
			stream nextPutAll: revision greaseString].
		stageLabel isNil 
		    ifFalse: 
			[stream nextPutAll: stageLabel greaseString.
			stageNumber isNil ifFalse: [stream nextPutAll: stageNumber greaseString]]]
    ]

    isAlpha [
	<category: 'testing'>
	^stageLabel = #alpha
    ]

    isBeta [
	<category: 'testing'>
	^stageLabel = #beta
    ]

    isFinal [
	<category: 'testing'>
	^stageLabel isNil
    ]

    major [
	<category: 'accessing'>
	^major
    ]

    major: anInteger [
	<category: 'accessing'>
	major := anInteger
    ]

    minor [
	<category: 'accessing'>
	^minor
    ]

    minor: anInteger [
	<category: 'accessing'>
	minor := anInteger
    ]

    revision [
	<category: 'accessing'>
	^revision
    ]

    revision: anInteger [
	<category: 'accessing'>
	revision := anInteger
    ]

    stage [
	<category: 'accessing'>
	^stageLabel
    ]

    stage: aSymbol number: anInteger [
	<category: 'accessing'>
	stageLabel := aSymbol.
	stageNumber := anInteger
    ]

    stageNumber [
	<category: 'accessing'>
	^stageNumber
    ]
]

