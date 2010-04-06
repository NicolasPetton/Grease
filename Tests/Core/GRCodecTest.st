TestCase subclass: GRCodecTest [
    
    <comment: nil>
    <category: 'Grease-Tests-Core'>

    decodedString [
	<category: 'accessing'>
	^'Übèrstrîñgé'
    ]

    latin1String [
	<category: 'accessing'>
	^self
	    asString: #(220 98 232 114 115 116 114 238 241 103 233)
    ]

    macromanString [
	<category: 'accessing'>
	^self
            asString: #(134 98 143 114 115 116 114 148 150 103 142)
    ]

    utf16beString [
	<category: 'accessing'>
	^self 
	    asString: #(0 220 0 98 0 232 0 114 0 115 0 116 0 114 0 238 0 241 0 103 0 233)
    ]

    utf16leString [
	<category: 'accessing'>
	^self 
	    asString: #(220 0 98 0 232 0 114 0 115 0 116 0 114 0 238 0 241 0 103 0 233 0)
    ]

    utf8String [
	<category: 'accessing'>
	^self 
	    asString: #(195 156 98 195 168 114 115 116 114 195 174 195 177 103 195 169)
    ]

    testAllCodecs [
	<category: 'testing'>
	self assert: GRCodec allCodecs notEmpty.
	GRCodec allCodecs do: 
		[:codec | 
		self deny: codec class = GRCodec.
		self assert: (codec isKindOf: GRCodec)]
    ]

    testCodecLatin1 [
	<category: 'testing'>
	#('iso-8859-1' 'ISO-8859-1') do: 
		[:each | 
		| codec |
		codec := GRCodec forEncoding: each.
		self assert: codec name = each.
		self assert: codec url name = each.
		self assert: (codec encode: self decodedString) asByteArray = self latin1String asByteArray.
		self assert: (codec url encode: self decodedString) asByteArray = self latin1String asByteArray.
		self assert: (codec decode: self latin1String) = self decodedString.
		self assert: (codec url decode: self latin1String) = self decodedString]
    ]

    testCodecLatin1Binary [
	<category: 'testing'>
	| codec encoder binary |
	codec := GRCodec forEncoding: 'ISO-8859-1'.
	binary := self latin1String asByteArray.
	encoder := codec encoderFor: (WriteStream on: String new).
	encoder binary.
	encoder nextPutAll: binary.
	self assert: encoder contents = binary asString
    ]

    testNext [
	<category: 'testing'>
	#('iso-8859-1' 'ISO-8859-1') do: 
		[:each | 
		| stream |
		stream := (GRCodec forEncoding: each) 
			    encoderFor: self seasideByteArray readStream.
		self assert: stream next = $S.
		self assert: (stream next: 1) = 'e']
    ]

    testNullCodec [
	<category: 'testing'>
	| codec readStream writeStream strings |
	codec := GRNullCodec new.
	readStream := self latin1String readStream.
	writeStream := WriteStream on: String new.
	strings := (OrderedCollection new)
		    add: self latin1String;
		    add: self utf8String;
		    add: self utf16leString;
		    add: self utf16beString;
		    add: self macromanString;
		    yourself.
	strings do: 
		[:string | 
		self assert: (codec encode: string) = string.
		self assert: (codec url encode: string) = string.
		self assert: (codec decode: string) = string.
		self assert: (codec url decode: string) = string].
	strings do: 
		[:string | 
		| binary encoded |
		binary := string asByteArray.
		encoded := (codec encoderFor: (WriteStream on: String new))
			    binary;
			    nextPutAll: binary;
			    contents.
		self assert: encoded = string.
		encoded := (codec url encoderFor: (WriteStream on: String new))
			    binary;
			    nextPutAll: binary;
			    contents.
		self assert: encoded = string]
    ]

    asString: aCollectionOfIntegers [
	<category: 'private'>
	^String streamContents: 
		[:stream | 
		aCollectionOfIntegers 
		    do: [:each | stream nextPut: (Character value: each)]]
    ]

    seasideByteArray [
	<category: 'private'>
	^#(83 101 97 115 105 100 101) asByteArray	"Seaside"
    ]
]
