Eval [
  PackageBuilder new
    name: 'Grease';
    namespace: 'Grease';
    prereq: 'Iconv';
    prereq: 'SUnit';

    testsBelow: 'Tests' matching: '*.st';

    url: 'git://github.com/NicolasPetton/Grease.git';

    filein: 'Core/GRObject.st';
    filein: 'Core/GRPlatform.st';
    filein: 'Core/GRPackage.st';
    filein: 'Core/GRVersion.st';
    filein: 'Core/Exceptions.st';
    filein: 'Core/Extensions.st';

    filein: 'Core/Collections/GRSmallDictionary.st';
    filein: 'Core/Collections/GROrderedMultiMap.st';

    filein: 'Core/Text/GRCodec.st';
    filein: 'Core/Text/GRNullCodec.st';
    filein: 'Core/Text/GRCodecStream.st';
    filein: 'Core/Text/GRNullCodecStream.st';
    filein: 'Core/Text/GRInflector.st';
    filein: 'Core/Text/GRInvalidUtf8Error.st';
    filein: 'Core/Text/GRPrinter.st';
    filein: 'Core/Text/GRMappedPrinter.st';
    filein: 'Core/Text/GRNumberPrinter.st';
    filein: 'Core/Text/GROrdinalizePrinter.st';
    filein: 'Core/Text/GRPluggablePrinter.st';
    filein: 'Core/Text/GRSequentialPrinter.st';
    filein: 'Core/Text/GRSignPrinter.st';
    filein: 'Core/Text/GRStringPrinter.st';
    filein: 'Core/Text/GRUnitPrinter.st';
    filein: 'Core/Text/GRUnsupportedEncodingError.st';

    filein: 'Core/Utilities/GRDelayedSend.st';
    filein: 'Core/Utilities/GRBoundDelayedSend.st';
    filein: 'Core/Utilities/GRUnboundDelayedSend.st';
    filein: 'Core/Utilities/GRInvalidArgumentCount.st';

    filein: 'Gst/Core/GRGstConverterCodecStream.st';
    filein: 'Gst/Core/GRGstUtf8CodecStream.st';
    filein: 'Gst/Core/GRGstGenericCodec.st';
    filein: 'Gst/Core/GRGstPlatform.st';
    filein: 'Gst/Core/GRGstRandomProvider.st';
    filein: 'Gst/Core/GRGstUtf8Codec.st';

    filein: 'Tests/Core/GRCodecTest.st';
    filein: 'Tests/Core/GRCollectionTest.st';
    filein: 'Tests/Core/GRAbstractDictionaryTest.st';
    filein: 'Tests/Core/GRDictionaryTest.st';
    filein: 'Tests/Core/GRIdentityDictionaryTest.st';
    filein: 'Tests/Core/GRArrayTest.st';
    filein: 'Tests/Core/GRBagTest.st';
    filein: 'Tests/Core/GRIntervalTest.st';
    filein: 'Tests/Core/GROrderedCollectionTest.st';
    filein: 'Tests/Core/GRSetTest.st';
    filein: 'Tests/Core/GRStringTest.st';
    filein: 'Tests/Core/GRDelayedSendTest.st';
    filein: 'Tests/Core/GRDurationTest.st';
    filein: 'Tests/Core/GRErrorStub.st';
    filein: 'Tests/Core/GRExceptionTest.st';
    filein: 'Tests/Core/GRNotificationStub.st';
    filein: 'Tests/Core/GRNullCodecStreamTest.st';
    filein: 'Tests/Core/GRNumberTest.st';
    filein: 'Tests/Core/GRObjectStub.st';
    filein: 'Tests/Core/GRObjectTest.st';
    filein: 'Tests/Core/GRPackageTest.st';
    filein: 'Tests/Core/GRPlatformTest.st';
    filein: 'Tests/Core/GRPrinterTest.st';
    filein: 'Tests/Core/GROrderedMultiMapTest.st';
    filein: 'Tests/Core/GRUtf8CodecTest.st';
    filein: 'Tests/Core/GRVersionTest.st';

    filein: 'Tests/Gst/Core/GRGstColorTest.st';
    filein: 'Tests/Gst/Core/GRGstPlatformTest.st';

    buildXml
]
