# Stencil

## Introduction
Stencil is a thin cover for [Dyalog APL](https://www.dyalog.com/)'s ⌺ [Stencil operator](http://help.dyalog.com/16.0/Content/Language/Primitive%20Operators/Stencil.htm) and is intended as golfing language and an easy interface for common tasks involving `⌺`. Stencil code can in fact easily be rewritten as normal Dyalog APL code.

Feel free to contact me, [Adám](https://stackexchange.com/users/3114363/ad%C3%A1m), in Stack Exchange's [APL chat room](https://chat.stackexchange.com/rooms/52405/apl) to learn more about Stencil and Dyalog APL.

## In-APL Usage

Execute `2⎕FIX'file://path/Stencil.dyalog` to load the operator.

The syntax is `result←opts (code Stencil specs) input`, but `opts` is optional.

For the specifics of [`opts`](https://github.com/abrudz/Stencil/blob/master/README.md#command-line-options), [`code`](https://github.com/abrudz/Stencil/blob/master/README.md#code), and [`specs`](https://github.com/abrudz/Stencil/blob/master/README.md#arguments), see the linked guidance for the corresponding TIO fields.

Input is an array specifying the initial state.

| `opts` | `result` |
| :---: | --- |
| none | final state or last state before going to a previously encountered state |
| `∊` | vector of states |
| `≢` | scalar non-negative integer |
| `≡` | 0-by-0 numeric matrix |
| number | a state |

If code is a function, then identifiers may be both single- and multi-letter, and spaces are needed to separate them, i.e. `me` is *not* equivalent to `m e`, and `⎕IO` is *not* set to `0` either. However, the predefined values listed [`below`](https://github.com/abrudz/Stencil/blob/master/README.md#code) *are* available.

## TIO User guide

[Try It Online](https://tio.run/#home) is a code testing website for many programming languages, both practical and recreational ones, made by Stack Exchange user [Dennis](https://codegolf.stackexchange.com/users/12012). The following describes the relevant fields when using [Stencil on TIO](https://tio.run/#stencil). 

### Command-line options
This may be any one of the following options:

| opt | Effect |
| :---: | --- |
| none | return final state or last state before going to a previously encountered state |
| `∊` | return list of states from input to final state or last state before going to a previously encountered state |
| `≢` | return the number of states in the above |
| `≡` | output states until stable, or forever if cyclic |
| number | return the state after that many states |

combined with any of the following options:

| opt | Effect |
| :---: | --- |
| `P` | `┌───┐` Plane:<br> `│   │` left and right disconnected<br> `└───┘` lower and upper disconnected |
| `C` | `┌───┐` Cylinder:<br> `↑   ↑` left and right joined<br> `└───┘` lower and upper disconnected |
| `T` | `┌─→─┐` Torus:<br> `↑   ↑` left and right joined<br> `└─→─┘` lower and upper joined |
| `M` | `┌─→─┐` Möbius strip:<br> `│   │` left and right disconnected<br> `└─←─┘` lower and upper twist-joined |
| `K` | `┌─→─┐` Klein bottle:<br> `↑   ↑` left and right joined<br> `└─←─┘` lower and upper twist-joined |
| `R` | `┌─→─┐` Real projective plane:<br> `↑   ↓` left and right twist-joined<br> `└─←─┘` lower and upper twist-joined |
| `I` | `┌   ┐` Infinite:<br> `     ` left and right expand and shrink as needed<br> `└   ┘` lower and upper expand and shrink as needed |

### Code
This describes what shall be returned for each neighbourhood. It may be a function, or one or more character vectors.

If a single character vector, then this forms the body (i.e. without outer curly braces) of a dfn left operand to 
`⌺`. For more information about the `⌺` operator, see [its documentation](http://help.dyalog.com/16.0/Content/Language/Primitive%20Operators/Stencil.htm).

If two character vectors, then the first will be used as a dfn snippet (<code> ⍵</code> is appended to its right) to post-process the result(s).

If three or more character vectors, then the last will additionally be used as a dfn snippet (<code> ⍵</code> is appended to its right) to pre-process the input(s).

Stencil provides some shortcuts not available to with the original `⌺`.  All identifiers are expected to be single-letter, and no spaces are needed to separate them, i.e. `me` is equivalent to `m e`. The following values are pre-defined:

Note that all code runs with `⎕IO←0` (0-based **I**ndex **O**rigin).

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
| `N` | vector of von neumanN neighbourhood without self |
| `n` | count of non-empty cells in the above |
| `S` | scalar self  |
| `s` | Boolean (1 or 0) for whether above is non-empty    |
| `P` | vector of Booleans for each dimension whether it has been padded or not  |
| `p` | number of dimensions which have been padded |
| `⍺` | vector of amounts of padding for each dimension |
| `W` | original input |
| `w` | flattened original input |
| `Y` | preprocessed input |
| `y` | flattened preprocessed input |

In the above table, *Moore neighbordhood* means the entire n×m neighbourhood, while *von Neumann neighbourhood* means cells orthogonal to the self.

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

To calculate the period of a cyclic pattern (an [oscillator](https://en.wikipedia.org/wiki/Oscillator_(cellular_automaton)) or a [spaceship](https://en.wikipedia.org/wiki/Spaceship_(cellular_automaton)), add the command-line options `≢I`

To check whether a patter is a [still life](https://en.wikipedia.org/wiki/Still_life_(cellular_automaton)), add the command-line options `≢I` and let code be `1=` `3∊me`.

### Primality checker

Command-line option: `1`

Code: `~S∊1,∘.×⍨2+⍳S`

Input has one or more lists of integers. For each such **S**elf, it generates the integers from 0 to **S**elf-1 (`⍳S`), adds 2 (`2+`), giving from 2 to Self+1, creates a multiplication table (`∘.×⍨`), prepends a column of ones (`1,`), and asks whether the **S**elf is a member thereof (`S∊`), and then negates that (`~`).
