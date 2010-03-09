GRObject subclass: GRCodecStream [
    | stream |
    
    <comment: 'A WACodecStream is a wrapper around a write stream and defines common behavior.
    
    Instance Variables
    stream:		<WriteStream>
    
    stream	- a WriteStream
    
    '>
    <category: 'Grease-Core-Text'>

    GRCodecStream class >> on: aStream [
	<category: 'instance creation'>
	^self basicNew initalizeOn: aStream
    ]

    initalizeOn: aStream [
	<category: 'initialization'>
	self initialize.
	stream := aStream
    ]

    binary [
	<category: 'accessing'>
	
    ]

    contents [
	<category: 'accessing'>
	^stream contents
    ]

    flush [
	<category: 'accessing'>
	stream flush
    ]

    size [
	<category: 'accessing'>
	^stream size
    ]

    text [
	<category: 'accessing'>
	
    ]

    crlf [
	<category: 'streaming'>
	self
	    nextPut: Character cr;
	    nextPut: Character lf
    ]

    next [
	<category: 'streaming'>
	self subclassResponsibility
    ]

    next: anInteger [
	<category: 'streaming'>
	self subclassResponsibility
    ]

    nextPut: aCharacter [
	<category: 'streaming'>
	self subclassResponsibility
    ]

    nextPutAll: aString [
	<category: 'streaming'>
	self subclassResponsibility
    ]

    space [
	<category: 'streaming'>
	self nextPut: Character space
    ]

    tab [
	<category: 'streaming'>
	self nextPut: Character tab
    ]

    atEnd [
	<category: 'testing'>
	^stream atEnd
    ]
]
