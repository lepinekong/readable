Red [
    Title: ""
]

.Read-ReAdABLE: function [
    >ReAdABLE-path 
    /section '>section
    /list-sections
][

    {Example: 
        transactions: read-readable %db/trading-journal.read 
    }

    data-block>: load >ReAdABLE-path

    if list-sections [
        obj: context data-block>
        list-sections>: words-of obj
        return list-sections>
    ]

    either section [
        section>: select data-block> to-word form >section
        return section>
    ][
        return data-block>
    ]
]

Read-ReAdABLE: :.Read-ReAdABLE
