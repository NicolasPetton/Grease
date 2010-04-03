GRCodec subclass: GRGSTGenericCodec [
    | encoding urlCodec |
    
    <comment: nil>
    <category: 'Grease-GST-Core'>

    GRGSTGenericCodec class [
	
	basicForEncoding: aString [
	    <category: 'private'>
	    (self supportsEncoding: aString) 
		ifFalse: [self unsupportedEncoding: aString].
	    ^self basicNew initializeWithEncoding: aString
	]

	supportedEncodingNames [
	    "answers the names of the encodings supported by this class"

	   <category: 'private'>
	    ^#('UTF-8') 
	]

	codecs [
	    <category: 'accessing'>
	    ^self supportedEncodingNames collect: [:each |
		self basicForEncoding: each]
	]

	supportsEncoding: aString [
	    "Answer whether the the given encoding name is supported."

	    <category: 'testing'>
	    ^aString asLowercase ~= 'iso-8859-1'
	    "^self supportedEncodingNames includes: aString"
	]
]


    decoderFor: aStream [
	<category: 'conversion'>
	^(I18N.EncodedStream on: aStream from: encoding
	    to: 'ISO-8859-1')
    ]

    encoderFor: aStream [
	<category: 'conversion'>
	^(I18N.EncodedStream on: aStream from: 'ISO-8859-1'
	    to: encoding)
    ]


    decode: aString [
	<category: 'conversion'>
	^(self decoderFor: aString readStream) contents asString
    ]

    encode: aString [
	<category: 'conversion'>
	^(self encoderFor: aString readStream) contents asString
    ]

    initializeWithEncoding: aString [
	<category: 'initialization'>
	self initialize.
	encoding := aString asLowercase.
	urlCodec := self
    ]

    name [
	<category: 'accessing'>
	^encoding
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

