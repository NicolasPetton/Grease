TestCase subclass: GRUtf8CodecTest [
    
    <comment: nil>
    <category: 'Grease-Tests-Core'>

    asString: aCollectionOfIntegers [
	<category: 'private'>
	^aCollectionOfIntegers asByteArray asString
    ]

    seasideByteArray [
	<category: 'private'>
	^#(83 101 97 115 105 100 101) asByteArray	"Seaside"
    ]

    decodedString [
        <category: 'accessing'>
        ^'Übèrstrîñgé'
    ]

    utf8String [
	<category: 'accessing'>
	^self asString:
            #(195 156 98 195 168 114 115 116 114 195 174 195 177 103 195 169)
    ]

    testCodecUtf8 [
	<category: 'testing'>
	#('UTF-8' 'utf-8') do: 
		[:codecName | 
		| codec |
		codec := GRCodec forEncoding: codecName.
		self assert: codec name = codecName.
		self assert: codec url name = codecName.
                self assert: (codec encode: self decodedString) asByteArray = self utf8String asByteArray.
                self assert: (codec url encode: self decodedString) asByteArray = self utf8String asByteArray.
                self assert: (codec decode: self utf8String) = self decodedString.
                self assert: (codec url decode: self utf8String) = self decodedString]
    ]

    testCodecUtf8Bom [
	<category: 'testing'>
	#('UTF-8' 'utf-8') do: 
		[:codecName | 
		| codec bom |
		codec := GRCodec forEncoding: codecName.
		bom := self asString: #(239 187 191).
		self assert: (codec decode: bom , self utf8String) = self decodedString.
		self assert: (codec url decode: bom , self utf8String) = self decodedString]
    ]

    testCodecUtf8ShortestForm [
	"Non shortest form characters should be rejected
	 See Corrigendum #1: UTF-8 Shortest Form http://www.unicode.org/versions/corrigendum1.html"

	<category: 'testing'>
	#('UTF-8' 'utf-8') do: 
		[:codecName | 
		| codec abc |
		codec := GRCodec forEncoding: codecName.
		abc := self asString: #(193 129 193 130 193 131).
		[self
                    should: [self assert: (codec decode: abc) ~= 'ABC']
                    raise: Error]]
    ]

    testNext [
	<category: 'testing'>
	| stream |
	stream := (GRCodec forEncoding: 'utf8') 
		    encoderFor: self seasideByteArray readStream.
	self assert: stream next = $S.
	self assert: (stream next: 1) = 'e'
    ]
]

