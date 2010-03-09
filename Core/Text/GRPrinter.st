GRObject subclass: GRPrinter [
    
    <comment: nil>
    <category: 'Grease-Core-Text'>

    GRPrinter class >> cookieTimestamp [
	"Netscape's original proposal defined an Expires header that took a date value in a fixed-length variant format in place of Max-Age: Wdy, DD-Mon-YY HH:MM:SS GMT"

	<category: 'factory'>
	^GRMappedPrinter block: [:timestamp | timestamp asUTC]
	    next: self abbreviatedWeekName , ', ' , self paddedDay , '-' 
		    , self abbreviatedMonthName , '-' 
		    , self paddedYear , ' ' 
		    , self isoTime , ' GMT'
    ]

    GRPrinter class >> httpDate [
	"Answers a printer that formats dates for HTTP1.1 (RFC 2616)"

	<category: 'factory'>
	^self rfc1123
    ]

    GRPrinter class >> isoDate [
	"Ansers a printer that formats dates accoring to ISO(YYYY-MM-DD) E.g.
	 2003-12-24"

	<category: 'factory'>
	^self paddedYear , $- , self paddedMonth , $- , self paddedDay
    ]

    GRPrinter class >> isoTime [
	"Ansers a printer that formats time accoring to ISO(HH:MM:SS) E.g.
	 12:23:34"

	<category: 'factory'>
	^self paddedHour24 , $: , self paddedMinute , $: , self paddedSecond
    ]

    GRPrinter class >> rfc1123 [
	"Answers a printer that formats dates for HTTP1.1 (RFC 1123). Eg.
	 Sun, 06 Nov 1994 08:49:37 GMT"

	<category: 'factory'>
	^GRMappedPrinter block: 
		[:date | 
		"For the purposes of HTTP, GMT is exactly equal to UTC (Coordinated Universal Time)"

		date asUTC]
	    next: GRSequentialPrinter new , self abbreviatedWeekName , ', ' 
		    , self paddedDay , Character space 
		    , self abbreviatedMonthName , Character space 
		    , self paddedYear , Character space 
		    , self isoTime , ' GMT'
    ]

    GRPrinter class >> rfc822 [
	"Answers a privter that formats dates according to RFC 822 (email). Eg.
	 Sun, 31 Aug 2008 19:41:46 +0200"

	<category: 'factory'>
	^self abbreviatedWeekName , ', ' , self paddedDay , Character space 
	    , self abbreviatedMonthName , Character space 
	    , self paddedYear , Character space 
	    , self isoTime , Character space 
	    , self offsetSign , self absOffsetHoursPadded 
	    , self absOffsetMinutesPadded
    ]

    GRPrinter class >> rfc822WithTimeZone: aString [
	"Answers a privter that formats dates according to RFC 822 (email) with the given time zone String. Eg.
	 Sun, 31 Aug 2008 19:41:46 <aString>"

	<category: 'factory'>
	^self abbreviatedWeekName , ', ' , self paddedDay , Character space 
	    , self abbreviatedMonthName , Character space 
	    , self paddedYear , Character space 
	    , self isoTime , Character space 
	    , aString
    ]

    GRPrinter class >> swissCurrency [
	<category: 'factory'>
	^GRSequentialPrinter new , 'CHF ' , GRSignPrinter new 
	    , ((GRNumberPrinter new)
		    separator: $';
		    precision: 2;
		    accuracy: 0.05;
		    yourself)
    ]

    GRPrinter class >> usCurrency [
	<category: 'factory'>
	^GRSignPrinter new , $$ , ((GRNumberPrinter new)
		    separator: $,;
		    precision: 2;
		    yourself)
    ]

    GRPrinter class >> abbreviatedMonthName [
	<category: 'parts-date'>
	^self 
	    monthName: #('Jan' 'Feb' 'Mar' 'Apr' 'May' 'Jun' 'Jul' 'Aug' 'Sep' 'Oct' 'Nov' 'Dec')
    ]

    GRPrinter class >> abbreviatedWeekName [
	<category: 'parts-date'>
	^self weekName: #('Sun' 'Mon' 'Tue' 'Wed' 'Thu' 'Fri' 'Sat')
    ]

    GRPrinter class >> absOffsetHoursPadded [
	<category: 'parts-date'>
	^GRMappedPrinter block: [:date | date offset hours abs]
	    next: (self numberWithAtLeastDigits: 2)
    ]

    GRPrinter class >> absOffsetMinutesPadded [
	<category: 'parts-date'>
	^GRMappedPrinter block: [:date | date offset minutes abs]
	    next: (self numberWithAtLeastDigits: 2)
    ]

    GRPrinter class >> fullMonthName [
	<category: 'parts-date'>
	^self 
	    monthName: #('January' 'February' 'March' 'April' 'May' 'June' 'July' 'August' 'September' 'October' 'November' 'December')
    ]

    GRPrinter class >> fullWeekName [
	<category: 'parts-date'>
	^self 
	    weekName: #('Sunday' 'Monday' 'Tuesday' 'Wednesday' 'Thursday' 'Friday' 'Saturday')
    ]

    GRPrinter class >> monthName: anArray [
	<category: 'parts-date'>
	^GRPluggablePrinter on: [:date | anArray at: date monthIndex]
    ]

    GRPrinter class >> offsetSign [
	<category: 'parts-date'>
	^GRMappedPrinter block: [:date | date offset]
	    next: ((GRSignPrinter new)
		    positivePrinter: $+;
		    negativePrinter: $-;
		    yourself)
    ]

    GRPrinter class >> paddedCentury [
	<category: 'parts-date'>
	^GRMappedPrinter block: [:date | date year \\ 100]
	    next: (self numberWithAtLeastDigits: 2)
    ]

    GRPrinter class >> paddedDay [
	<category: 'parts-date'>
	^GRMappedPrinter block: [:date | date dayOfMonth]
	    next: (self numberWithAtLeastDigits: 2)
    ]

    GRPrinter class >> paddedMonth [
	<category: 'parts-date'>
	^GRMappedPrinter block: [:date | date monthIndex]
	    next: (self numberWithAtLeastDigits: 2)
    ]

    GRPrinter class >> paddedYear [
	<category: 'parts-date'>
	^GRMappedPrinter block: [:date | date year]
	    next: (self numberWithAtLeastDigits: 4)
    ]

    GRPrinter class >> unpaddedCentury [
	<category: 'parts-date'>
	^GRMappedPrinter block: [:date | date year \\ 100]
	    next: GRNumberPrinter new
    ]

    GRPrinter class >> unpaddedDay [
	<category: 'parts-date'>
	^GRMappedPrinter block: [:date | date dayOfMonth] next: GRNumberPrinter new
    ]

    GRPrinter class >> unpaddedMonth [
	<category: 'parts-date'>
	^GRMappedPrinter block: [:date | date monthIndex] next: GRNumberPrinter new
    ]

    GRPrinter class >> unpaddedYear [
	<category: 'parts-date'>
	^GRMappedPrinter block: [:date | date year] next: GRNumberPrinter new
    ]

    GRPrinter class >> weekName: anArray [
	<category: 'parts-date'>
	^GRPluggablePrinter on: [:date | anArray at: date dayOfWeek]
    ]

    GRPrinter class >> paddedHour12 [
	<category: 'parts-time'>
	^GRMappedPrinter block: [:time | (time hour - 1) \\ 12 + 1]
	    next: (self numberWithAtLeastDigits: 2)
    ]

    GRPrinter class >> paddedHour24 [
	<category: 'parts-time'>
	^GRMappedPrinter block: [:time | time hour]
	    next: (self numberWithAtLeastDigits: 2)
    ]

    GRPrinter class >> paddedMinute [
	<category: 'parts-time'>
	^GRMappedPrinter block: [:time | time minute]
	    next: (self numberWithAtLeastDigits: 2)
    ]

    GRPrinter class >> paddedSecond [
	<category: 'parts-time'>
	^GRMappedPrinter block: [:time | time second]
	    next: ((GRNumberPrinter new)
		    padding: $0;
		    digits: 2)
    ]

    GRPrinter class >> unpaddedHour12 [
	<category: 'parts-time'>
	^GRMappedPrinter block: [:time | (time hour - 1) \\ 12 + 1]
	    next: GRNumberPrinter new
    ]

    GRPrinter class >> unpaddedHour24 [
	<category: 'parts-time'>
	^GRMappedPrinter block: [:time | time hour] next: GRNumberPrinter new
    ]

    GRPrinter class >> unpaddedMinute [
	<category: 'parts-time'>
	^GRMappedPrinter block: [:time | time minute] next: GRNumberPrinter new
    ]

    GRPrinter class >> unpaddedSecond [
	<category: 'parts-time'>
	^GRMappedPrinter block: [:time | time second] next: GRNumberPrinter new
    ]

    GRPrinter class >> binaryFileSize [
	<category: 'parts-units'>
	^GRUnitPrinter base: 1024
	    units: #('byte' 'bytes' 'KiB' 'MiB' 'GiB' 'TiB' 'PiB' 'EiB' 'ZiB' 'YiB')
    ]

    GRPrinter class >> decimalFileSize [
	<category: 'parts-units'>
	^GRUnitPrinter base: 1000
	    units: #('byte' 'bytes' 'kB' 'MB' 'GB' 'TB' 'PB' 'EB' 'ZB' 'YB')
    ]

    GRPrinter class >> numberWithAtLeastDigits: anInteger [
	<category: 'parts-units'>
	^(GRNumberPrinter new)
	    padding: $0;
	    digits: anInteger;
	    yourself
    ]

    , aPrinter [
	<category: 'operators'>
	^GRSequentialPrinter new , self , aPrinter
    ]

    print: anObject [
	<category: 'printing'>
	^String streamContents: [:stream | self print: anObject on: stream]
    ]

    print: anObject on: aStream [
	"Subclasses override this method to produce some output."

	<category: 'printing'>
	
    ]

    pad: aString center: aCharacter to: anInteger [
	"Pad to the center of aString with aCharacter to at least anInteger characters."

	<category: 'utilities'>
	| result index |
	anInteger <= aString size ifTrue: [^aString].
	index := (anInteger - aString size) // 2.
	result := (String new: anInteger) atAllPut: aCharacter.
	result 
	    replaceFrom: index + 1
	    to: index + aString size
	    with: aString
	    startingAt: 1.
	^result
    ]

    pad: aString left: aCharacter to: anInteger [
	"Pad to the left side of aString with aCharacter to at least anInteger characters."

	<category: 'utilities'>
	| result |
	anInteger <= aString size ifTrue: [^aString].
	result := (String new: anInteger) atAllPut: aCharacter.
	result 
	    replaceFrom: anInteger - aString size + 1
	    to: anInteger
	    with: aString
	    startingAt: 1.
	^result
    ]

    pad: aString right: aCharacter to: anInteger [
	"Pad to the right side of aString with aCharacter to at least anInteger characters."

	<category: 'utilities'>
	| result |
	anInteger <= aString size ifTrue: [^aString].
	result := (String new: anInteger) atAllPut: aCharacter.
	result 
	    replaceFrom: 1
	    to: aString size
	    with: aString
	    startingAt: 1.
	^result
    ]
]
