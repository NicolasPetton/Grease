TestCase subclass: GRNullCodecStreamTest [
    
    <comment: nil>
    <category: 'Grease-Tests-Core'>

    codecStreamClass [
	<category: 'accessing'>
	^GRNullCodecStream
    ]

    seasideByteArray [
	<category: 'private'>
	^#(83 101 97 115 105 100 101) asByteArray	"Seaside"
    ]

    testCrlf [
	<category: 'testing-characters'>
	| stream |
	stream := GRNullCodec new encoderFor: (WriteStream on: String new).
	stream crlf.
	self assert: stream contents size = 2.
	self assert: stream contents first = Character cr.
	self assert: stream contents last = Character lf
    ]

    testSpace [
	<category: 'testing-characters'>
	| stream |
	stream := GRNullCodec new encoderFor: (WriteStream on: String new).
	stream space.
	self assert: stream contents size = 1.
	self assert: stream contents first = Character space
    ]

    testTab [
	<category: 'testing-characters'>
	| stream |
	stream := GRNullCodec new encoderFor: (WriteStream on: String new).
	stream tab.
	self assert: stream contents size = 1.
	self assert: stream contents first = Character tab
    ]

    testFlush [
	<category: 'testing-protocol'>
	| stream |
	stream := GRNullCodec new encoderFor: (WriteStream on: String new).
	stream nextPutAll: 'abc'.
	self shouldnt: [stream flush] raise: Error.
	self assert: stream contents = 'abc'
    ]

    testNext [
	<category: 'testing-protocol'>
	| stream |
	stream := GRNullCodec new encoderFor: 'Seaside' readStream.
	self assert: stream next = $S.
	self assert: (stream next: 1) = 'e'
    ]

    testSize [
	<category: 'testing-protocol'>
	| stream |
	stream := GRNullCodec new encoderFor: (WriteStream on: String new).
	stream nextPutAll: 'abc'.
	self assert: stream size = 3.
	stream nextPut: $d.
	self assert: stream size = 4
    ]

    testText [
	<category: 'testing-protocol'>
	| stream |
	stream := GRNullCodec new encoderFor: (WriteStream on: String new).
	self shouldnt: [stream text] raise: Error
    ]

    testReadString [
	<category: 'testing'>
	| stream codecStream |
	stream := 'abc' readStream.
	codecStream := GRNullCodec new decoderFor: stream.
	self assert: codecStream next = $a.
	self assert: (codecStream next: 2) = 'bc'
    ]

    testWriteString [
	<category: 'testing'>
	| stream codecStream |
	stream := WriteStream on: String new.
	codecStream := GRNullCodec new encoderFor: stream.
	codecStream
	    nextPut: $A;
	    nextPutAll: 'BC';
	    nextPut: 68;
	    nextPutAll: #(69 70) asByteArray.
	self assert: codecStream contents = 'ABCDEF'
    ]
]

