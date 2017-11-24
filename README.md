# Stencil

## Introduction
Stencil is a golfing language which is barely more than a thin cover for [Dyalog APL](https://www.dyalog.com/)'s ⌺ [Stencil operator](http://help.dyalog.com/16.0/Content/Language/Primitive%20Operators/Stencil.htm). Stencil code can in fact easily be translated to normal Dyalog APL.

Feel free to contact me, [Adám](https://stackexchange.com/users/3114363/ad%C3%A1m), in Stack Exchange's [APL chat room](https://chat.stackexchange.com/rooms/52405/apl) to learn more about Stencil and Dyalog APL.

## User guide

[Try It Online](https://tio.run/#home) is a code testing website for many programming languages, both practical and recreational ones, made by Stack Exchange user [Dennis](https://codegolf.stackexchange.com/users/12012). The following describes the relevant fields when using [Stencil on TIO](https://tio.run/#stencil). 

### Command-line options
This may be any of the following options:

| opt | Effect |
| :---: | --- |
| none | return final state or last state before going to a previously encountered state |
| `∊` | return list of states from input to final state or last state before going to a previously encountered state |
| `≢` | return number of steps needed until final state or last state before going to a previously encountered state |
| `≡` | output states until stable, or forever if cyclic |
| number | return the state after that many states |

### Code
This describes what shall be returned for each neighbourhood. It is the body (i.e. without outer curcly braces) of a dfn left operand to 
`⌺`. See the `⌺` documentation for more information about the operator, see [its ducumentation](http://help.dyalog.com/16.0/Content/Language/Primitive%20Operators/Stencil.htm).

Stencil provides some shortcuts not available to with original `⌺`.  All identifiers are expected to be single-letter, and no spaces are needed to separate them, i.e. `me` is equivalent to `m e`. The following values are pre-defined: used for every dimension. If no size is given, `3` will be used in every dimensize in.

Note that the code runs with `⎕IO←0` (0-based **I**ndex **O**rigin).

Examples:

`3 5` will use 3-row, 5-column neighbourhoods

`⍪3 3` will use neighbourhoods of size 3 in every dimension, and step size 

| name | Description |
| :---: | ------- |
| `⍵` | multi-dimensional Moore neighbourhood with self |
| `M` | vector of Moore neighbourhood with self |
| `m` | count of non-empty cells in the above | 
| `E` | vector of moorE neighbourhood without self | 
| `e` | count of non-empty cells in the above | 
| `V` | vector of Von neumann neighbourhood with self | 
| `v` | count of non-empty cells in the above |
| `N` | vector of Von neumann neighbourhood with self |
| `n` | count of non-empty cells in the above |
| `S` | scalar self  |
| `s` | Boolean (1 or 0) for whether above is non-empty    |
| `P` | vector of Booleans for each dimension whether it has been padded or not  |
| `p` | number of dimensions which have been padded |
| `⍺` | vector of amounts of padding for each dimension |

In the above table, *Moore neighbordhood* means the entire n×m neighbourhood, while *van Neumann neighbourhood* means cells orthogonal to the self.

### Input
Each line is an APL expression for an initial state. Each will be processed separately.
 
### Arguments
This allows specifying the neighbourhood and step size. The arguments will be joined with spaces and executed as an APL expression to be used as right operand for `⌺`. Stencil provides two shortcuts not available to with original `⌺`. If a single size is given, it will be used for every dimension. If no size is given, size 3 will be used in every dimension.

Examples:

`3 5` will use 3-row, 5-column neighbourhoods

`⍪5 3` will use  neighbourhoods of size 5 in every dimension with a step size of 3 in every dimension

## Examples

### Hello, World!

Code: `S`

Input `Hello, World!`

Every character will be replaced by it**S**elf.

### Game of Life

Code: `3∊me`

A cell will be alive in the next genration if there are 3 live cells either counting itself or not.

To get just the next generation, add the command-line option `1`.

To list all generations, add the command-line options `∊`.

### Primality checker

Command-line option: `1`

Code: `~S∊1,∘.×⍨2+⍳S`

Input has one or more lists of integers. For each such **S**elf, it generates the integers from 0 to **S**elf-1 (`⍳S`), adds 2 (`2+`), giving from 2 to Self+1, creates a multiplication table (`∘.×⍨`), prepends a column of ones (`1,`), and asks whether the **S**elf is a member thereof (`S∊`), and then negates that (`~`).
