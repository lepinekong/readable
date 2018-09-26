Red [
    Title: ""
]

.Read-ReAdABLE: function [>ReAdABLE-path][

    {Example: 
        transactions: read-readable %db/trading-journal.read 
    }

    return transactions: load >ReAdABLE-path
]

Read-ReAdABLE: :.Read-ReAdABLE
