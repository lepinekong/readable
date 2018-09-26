Red [
    Title: ""
]

.Read-ReAdABLE: function [>ReAdABLE-path /section '>section][

    {Example: 
        transactions: read-readable %db/trading-journal.read 
    }

    data-block>: load >ReAdABLE-path

    either section [
        section>: select data-block> to-word form >section
        return section>
    ][
        return data-block>
    ]
]

Read-ReAdABLE: :.Read-ReAdABLE
