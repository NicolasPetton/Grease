GRObject subclass: GRCodec [
    
    <comment: 'A codec defines how Seaside communicates without the outside world and how outside data is converted into the image (decoding) and back outside the image (encoding). The codec is essentially a stream factory that provides wrappers around standard streams. All streams do support binary mode for non-converted transfer.'>
    <category: 'Grease-Core-Text'>

    GRCodec class >> allCodecs [
	"Answer all codecs supported in this system. This is a collection of codec instances."

	<category: 'accessing'>
	^self subclasses inject: self codecs asArray
	    into: [:result :each | result , each allCodecs]
    ]

    GRCodec class >> codecs [
	"Answer a collection of possible codecs of the receiver. To be overridden by concrete subclasses."

	<category: 'accessing'>
	^#()
    ]

    GRCodec class >> forEncoding: aString [
	"Answer a new codec instance for the given encoding name. Raise an WAUnsupportedEncodingError if the encoding name is not supported by this image."

	<category: 'instance creation'>
	self allSubclassesDo: [:each | 
	    (each supportsEncoding: aString) ifTrue: [
		^each basicForEncoding: aString]].
	self unsupportedEncoding: aString
    ]

    GRCodec class >> supportsEncoding: aString [
	"Answer whether the the given encoding name is supported by this codec class."

	<category: 'testing'>
	self subclassResponsibility
    ]

    GRCodec class >> basicForEncoding: aString [
	"Create the actual instance."

	<category: 'private'>
	self subclassResponsibility
    ]

    GRCodec class >> unsupportedEncoding: aString [
	"Signal an unsupported encoding."

	<category: 'private'>
	GRUnsupportedEncodingError signal: 'unsupported encoding: ' , aString
    ]

    name [
	"Answer a human readable string of the receivers encoding policy."

	<category: 'accessing'>
	self subclassResponsibility
    ]

    url [
	"Answer a codec that is responsible to encode and decode URLs. In most cases an UTF-8 codec is the only valid choice, but subclasses might decide to do something else."

	<category: 'accessing'>
	self subclassResponsibility
    ]

    decode: aString [
	<category: 'convenience'>
	| readStream writeStream |
	readStream := self decoderFor: aString readStream.
	writeStream := WriteStream on: (String new: aString size).
	[readStream atEnd] 
	    whileFalse: [writeStream nextPutAll: (readStream next: 1024)].
	^writeStream contents
    ]

    encode: aString [
	<category: 'convenience'>
	| writeStream |
	writeStream := self encoderFor: 
	    (WriteStream on: (String new: aString size)).
	writeStream nextPutAll: aString.
	^writeStream contents
    ]

    decoderFor: aReadStream [
	"Wrap aReadStream with an decoder for the codec of the receiver. Answer a read stream that delegates to and shares the state of aReadStream."

	<category: 'conversion'>
	self subclassResponsibility
    ]

    encoderFor: aWriteStream [
	"Wrap aWriteStream with an encoder for the codec of the receiver. Answer a write stream that delegates to and shares the state of aWriteStream."

	<category: 'conversion'>
	self subclassResponsibility
    ]

    printOn: aStream [
	<category: 'printing'>
	super printOn: aStream.
	aStream
	    nextPutAll: ' name: ';
	    print: self name
    ]
]

