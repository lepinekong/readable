Red [
    Title: ""
]

Add-ReAdABLE: function[.readable-source [file! url! block!] .key [string! word! path!] .value][

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

    either not block? .readable-source [
        readable-block: .read-readable .readable-source
    ][
        readable-block: .readable-source
    ]
    

    .append-key-value: function[.block [block!] .key [string! word! path!] .value][

            append/only .block to-set-word .key
            append/only .block .value
            return .block
    ] 

    return .append-key-value readable-block .key .value

]
