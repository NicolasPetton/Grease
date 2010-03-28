GRGstConverterCodecStream subclass: GRGstUtf8CodecStream [
    
    <comment: 'A WAUtf8CodecStream is a WACodecStream optimized for UTF-8 
    performance in the case where most of the characters are ASCII'>
    <category: 'Grease-Gst-Core'>

    Latin1ToUtf8Encodings := nil.
    Latin1ToUtf8Map := nil.

    GRGstUtf8CodecStream class >> initialize [
	<category: 'class initialization'>
	(Smalltalk hasClassNamed: #UTF8TextConverter) 
	    ifFalse: 
		["guard for Squeak 37"

		^self].
	Latin1ToUtf8Map := ByteArray new: 256.
	Latin1ToUtf8Encodings := Array new: 256.
	0 to: 255
	    do: 
		[:index | 
		| latin1 utf8 |
		latin1 := String with: (Character codePoint: index).
		utf8 := latin1 convertToWithConverter: UTF8TextConverter new.
		latin1 = utf8 
		    ifTrue: [Latin1ToUtf8Map at: index + 1 put: 0	"no translation needed"]
		    ifFalse: 
			[Latin1ToUtf8Map at: index + 1 put: 1.	"no translation needed"
			Latin1ToUtf8Encodings at: index + 1 put: utf8]]
    ]

    crlf [
	<category: 'streaming'>
	binary 
	    ifTrue: 
		[stream nextPut: 13.
		stream nextPut: 10]
	    ifFalse: 
		[stream nextPut: Character cr.
		stream nextPut: Character lf]
    ]

    next [
	<category: 'streaming'>
	^(self next: 1) first
    ]

    next: anInteger [
	"Convert the given string from UTF-8 using the fast path if converting to Latin-1"

	<category: 'streaming'>
	| outStream lastIndex byte1 byte2 byte3 byte4 unicode count |
	lastIndex := 1.
	outStream := WriteStream on: (String new: anInteger).
	count := 0.
	[count < anInteger and: [stream atEnd not]] whileTrue: 
		[byte1 := stream next.
		unicode := byte1.
		(byte1 bitAnd: 224) = 192 
		    ifTrue: 
			["two bytes"

			byte2 := stream next.
			(byte2 bitAnd: 192) = 128 ifFalse: [self invalidUtf8].
			unicode := ((byte1 bitAnd: 31) bitShift: 6) + (byte2 bitAnd: 63)].
		(byte1 bitAnd: 240) = 224 
		    ifTrue: 
			["three bytes"

			byte2 := stream next.
			(byte2 bitAnd: 192) = 128 ifFalse: [self invalidUtf8].
			byte3 := stream next.
			(byte3 bitAnd: 192) = 128 ifFalse: [self invalidUtf8].
			unicode := ((byte1 bitAnd: 15) bitShift: 12) 
				    + ((byte2 bitAnd: 63) bitShift: 6) + (byte3 bitAnd: 63)].
		(byte1 bitAnd: 248) = 240 
		    ifTrue: 
			["four bytes"

			byte2 := stream next.
			(byte2 bitAnd: 192) = 128 ifFalse: [self invalidUtf8].
			byte3 := stream next.
			(byte3 bitAnd: 192) = 128 ifFalse: [self invalidUtf8].
			byte4 := stream next.
			(byte4 bitAnd: 192) = 128 ifFalse: [self invalidUtf8].
			unicode := ((byte1 bitAnd: 7) bitShift: 18) 
				    + ((byte2 bitAnd: 63) bitShift: 12) + ((byte3 bitAnd: 63) bitShift: 6) 
				    + (byte4 bitAnd: 63)].
		unicode ifNil: [self invalidUtf8].
		unicode = 65279 
		    ifFalse: 
			["ignore BOM"

			outStream nextPut: (Character codePoint: unicode).
			count := count + 1].
		unicode := nil].
	^outStream contents
    ]

    nextPut: aCharacter [
	<category: 'streaming'>
	self nextPutAll: (String with: aCharacter)
    ]

    nextPutAll: aString [
	<category: 'streaming'>
	binary 
	    ifTrue: [stream nextPutAll: aString asString]
	    ifFalse: 
		[aString isByteString 
		    ifTrue: [self encodeFast: aString]
		    ifFalse: [self encodeDefault: aString]]
    ]

    encodeDefault: aString [
	"Convert the given string from UTF-8 using the fast path if converting to Latin-1"

	<category: 'private'>
	1 to: aString size
	    by: 1
	    do: [:index | converter nextPut: (aString at: index) toStream: stream]
    ]

    encodeFast: aByteString [
	"Convert the given string from UTF-8 using the fast path if converting to Latin-1"

	<category: 'private'>
	| lastIndex nextIndex |
	lastIndex := 1.
	nextIndex := ByteString 
		    findFirstInString: aByteString
		    inSet: Latin1ToUtf8Map
		    startingAt: lastIndex.
	nextIndex = 0 ifTrue: [^stream nextPutAll: aByteString].
	
	[stream 
	    next: nextIndex - lastIndex
	    putAll: aByteString
	    startingAt: lastIndex.
	stream 
	    nextPutAll: (Latin1ToUtf8Encodings at: (aByteString byteAt: nextIndex) + 1).
	lastIndex := nextIndex + 1.
	nextIndex := ByteString 
		    findFirstInString: aByteString
		    inSet: Latin1ToUtf8Map
		    startingAt: lastIndex.
	nextIndex = 0] 
		whileFalse.
	stream 
	    next: aByteString size - lastIndex + 1
	    putAll: aByteString
	    startingAt: lastIndex
    ]

    invalidUtf8 [
	<category: 'private'>
	^GRInvalidUtf8Error signal: 'Invalid UTF-8 input'
    ]
]



Eval [
    GRGstUtf8CodecStream initialize
]

