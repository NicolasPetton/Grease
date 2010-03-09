GRCodec subclass: GRNullCodec [
    
    <comment: 'The null codec always returns the original streams. It assumes that the outside world uses the same encoding as the inside world. This is highly efficient as no transformation is applied to the data, but has its drawbacks.'>
    <category: 'Grease-Core-Text'>

    GRNullCodec class >> codecs [
	<category: 'accessing'>
	^Array with: self new
    ]

    GRNullCodec class >> supportsEncoding: aString [
	<category: 'testing'>
	^aString isNil
    ]

    GRNullCodec class >> basicForEncoding: aString [
	<category: 'private'>
	^self new
    ]

    name [
	<category: 'accessing'>
	^'(none)'
    ]

    url [
	"The selfish method. Let's do it with ourselves."

	<category: 'accessing'>
	^self
    ]

    decode: aString [
	"Overridden for efficencey."

	<category: 'convenience'>
	^aString
    ]

    encode: aString [
	"Overridden for efficencey."

	<category: 'convenience'>
	^aString
    ]

    decoderFor: aReadStream [
	"wrap to avoid String vs ByteArray issues"

	<category: 'conversion'>
	^GRNullCodecStream on: aReadStream
    ]

    encoderFor: aWriteStream [
	"wrap to avoid String vs ByteArray issues"

	<category: 'conversion'>
	^GRNullCodecStream on: aWriteStream
    ]
]

