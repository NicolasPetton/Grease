TestCase subclass: GRPrinterTest [
    
    <comment: nil>
    <category: 'Grease-Tests-Core'>

    GRPrinterTest class >> packageNamesUnderTest [
	<category: 'accessing'>
	^#('Grease-Core')
    ]

    testComposedPrinter [
	<category: 'testing'>
	| converter |
	converter := GRSequentialPrinter new , 'CHF ' , GRNumberPrinter new.
	self assert: (converter print: 1234) = 'CHF 1234'.
	self assert: (converter print: -1234) = 'CHF 1234'.
	converter := GRSignPrinter new , GRNumberPrinter new , '%'.
	self assert: (converter print: 1234) = '1234%'.
	self assert: (converter print: -1234) = '-1234%'
    ]

    testFileSizePrinterBinary [
	<category: 'testing'>
	| converter |
	converter := GRPrinter binaryFileSize.
	self assert: (converter print: 1) = '1 byte'.
	self assert: (converter print: 2) = '2 bytes'.
	self assert: (converter print: 30) = '30 bytes'.
	self assert: (converter print: 500) = '500 bytes'.
	self assert: (converter print: 6000) = '5.9 KiB'.
	self assert: (converter print: 70000) = '68.4 KiB'.
	self assert: (converter print: 800000) = '781.3 KiB'.
	self assert: (converter print: 9000000) = '8.6 MiB'.
	self assert: (converter print: 10000000) = '9.5 MiB'.
	self assert: (converter print: 200000000) = '190.7 MiB'.
	self assert: (converter print: 3000000000) = '2.8 GiB'.
	self assert: (converter print: 40000000000) = '37.3 GiB'
    ]

    testFileSizePrinterDecimal [
	<category: 'testing'>
	| converter |
	converter := GRPrinter decimalFileSize.
	self assert: (converter print: 1) = '1 byte'.
	self assert: (converter print: 2) = '2 bytes'.
	self assert: (converter print: 30) = '30 bytes'.
	self assert: (converter print: 500) = '500 bytes'.
	self assert: (converter print: 6000) = '6.0 kB'.
	self assert: (converter print: 70000) = '70.0 kB'.
	self assert: (converter print: 800000) = '800.0 kB'.
	self assert: (converter print: 9000000) = '9.0 MB'.
	self assert: (converter print: 10000000) = '10.0 MB'.
	self assert: (converter print: 200000000) = '200.0 MB'.
	self assert: (converter print: 3000000000) = '3.0 GB'.
	self assert: (converter print: 40000000000) = '40.0 GB'
    ]

    testFloatPrinter [
	<category: 'testing'>
	| converter |
	converter := GRNumberPrinter new precision: 2.
	self assert: (converter print: 1.009) = '1.01'.
	self assert: (converter print: 1.01) = '1.01'.
	self assert: (converter print: 1.019) = '1.02'.
	self assert: (converter print: 1.25) = '1.25'.
	self assert: (converter print: 1.254) = '1.25'.
	self assert: (converter print: 1.256) = '1.26'.
	self assert: (converter print: 1.009) = '1.01'.
	self assert: (converter print: 0.9) = '0.90'.
	self assert: (converter print: 0.99) = '0.99'.
	self assert: (converter print: 0.999) = '1.00'.
	self assert: (converter print: 0.9999) = '1.00'.
	self assert: (converter print: -0.9) = '0.90'.
	self assert: (converter print: -0.99) = '0.99'.
	self assert: (converter print: -0.999) = '1.00'.
	self assert: (converter print: -0.9999) = '1.00'
    ]

    testFloatPrinterInfinity [
	<category: 'testing'>
	| converter |
	converter := GRNumberPrinter new.
	self assert: (converter print: Float infinity) = 'Infinite'.
	self assert: (converter print: Float infinity negated) = 'Infinite'.
	converter infinite: 'very huge'.
	self assert: (converter print: Float infinity) = 'very huge'.
	self assert: (converter print: Float infinity negated) = 'very huge'
    ]

    testFloatPrinterNaN [
	<category: 'testing'>
	| converter |
	converter := GRNumberPrinter new.
	self assert: (converter print: Float nan) = 'NaN'.
	converter nan: 'Not A Number'.
	self assert: (converter print: Float nan) = 'Not A Number'
    ]

    testFloatPrinterPadding [
	<category: 'testing'>
	| converter |
	converter := GRNumberPrinter new.
	converter digits: 3.
	self assert: (converter print: 1) = '  1'.
	self assert: (converter print: 12) = ' 12'.
	self assert: (converter print: 123) = '123'.
	self assert: (converter print: 1234) = '1234'.
	converter padding: $*.
	self assert: (converter print: 1) = '**1'.
	self assert: (converter print: 12) = '*12'.
	self assert: (converter print: 123) = '123'.
	self assert: (converter print: 1234) = '1234'
    ]

    testFloatPrinterSeparator [
	<category: 'testing'>
	| converter |
	converter := GRNumberPrinter new.
	converter
	    precision: 2;
	    separator: $*.
	self assert: (converter print: 12345.0) = '12*345.00'.
	self assert: (converter print: 0.6789000000000001) = '0.68'.
	converter
	    precision: 4;
	    separator: $!.
	self assert: (converter print: 12345.0) = '12!345.000!0'.
	self assert: (converter print: 0.6789000000000001) = '0.678!9'
    ]

    testIntegerPrinter [
	<category: 'testing'>
	| converter |
	converter := GRNumberPrinter new.
	self assert: (converter print: 1234) = '1234'.
	self assert: (converter print: -1234) = '1234'.
	converter separator: $..
	self assert: (converter print: 1234) = '1.234'.
	self assert: (converter print: 1234567) = '1.234.567'.
	converter
	    base: 16;
	    separator: nil.
	self assert: (converter print: 1234) = '4d2'.
	self assert: (converter print: 123123) = '1e0f3'.
	converter uppercase.
	self assert: (converter print: 1234) = '4D2'.
	self assert: (converter print: 123123) = '1E0F3'
    ]

    testOrdinalizePrinter [
	<category: 'testing'>
	| converter |
	converter := GRNumberPrinter new , GROrdinalizePrinter new.
	self assert: (converter print: 1) = '1st'.
	self assert: (converter print: 2) = '2nd'.
	self assert: (converter print: 3) = '3rd'.
	self assert: (converter print: 4) = '4th'.
	self assert: (converter print: 10) = '10th'.
	self assert: (converter print: 111) = '111th'.
	self assert: (converter print: 212) = '212th'.
	self assert: (converter print: 313) = '313th'.
	self assert: (converter print: 414) = '414th'.
	self assert: (converter print: 20) = '20th'.
	self assert: (converter print: 121) = '121st'.
	self assert: (converter print: 222) = '222nd'.
	self assert: (converter print: 323) = '323rd'.
	self assert: (converter print: 424) = '424th'
    ]

    testSignPrinter [
	<category: 'testing'>
	| converter |
	converter := GRSignPrinter new.
	converter
	    negativePrinter: $-;
	    positivePrinter: $+.
	self assert: (converter print: 12) = '+'.
	self assert: (converter print: -12) = '-'
    ]

    testStringPrinter [
	<category: 'testing'>
	| converter |
	converter := GRStringPrinter new.
	self assert: (converter print: 123) = '123'.
	self assert: (converter print: 'foo') = 'foo'.
	self assert: (converter print: true) = 'true'
    ]

    testStringPrinterLength [
	<category: 'testing'>
	| converter |
	converter := GRStringPrinter new.
	self assert: (converter print: 'foo') = 'foo'.
	converter length: 3.
	self assert: (converter print: 'foo') = 'foo'.
	converter length: 1.
	self assert: (converter print: 'foo') = 'f'
    ]

    testStringPrinterPad [
	<category: 'testing'>
	| converter |
	converter := GRStringPrinter new.
	converter
	    character: $*;
	    length: 5.
	converter padLeft.
	self assert: (converter print: 'foo') = '**foo'.
	converter padRight.
	self assert: (converter print: 'foo') = 'foo**'.
	converter padCenter.
	self assert: (converter print: 'foo') = '*foo*'
    ]

    testStringPrinterTrim [
	<category: 'testing'>
	| converter |
	converter := GRStringPrinter new.
	self assert: (converter print: ' foo ') = ' foo '.
	converter trimLeft.
	self assert: (converter print: ' foo ') = 'foo '.
	converter trimRight.
	self assert: (converter print: ' foo ') = ' foo'.
	converter trimBoth.
	self assert: (converter print: ' foo ') = 'foo'
    ]

    testCookieTimestamp [
	<category: 'testing-timestamp'>
	| printer date |
	printer := GRPrinter cookieTimestamp.
	date := DateAndTime 
	    year: 2008
	    month: 8
	    day: 1
	    hour: 9
	    minute: 4
	    second: 4
	    offset: (Duration 
		days: 0
		hours: 0
		minutes: 0
		seconds: 0).
	self assert: (printer print: date) = 'Fri, 01-Aug-2008 09:04:04 GMT'
    ]

    testHttp [
	<category: 'testing-timestamp'>
	| printer date offsetHour |
	offsetHour := 2.
	printer := GRPrinter httpDate.
	date := DateAndTime 
	    year: 1994
	    month: 11
	    day: 6
	    hour: 8 + offsetHour
	    minute: 49
	    second: 37
	    offset: (Duration 
		days: 0
		hours: offsetHour
		minutes: 0
		seconds: 0).
	self assert: (printer print: date) = 'Sun, 06 Nov 1994 08:49:37 GMT'
    ]

    testIsoDate [
	<category: 'testing-timestamp'>
	| printer |
	printer := GRPrinter isoDate.
	self 
	    assert: (printer print: (Date 
			    year: 1980
			    month: 6
			    day: 11)) 
		    = '1980-06-11'.
	self 
	    assert: (printer print: (Date 
			    year: 2003
			    month: 12
			    day: 1)) 
		    = '2003-12-01'.
	self 
	    assert: (printer print: (Date 
			    year: 800
			    month: 12
			    day: 24)) 
		    = '0800-12-24'
    ]

    testIsoTime [
	<category: 'testing-timestamp'>
	| printer |
	printer := GRPrinter isoTime.
	self 
	    assert: (printer print: (Time 
			    hour: 0
			    minute: 0
			    second: 0)) 
		    = '00:00:00'.
	self 
	    assert: (printer print: (Time 
			    hour: 1
			    minute: 2
			    second: 3)) 
		    = '01:02:03'.
	self 
	    assert: (printer print: (Time 
			    hour: 12
			    minute: 23
			    second: 34)) 
		    = '12:23:34'
    ]

    testRfc822 [
	<category: 'testing-timestamp'>
	| printer date |
	printer := GRPrinter rfc822.
	date := DateAndTime 
		    year: 2008
		    month: 8
		    day: 1
		    hour: 9
		    minute: 4
		    second: 4
		    offset: (Duration 
			    days: 0
			    hours: -2
			    minutes: 0
			    seconds: 0).
	self assert: (printer print: date) = 'Fri, 01 Aug 2008 09:04:04 -0200'.
	date := DateAndTime 
		    year: 2008
		    month: 8
		    day: 31
		    hour: 19
		    minute: 41
		    second: 46
		    offset: (Duration 
			    days: 0
			    hours: 0
			    minutes: 30
			    seconds: 0).
	self assert: (printer print: date) = 'Sun, 31 Aug 2008 19:41:46 +0030'
    ]

    testRfc822WithTimeZone [
	<category: 'testing-timestamp'>
	| printer date |
	printer := GRPrinter rfc822WithTimeZone: 'GMT'.
	date := DateAndTime 
		    year: 2008
		    month: 8
		    day: 1
		    hour: 9
		    minute: 4
		    second: 4
		    offset: (Duration 
			    days: 0
			    hours: 0
			    minutes: 0
			    seconds: 0).
	self assert: (printer print: date) = 'Fri, 01 Aug 2008 09:04:04 GMT'
    ]

    testDigitsOf [
	<category: 'testing-utilites'>
	| converter |
	converter := GRNumberPrinter new.
	self assert: (converter digitsOf: 0.0 base: 10) = '0'.
	self assert: (converter digitsOf: 1.0 base: 10) = '1'.
	self assert: (converter digitsOf: -1.0 base: 10) = '1'.
	self assert: (converter digitsOf: -1234567890 base: 10) = '1234567890'.
	self assert: (converter digitsOf: 1234567890 base: 10) = '1234567890'.
	self assert: (converter digitsOf: -9876543210 base: 10) = '9876543210'.
	self assert: (converter digitsOf: 9876543210 base: 10) = '9876543210'
    ]

    testDigitsOfBase [
	<category: 'testing-utilites'>
	| converter |
	converter := GRNumberPrinter new.
	self assert: (converter digitsOf: 1234 base: 2) = '10011010010'.
	self assert: (converter digitsOf: 1234 base: 3) = '1200201'.
	self assert: (converter digitsOf: 1234 base: 4) = '103102'.
	self assert: (converter digitsOf: 1234 base: 5) = '14414'.
	self assert: (converter digitsOf: 1234 base: 6) = '5414'.
	self assert: (converter digitsOf: 1234 base: 7) = '3412'.
	self assert: (converter digitsOf: 1234 base: 8) = '2322'.
	self assert: (converter digitsOf: 1234 base: 9) = '1621'.
	self assert: (converter digitsOf: 1234 base: 10) = '1234'.
	self assert: (converter digitsOf: 1234 base: 11) = 'a22'.
	self assert: (converter digitsOf: 1234 base: 12) = '86a'.
	self assert: (converter digitsOf: 1234 base: 13) = '73c'.
	self assert: (converter digitsOf: 1234 base: 14) = '642'.
	self assert: (converter digitsOf: 1234 base: 15) = '574'.
	self assert: (converter digitsOf: 1234 base: 16) = '4d2'
    ]

    testPadCenter [
	<category: 'testing-utilites'>
	| converter |
	converter := GRPrinter new.
	self 
	    assert: (converter 
		    pad: ''
		    center: $*
		    to: 3) = '***'.
	self 
	    assert: (converter 
		    pad: '1'
		    center: $*
		    to: 3) = '*1*'.
	self 
	    assert: (converter 
		    pad: '12'
		    center: $*
		    to: 3) = '12*'.
	self 
	    assert: (converter 
		    pad: '123'
		    center: $*
		    to: 3) = '123'.
	self 
	    assert: (converter 
		    pad: '1234'
		    center: $*
		    to: 3) = '1234'
    ]

    testPadLeft [
	<category: 'testing-utilites'>
	| converter |
	converter := GRPrinter new.
	self assert: (converter 
		    pad: ''
		    left: $*
		    to: 3) = '***'.
	self 
	    assert: (converter 
		    pad: '1'
		    left: $*
		    to: 3) = '**1'.
	self 
	    assert: (converter 
		    pad: '12'
		    left: $*
		    to: 3) = '*12'.
	self 
	    assert: (converter 
		    pad: '123'
		    left: $*
		    to: 3) = '123'.
	self 
	    assert: (converter 
		    pad: '1234'
		    left: $*
		    to: 3) = '1234'
    ]

    testPadRight [
	<category: 'testing-utilites'>
	| converter |
	converter := GRPrinter new.
	self 
	    assert: (converter 
		    pad: ''
		    right: $*
		    to: 3) = '***'.
	self 
	    assert: (converter 
		    pad: '1'
		    right: $*
		    to: 3) = '1**'.
	self 
	    assert: (converter 
		    pad: '12'
		    right: $*
		    to: 3) = '12*'.
	self 
	    assert: (converter 
		    pad: '123'
		    right: $*
		    to: 3) = '123'.
	self 
	    assert: (converter 
		    pad: '1234'
		    right: $*
		    to: 3) = '1234'
    ]

    testSeparateLeft [
	<category: 'testing-utilites'>
	| converter |
	converter := GRNumberPrinter new.
	self assert: (converter separate: '' left: $*) = ''.
	self assert: (converter separate: '1' left: $*) = '1'.
	self assert: (converter separate: '12' left: $*) = '12'.
	self assert: (converter separate: '123' left: $*) = '123'.
	self assert: (converter separate: '1234' left: $*) = '123*4'.
	self assert: (converter separate: '12345' left: $*) = '123*45'.
	self assert: (converter separate: '123456' left: $*) = '123*456'.
	self assert: (converter separate: '1234567' left: $*) = '123*456*7'.
	self assert: (converter separate: '12345678' left: $*) = '123*456*78'.
	self assert: (converter separate: '123456789' left: $*) = '123*456*789'
    ]

    testSeparateRight [
	<category: 'testing-utilites'>
	| converter |
	converter := GRNumberPrinter new.
	self assert: (converter separate: '' right: $*) = ''.
	self assert: (converter separate: '1' right: $*) = '1'.
	self assert: (converter separate: '12' right: $*) = '12'.
	self assert: (converter separate: '123' right: $*) = '123'.
	self assert: (converter separate: '1234' right: $*) = '1*234'.
	self assert: (converter separate: '12345' right: $*) = '12*345'.
	self assert: (converter separate: '123456' right: $*) = '123*456'.
	self assert: (converter separate: '1234567' right: $*) = '1*234*567'.
	self assert: (converter separate: '12345678' right: $*) = '12*345*678'.
	self assert: (converter separate: '123456789' right: $*) = '123*456*789'
    ]

    testFullMonthName [
	<category: 'testing-parts-date'>
	| printer |
	printer := GRPrinter fullMonthName.
	self 
	    assert: (printer print: (Date 
			    year: 2000
			    month: 8
			    day: 1)) 
		    = 'August'.
	self 
	    assert: (printer print: (Date 
			    year: 2000
			    month: 11
			    day: 1)) 
		    = 'November'
    ]

    testFullWeekName [
	<category: 'testing-parts-date'>
	| printer |
	printer := GRPrinter fullWeekName.
	self 
	    assert: (printer print: (Date 
			    year: 1980
			    month: 1
			    day: 1)) 
		    = 'Tuesday'.
	self 
	    assert: (printer print: (Date 
			    year: 2000
			    month: 1
			    day: 1)) 
		    = 'Saturday'
    ]

    testPaddedCentury [
	<category: 'testing-parts-date'>
	| printer |
	printer := GRPrinter paddedCentury.
	self 
	    assert: (printer print: (Date 
			    year: 1980
			    month: 1
			    day: 1)) 
		    = '80'.
	self 
	    assert: (printer print: (Date 
			    year: 2009
			    month: 1
			    day: 1)) 
		    = '09'
    ]

    testUnpaddedCentury [
	<category: 'testing-parts-date'>
	| printer |
	printer := GRPrinter unpaddedCentury.
	self 
	    assert: (printer print: (Date 
			    year: 1980
			    month: 1
			    day: 1)) 
		    = '80'.
	self 
	    assert: (printer print: (Date 
			    year: 2009
			    month: 1
			    day: 1)) 
		    = '9'
    ]

    testUnpaddedDay [
	<category: 'testing-parts-date'>
	| printer |
	printer := GRPrinter unpaddedDay.
	self 
	    assert: (printer print: (Date 
			    year: 2000
			    month: 1
			    day: 4)) 
		    = '4'.
	self 
	    assert: (printer print: (Date 
			    year: 2000
			    month: 1
			    day: 19)) 
		    = '19'
    ]

    testUnpaddedMonth [
	<category: 'testing-parts-date'>
	| printer |
	printer := GRPrinter unpaddedMonth.
	self 
	    assert: (printer print: (Date 
			    year: 2000
			    month: 8
			    day: 1)) 
		    = '8'.
	self 
	    assert: (printer print: (Date 
			    year: 2000
			    month: 11
			    day: 1)) 
		    = '11'
    ]

    testUnpaddedYear [
	<category: 'testing-parts-date'>
	| printer |
	printer := GRPrinter unpaddedYear.
	self 
	    assert: (printer print: (Date 
			    year: 766
			    month: 1
			    day: 1)) 
		    = '766'.
	self 
	    assert: (printer print: (Date 
			    year: 1980
			    month: 1
			    day: 1)) 
		    = '1980'.
	self 
	    assert: (printer print: (Date 
			    year: 2009
			    month: 1
			    day: 1)) 
		    = '2009'
    ]

    testPaddedHour12 [
	<category: 'testing-parts-time'>
	| printer |
	printer := GRPrinter paddedHour12.
	self 
	    assert: (printer print: (Time 
			    hour: 5
			    minute: 0
			    second: 0)) 
		    = '05'.
	self 
	    assert: (printer print: (Time 
			    hour: 10
			    minute: 0
			    second: 0)) 
		    = '10'.
	self 
	    assert: (printer print: (Time 
			    hour: 14
			    minute: 0
			    second: 0)) 
		    = '02'.
	self 
	    assert: (printer print: (Time 
			    hour: 23
			    minute: 0
			    second: 0)) 
		    = '11'
    ]

    testUnpaddedHour12 [
	<category: 'testing-parts-time'>
	| printer |
	printer := GRPrinter unpaddedHour12.
	self 
	    assert: (printer print: (Time 
			    hour: 5
			    minute: 0
			    second: 0)) 
		    = '5'.
	self 
	    assert: (printer print: (Time 
			    hour: 10
			    minute: 0
			    second: 0)) 
		    = '10'.
	self 
	    assert: (printer print: (Time 
			    hour: 14
			    minute: 0
			    second: 0)) 
		    = '2'.
	self 
	    assert: (printer print: (Time 
			    hour: 23
			    minute: 0
			    second: 0)) 
		    = '11'
    ]

    testUnpaddedHour24 [
	<category: 'testing-parts-time'>
	| printer |
	printer := GRPrinter unpaddedHour24.
	self 
	    assert: (printer print: (Time 
			    hour: 5
			    minute: 0
			    second: 0)) 
		    = '5'.
	self 
	    assert: (printer print: (Time 
			    hour: 10
			    minute: 0
			    second: 0)) 
		    = '10'.
	self 
	    assert: (printer print: (Time 
			    hour: 14
			    minute: 0
			    second: 0)) 
		    = '14'.
	self 
	    assert: (printer print: (Time 
			    hour: 23
			    minute: 0
			    second: 0)) 
		    = '23'
    ]

    testUnpaddedMinute [
	<category: 'testing-parts-time'>
	| printer |
	printer := GRPrinter unpaddedMinute.
	self 
	    assert: (printer print: (Time 
			    hour: 0
			    minute: 5
			    second: 0)) 
		    = '5'.
	self 
	    assert: (printer print: (Time 
			    hour: 0
			    minute: 12
			    second: 0)) 
		    = '12'
    ]

    testUnpaddedSecond [
	<category: 'testing-parts-time'>
	| printer |
	printer := GRPrinter unpaddedSecond.
	self 
	    assert: (printer print: (Time 
			    hour: 0
			    minute: 0
			    second: 0)) 
		    = '0'.
	self 
	    assert: (printer print: (Time 
			    hour: 0
			    minute: 0
			    second: 9)) 
		    = '9'.
	self 
	    assert: (printer print: (Time 
			    hour: 0
			    minute: 0
			    second: 12)) 
		    = '12'
    ]

    testSwissCurrency [
	<category: 'testing-currency'>
	| printer |
	printer := GRPrinter swissCurrency.
	self assert: (printer print: 12.34) = 'CHF 12.35'.
	self assert: (printer print: -12.39) = 'CHF -12.40'
    ]

    testUsCurrency [
	<category: 'testing-currency'>
	| printer |
	printer := GRPrinter usCurrency.
	self assert: (printer print: 12.34) = '$12.34'.
	self assert: (printer print: -12.34) = '-$12.34'
    ]
]

