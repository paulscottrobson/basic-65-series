# Tokenising

| Bytes | Description                                                  |
| ----- | ------------------------------------------------------------ |
| 00-1F | Pointer to an identifier record in the variable page so 1E 38 indicates a record at offset $1E38 in the page |
| 20-2A | Indicates an extension for decimal points.  The LSB is the number of characters after the decimal point, so the following constant is divided by 10^x where x is the LSB. 0 is not used, but is reserved here. |
| 2B-2F | Reserved, but assumed to require a second byte (every byte less than $30 is a 2 byte token) |
| 30 xx | Indicates a length prefixed string of up to 255 characters. 30 00 is the null character, 30 01 65 is "A" for example. |
| 31-3F | Reserved, unspecified for incrementing.                      |
| 40-7F | 6 bit shift constructing integers.                           |
| 80-8F | Structure tokens  WHILE WEND REPEAT UNTIL FOR NEXT even ones increment the count, odd ones decrement. IF THEN ELSE are not here as there is no structured IF as yet. |
| 90-9F | Binary operator tokens + - * /  : AND OR XOR  > : = < >= <= : <> >> << (1 free may be ^) |
| A0    | End of Line [EOL]                                            |
| A1-A3 | 3 shifts [SH1,SH2,SH3] shifted token must be in the range 90-FF |
| A4-   | Function tokens (up to a fixed constant)                     |
| -FF   | (from a fixed constant) Other tokens including punctuation like ':' |

