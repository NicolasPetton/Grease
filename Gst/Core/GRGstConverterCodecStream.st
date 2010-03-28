GRCodecStream subclass: GRGstConverterCodecStream [
    | converter binary |
    
    <comment: 'A WAConverterCodecStream is a WACodec stream around a TextConverter.
    Instance Variables
	binary:	<Boolean>	
	converter:  <TextConverter>
	binary - whether the receiver is in binary mode
	converter - the TextConverter used to do the encoding conversion'>
    <category: 'Grease-Pharo-Core'>

    GRGstConverterCodecStream class >> on: aStream converter: aConverter [
	<category: 'instance creation'>
	^self basicNew initalizeOn: aStream converter: aConverter
    ]

    binary [
	"switches the receiver into binary mode in which no encoding appends 
	and arguments are expected to be binary (bytes or byte arrays)."

	<category: 'actions'>
	binary := true
    ]

    flush [
	<category: 'actions'>
	stream flush
    ]

    text [
	"switches the receiver into text mode in which encoding appends 
	and arguments are expected to be text (characters or strings)."

	<category: 'actions'>
	binary := false
    ]

    contents [
	<category: 'accessing'>
	^stream contents
    ]

    size [
	<category: 'accessing'>
	^stream size
    ]

    initalizeOn: aStream converter: aConverter [
	<category: 'initialization'>
	self initalizeOn: aStream.
	converter := aConverter.
	binary := false
    ]

    next [
	<category: 'streaming'>
	| character |
	character := binary 
	    ifTrue: [stream next]
	    ifFalse: [converter nextFromStream: stream].
	^character isNil ifFalse: [character asCharacter]
    ]

    next: anInteger [
	<category: 'streaming'>
	| writeStream |
	writeStream := WriteStream on: (String new: anInteger).
	anInteger 
	    timesRepeat: [writeStream nextPut: (self next ifNil: [^writeStream contents])].
	^writeStream contents
    ]

    nextPut: aCharacter [
	<category: 'streaming'>
	binary 
	    ifTrue: [stream nextPut: aCharacter asCharacter]
	    ifFalse: [converter nextPut: aCharacter asCharacter toStream: stream]
    ]

    nextPutAll: aString [
	<category: 'streaming'>
	aString asString do: [:each | 
	    self nextPut: each]
    ]
]

