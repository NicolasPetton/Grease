GRCodecStream subclass: GRNullCodecStream [
    
    <comment: 'A WANullCodecStream is a WriteStream on a String on which you can both put binary and character data without encoding happening.
    
    Instance Variables
    stream:		<WriteStream>
    
    stream
    - a WriteStream on a String'>
    <category: 'Grease-Core-Text'>

    next [
	<category: 'streaming'>
	^stream next
    ]

    next: anInteger [
	<category: 'streaming'>
	^stream next: anInteger
    ]

    nextPut: aCharacterOrByte [
	<category: 'streaming'>
	aCharacterOrByte isCharacter 
	    ifTrue: [stream nextPut: aCharacterOrByte]
	    ifFalse: [stream nextPut: (Character codePoint: aCharacterOrByte)]
    ]

    nextPutAll: aStringOrByteArray [
	<category: 'streaming'>
	aStringOrByteArray isString 
	    ifTrue: [stream nextPutAll: aStringOrByteArray]
	    ifFalse: [1 
		to: aStringOrByteArray size
		do: [:index | stream nextPut: (Character codePoint: (aStringOrByteArray at: index))]]
    ]
]
