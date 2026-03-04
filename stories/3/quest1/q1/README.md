# Quest 1: Scales Analysis

This project is an Elixir-based solution for "Everybody Codes" - Story 3, Quest 1.

The application reads and parses encoded data strings representing dragon scales to identify specific characteristics. It features an efficient recursive string parser to convert case-sensitive alphabetic binary representations (lowercase = `0`, uppercase = `1`) directly into integers.

## Execution

The project defines a default Mix task to automatically run all three parts of the quest sequentially.

From the `q1` directory, you can simply run:

```bash
mix
```

This will run:
1. `Q1.part1("../inputa.txt")`
2. `Q1.part2("../inputb.txt")`
3. `Q1.part3("../inputc.txt")`

...and print the respective results to the console.

## Quest Breakdown

### Part 1
Reads `inputa.txt`. Parses lines consisting of an ID and 3 string components. It checks if the middle component (Green) is strictly greater than the first (Red) and third (Blue) components. If so, it takes the ID; otherwise, it takes `0`. Finally, it returns the sum of these values.

### Part 2
Reads `inputb.txt`. Parses lines consisting of an ID and 4 string components (Red, Green, Blue, and Shine). It finds the scale with the greatest Shine value. In case of a tie, it falls back to the scale with the lowest combined Red, Green, and Blue values, and returns its ID.

### Part 3
Reads `inputc.txt` and groups the scales based on their dominant color (strictly highest among the 3 colors) and their shine property (`<= 30` is matte, `>= 33` is shiny). Scales lacking a dominant color or falling in the indeterminate shine range `(31, 32)` are ignored. The program determines the largest group of valid scales (e.g., "red-matte", "blue-shiny") and returns the sum of their IDs.

## Testing

The module is fully tested, containing both unit tests and doctests based on the quest's sample input examples.

To run the test suite:

```bash
mix test
```
