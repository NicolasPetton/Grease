GRCodec subclass: GRGSTUtf8Codec [
    
    <comment: 'A WAUtf8Codec is a WACodec optimized for UTF-8.'>
    <category: 'Grease-Gst-Core'>

    GRGSTUtf8Codec class >> basicForEncoding: aString [
	<category: 'private'>
	^self new
    ]

    GRGSTUtf8Codec class >> codecs [
	<category: 'accessing'>
	^Array with: self new
    ]

    GRGSTUtf8Codec class >> supportsEncoding: aString [
	<category: 'testing'>
	^(#('utf-8' 'UTF-8') includes: aString) 
	    or: [UTF8TextConverter encodingNames includes: aString]
    ]

    decode: aString [
	<category: 'decoding'>
	| readStream writeStream |
	readStream := self decoderFor: aString asByteArray readStream.
	writeStream := WriteStream on: (String new: aString size).
	[readStream atEnd] 
	    whileFalse: [writeStream nextPutAll: (readStream next: 4095)].
	^writeStream contents
    ]

    decoderFor: aStream [
	<category: 'conversion'>
	^GRGSTUtf8CodecStream on: aStream converter: UTF8TextConverter new
    ]

    encoderFor: aStream [
	<category: 'conversion'>
	^GRGSTUtf8CodecStream on: aStream converter: UTF8TextConverter new
    ]

    name [
	<category: 'accessing'>
	^'utf-8'
    ]

    url [
	<category: 'accessing'>
	^self
    ]
]

