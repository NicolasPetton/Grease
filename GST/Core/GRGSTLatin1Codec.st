GRNullCodec subclass: GRGSTLatin1Codec [
    | encoding |

    <comment: nil>
    <category: 'Grease-GST-Core'>

    GRGSTLatin1Codec class [
	
	basicForEncoding: aString [
	    <category: 'private'>
	    (self supportsEncoding: aString) ifFalse: [
		self unsupportedEncoding: aString].
	    ^self basicNew initializeWithEncoding: aString
	]

	supportedEncodingNames [
	    <category: 'private'>
	    ^#('ISO-8859-1' 'iso-8859-1')
	]

	codecs [
	    <category: 'accessing'>
	    ^self supportedEncodingNames collect: [:each |
		self basicForEncoding: each]
	]

	supportsEncoding: aString [
	    <category: 'testing'>
	    ^self supportedEncodingNames includes: aString
	]
    ]

    name [
	<category: 'accessing'>
	^encoding
    ]

    initializeWithEncoding: aString [
	<category: 'initialization'>
	self initialize.
	encoding := aString
    ]
]
