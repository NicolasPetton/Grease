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
	    ^true
	    "^self supportedEncodingNames includes: aString"
	]
]


    decoderFor: aStream [
	<category: 'conversion'>
	^(I18N.EncodedStream unicodeOn: aStream encoding: encoding)
    ]

    encoderFor: aStream [
	<category: 'conversion'>
        aStream species == ByteArray
            ifTrue: [ ^self encoderFor: aStream contents asString ].
        ^aStream species == UnicodeString
	    ifTrue: [ I18N.EncodedStream encoding: aStream to: encoding ]
	    ifFalse: [ I18N.EncodedStream on: aStream to: encoding ]
    ]


    decode: aString [
	<category: 'conversion'>
	^(self decoderFor: aString readStream) contents
    ]

    encode: aString [
	<category: 'conversion'>
	^(self encoderFor: aString readStream) contents
    ]

    initializeWithEncoding: aString [
	<category: 'initialization'>
	self initialize.
	encoding := aString.
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

