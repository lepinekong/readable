Red [
    Title: ""
]

if not value? '.redlang [
    do https://redlang.red
]
.redlang [read remove-last]


.save-readable: function [>file >block][

    out: copy ""


    lines: .read/lines mold >block
    lines: skip lines 1

    remove-last lines

    forall lines [
        line: lines/1
        parse line [thru "    " copy line to end]
        append out line
        append out newline
    ]
    write >file out

]

save-readable: :.save-readable
