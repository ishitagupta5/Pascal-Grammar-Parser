# Pascal-Grammar-Parser
A Pascal program that parses simplified English sentences using a custom grammar and generates parenthesized parse trees.

## Grammar Rules

<sentence> --> <subject> <verb_phrase> <object>
<subject> --> <noun_phrase>
<verb_phrase> --> <verb> | <verb> <adv>
<object> --> <noun_phrase>
<verb> --> lifted | saw | found
<adv> --> quickly | carefully | brilliantly
<noun_phrase> --> [<adj_phrase>] <noun> [<prep_phrase>]
<noun> --> cow | alice | book
<adj_phrase> --> <adj> | <adj> <adj_phrase>
<adj> --> green | lean | mean
<prep_phrase> --> <prep> <noun_phrase>
<prep> --> of | at | with

## Files

- `p1.pas` – Main Pascal source file
- `input.txt` – Sample input file with one sentence per line
- `output.txt` – Output file with parse results or error messages

## How to Compile and Run

You can compile the program using Free Pascal:

```bash
fpc p1.pas
./p1 input.txt output.txt
```

## Input Format
Each line in the input file should be a simple sentence using only valid words from the grammar. Example:

```bash
Mean cow found book
green mean book lifted cow quickly
alice saw book with green cow
```

## Output
Each line of input will produce either:

A fully parenthesized parse tree

An error message indicating either invalid tokens or ungrammatical structure

```bash
input-line => alice saw book
	((alice) (saw) (book))
input-line => green book lifted alice with mean cow
	((green(book)) (lifted) (alice(with(mean(cow)))))
```
