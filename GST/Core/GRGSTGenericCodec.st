GRCodec subclass: GRGSTGenericCodec [
    | name urlCodec |
    
    <comment: nil>
    <category: 'Grease-GST-Core'>

    GRGSTGenericCodec class >> additionalLatin1CodecNames [
	<category: 'private'>
	^#('iso-8859-1' 'ISO-8859-1')
    ]

    GRGSTGenericCodec class >> basicForEncoding: aString [
	<category: 'private'>
	(self supportsEncoding: aString) 
	    ifFalse: [self unsupportedEncoding: aString].
	^self basicNew initializeWithName: aString
    ]

    GRGSTGenericCodec class >> latin1CodecNames [
	<category: 'private'>
	^Latin1TextConverter encodingNames , self additionalLatin1CodecNames
    ]

    GRGSTGenericCodec class >> supportedEncodingNames [
	"answers the names of the encodings supported by this class"

	<category: 'private'>
	^(TextConverter allEncodingNames)
	    addAll: self additionalLatin1CodecNames;
	    removeAllFoundIn: UTF8TextConverter encodingNames;
	    yourself
    ]

    GRGSTGenericCodec class >> codecs [
	<category: 'accessing'>
	^(TextConverter allEncodingNames select: [:each | 
		"exclude UFT-8 which is handeled by WAUtf8Codec"
		self supportsEncoding: each]) 
	    collect: [:each | self basicForEncoding: each greaseString]
    ]

    GRGSTGenericCodec class >> supportsEncoding: aString [
	"Answer whether the the given encoding name is supported."

	<category: 'testing'>
	^self supportedEncodingNames includes: aString
    ]

    converter [
	<category: 'private'>
	^(self class latin1CodecNames includes: self name) 
	    ifTrue: [Latin1TextConverter new]
	    ifFalse: [TextConverter newForEncoding: self name]
    ]

    decoderFor: aStream [
	<category: 'conversion'>
	^self encoderFor: aStream
    ]

    encoderFor: aStream [
	<category: 'conversion'>
	^GRGstConverterCodecStream on: aStream converter: self converter
    ]

    initializeWithName: aString [
	<category: 'initialization'>
	self initialize.
	name := aString.
	urlCodec := (self class latin1CodecNames includes: aString) 
		    ifFalse: [GRCodec forEncoding: 'utf-8']
		    ifTrue: [self]
    ]

    name [
	<category: 'accessing'>
	^name
    ]

    url [
	"RFC 3986: When a new URI scheme defines a component that represents 
	textual data consisting of characters from the Universal Character Set 
	[UCS], the data should first be encoded as octets according to the UTF-8
	character encoding."

	<category: 'accessing'>
	^urlCodec
    ]
]

