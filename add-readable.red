Red [
    Title: ""
    Note: {when adding block remove first bracket}

]

if not value? '.redlang [
    do https://redlang.red
]
.redlang [get-block-content]

.add-ReAdABLE: function[
    .readable-source [file! url! block!] 
    .key [string! word! path!] 
    .value [any-type!] ; 0.0.0.2.8
    /duplicate ; duplicate key authorized
    /_build
    /silent
][

    >builds: [
        0.0.0.3.2 {support for favorites/bookmarks/documentaries/Finance key}
        0.0.0.2.10 {support for block value}
    ]

    if _build [
        unless silent [
            ?? >builds
        ]
        return >builds
    ]

    {Example:
        T-2017.12.08-0001: [

            .SYMBOL: AAPL
            .CURRENCY: DOLLAR
            .BROKER: GOLDMAN-SACHS         

            .ACTION-ENTRY: BOUGHT
            .QTY-ENTRY: 100
            .PRICE-ENTRY: 175.95
            .DATETIME-ENTRY: 18/12/2017

        ] 

        transactions: %db/trading-journal.read 
        add-readable transactions 'T-2017.12.08-0001 T-2017.12.08-0001
    }

    is-source-file?: false
    
    either not block? .readable-source [
        readable-block: .read-readable .readable-source
        is-source-file?: true
    ][
        readable-block: .readable-source
    ]

    ; / ---------------------------------
    .append-key-value: function[.block [block!] .key [string! word! path!] .value][
            if error? try [
                append .block new-line reduce [(to-set-word .key) .value] true ; 0.0.0.2.7
                
            ][
                
                if (length? .value) = 1 [
                    if block? .value/1 [
                        .value: .value/1
                    ]
                ]
                append (do .key) new-line .value true ; 
            ]
            
            return .block
    ]
    ; // ---------------------------------

    key-value: false
    unless duplicate [
        key-value: select readable-block .key
    ]

    either key-value [ ; 0.0.0.1.2: if key exists do not create duplicate key unless specified
        if block? .value [
            append key-value new-line (.value/1) true
        ]
        
    ][
        .append-key-value readable-block .key .value
    ]

    ;=== 0.0.0.1.6: save to file
    if is-source-file? [
        save (.readable-source) (readable-block)
    ]
]

add-ReAdABLE: :.add-ReAdABLE
