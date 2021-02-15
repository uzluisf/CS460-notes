# Syntax

The task of providing a concise yet understandable description of a programming
language is difficult but essential to a language’s success:

* On one hand, concise formal descriptions that aren't easily understandable due
  to partly new notation cause languages to lack implementations.

* On the other hand, some languages have suffered the problem of having many
  slightly different dialects, a result of a simple but informal and imprecise
  definition.

## Syntax vs Semantic

* **Syntax** is the **form** of a programming language's expressions,
  statements, and program units.
  * Typically described using **grammars**.
  * It's easier to describe than semantic, partly because a concise and
    universally accepted notation is available for syntax description.

* **Semantic** is the **meaning** of those expressions, statements, and program
  units.
  * Typically described informally (e.g., English).
  * No universal notation has been developed for semantic so it's harder to
  describe than syntax.

Syntax and semantics are closely related. In a well-designed programming
language, semantics should follow directly from syntax; that is, the appearance
of a statement should strongly suggest what the statement is meant to
accomplish.

### Syntax Terminology

* **Sentence.** A sentence is a string of characters over some given alphabet.
  For example, `int foo = 5;` is a sentence over the alphabet that constitutes
  the C language.

* **Language.** A language is a set of sentences. For example, the set of all
  legal C programs.

* **Token.** A token is category of primitve units such as numeric literals,
  operators, keywords, etc.

* **Lexeme.** A lexeme is a small unit described by a token. For example, the
  lexeme 5 is described by the token numeric literal, the lexeme `for` is
  described by the token keyword, etc.

For example, given the following C statement:

```c
index = 2 * count + 17;
```

we've the following lexemes-tokens breakdown:

|Lexemes|Tokens|
|:------|:-----|
|`index`|identifier|
|`=`|equal_sign|
|`2`|int_literal|
|`*`|mult_op|
|`count`|identifier|
|`+`|plus_op|
|`17`|int_literal|
\`;`|semicolon|

## Why Care About Formal Syntax?

In general, languages can be formally defined in two distinct ways:

* **Recognition:** Given an arbitrary sentence, determine whether it's legal in
  some given language. For example, a compiler's syntax analyzer is a
  *recognition device* that determines if a given sentence (e.g., whole
  programs) is a legal sentence in whatever language the compiler translates to.
  Such devices are like filters, separating legal sentences from those that are
  incorrectly formed.

  Recognition devices can only be used in trial-and-error mode. For example, to
  determine the correct syntax of a particular statement using a compiler, the
  programmer can only submit a speculated version and note whether the compiler
  accepts it. Thus they're not as useful a language description for a
  programmer.

* **Generation:** Given the formal sentence of a language, legal sentences are
  generated. Devices that generate the sentences of a language are known as
  **generation devices**.
    
  Unlike recognizers, generators are oftentimes useful to programmers because
  it's often possible to determine whether the syntax of a particular statement
  is correct by comparing it with the structure of the generator.

There is a close connection between formal generation and recognition devices
for the same language. This was one of the seminal discoveries in computer
science, and it led to much of what is now known about formal languages and
compiler design theory.

## Chomsky's Hierarchy of Languages

|Type|Grammar|Machine|Applications|
|:---|:------|:------|:-----------|
|3|regular|DFA, NFA, ...|pattern matching, lexical structure|
|2|context-free|PDA|PLs (typically)|
|1|context-sensitive|bounded TM (Turing Machine)|Natural languages (exc. poetry)|
|0|recursive enumerable|TM||

Remember that pushdown automatas (PDAs) have only one stack.

## Context-Free Grammars

Typically represented using Backus-Naur Form (BNF) which is equivalent to CFG.

Formally, a CFG <Σ, V, P> where

* Σ is a set of **terminal symbols** (e.g., lexemes and tokens),
* V is a set of **nonterminal symbols** (aka variables), containing a start
  symbol S,
* P is a finite non-empty set of **rules** (or **productions**), each of the
  form:
  
  * A -> ɑ, where A is a single nonterminal symbol, and ɑ is a finite sequence
  of terminals and/or nonterminals,
  * A belongs to V,
  * each nonterminal has at least one production, and
  * at least one production has S on its left-hand side (LHS).

### BNF Notation and Abbreviations

BNF uses abstractions for syntactic structures. For example, a simple Java
assignment might represented by the following abstraction:

```bnf
<assign> -> <var> = <expression>
```

| Abstraction | Meaning |
|:------------|:--------|
| `<assign>` | This is the abstraction being defined; this is usually known as the **left-hand side** (LHS). |
| `<var> = <expression>` | This is the definition of the LHS; it's usually known as the **right-hand side** (RHS).|
|`->`|The arrow means "can have the form"; for brevity it's sometimes pronounced "goes to".|
|`<assign> -> <var> = <expression>`| This whole definition is called a **rule** (or **production**). |

One example sentence whose syntactic structure is described by the rule is

```java
total = subtotal1 + subtotal2 
```

In a BNF description, or grammar:

* The abstractions are often called **nonterminal symbols**, and
* the lexemes and tokens of the rules are called **terminal symbols** (or simply
  **terminals**).

Overall, a BNF description, or **grammar**, is a collection of rules.

Nonterminal symbols can have two or more distinct definitions, representing two
or more possible syntactic forms in the language. For example, a Java `if`
statement can be described with the rules:

```bnf
<if_stmt> -> if ( <logic_expr> ) <stmt>
<if_stmt> -> if ( <logic_expr> ) <stmt> else <stmt>
```

Multiple definitions can be written as a single rule, with the different
definitions separated by the symbol `|`, meaning logical OR. Thus, the above
description is the same as

### Examples

#### A Simple Arithmetic Expression

The following CFG describes the structure of an arithmetic expression:

```bnf
<expr> -> <id> | <number> | - <expr> | ( <expr> ) | <expr> op <expr> 
<op>   -> + | - | * | /
```

Regular expressions work well for defining tokens, however they are unable to
specify nested constructs, which are central to programming languages. On the
contrary, the ability of CFGs to define a construct in terms of itself is
crucial. A rule is **recursive** if its LHS appears in its RHS; thus `<expr>` is
a recursive rule.

#### Describing Lists

Variable-length lists in mathematics are often written using an ellipsis (`...`); `1, 2, . . .` is an example. They can be defined recursively and thus a CFG can
describe them in the following manner:

```
<id_list> -> id | id, <id_list> 
```

This defines `<id_list>` as either a single token (`id`) or an identifier
followed by a comma and another instance `<id_list>`. 

### Derivations

A context-free grammar (CFG) shows us how to generate a syntactically valid
string of terminals:
> Begin with the start symbol. Choose a production with the start symbol on the
> left-hand side; replace the start symbol with the right-hand side of that
> production. Now choose a nonterminal A in the resulting string, choose a pro-
> duction P with A on its left-hand side, and replace A with the right-hand side
> of P. Repeat this process until no nonterminals remain.

As an example, we can use the grammar for arithmetic expression to generate the
string `slope * x + intercept`:

```
<expr> => <expr> <op> <expr>
	   => <id> <op> <expr>
	   => slope <op> <expr>
	   => slope * <expr>
	   => slope * <expr> + <expr>
	   => slope * <id> + <expr>
	   => slope * x + <expr>
	   => slope * x + <id>
	   => slope * x + intercept
```

The `=>` metasymbol is often pronounced “derives.” It indicates that the
right-hand side was obtained by using a production to replace some nonterminal
in the left-hand side. 

* A **derivation** is a series of replacement operations that shows how to
  derive a string of terminals from the start symbol. 
* Each string of symbols along the way is called a **sentential form**. 
* The **final sentential form**, consisting of only terminals, is called the
  **yield** of the derivation. 
* We sometimes elide the intermediate steps and write `expr =>* slope * x +
  intercept `, where the metasymbol `=>*` means “derives after zero or more
  replacements.” 

Different replacement strategies leads to different derivations:

* **Leftmost derivation.** In this type of derivation, at each step of the
  derivation   the left-most nonterminal with the left-hand side of some
  production. This is the strategy used to generate the string `slope * x +
  intercept` in the example above.

* **Rightmost derivation.** In this type of derivation, at each step of the
  derivation   the right-most nonterminal with the right-hand side of some
  production.

* **Others.** There are many other possible derivations, which includes options
  between a leftmost and rightmost derivation. .

The rightmost derivation to  generate the string `slope * x + intercept` is as
follows:

```
<expr> => <expr> <op> <expr>
	   => <expr> <op> <id>
	   => <expr> <op> intercept
	   => <expr> + intercept
	   => <expr> * <expr> + intercept
	   => <expr> * <id> + intercept
	   => <expr> * x + intercept
	   => <id> * x + intercept
	   => slope * x + intercept
```

There are two things to notice here:
* Different derivations result in quite different sentential forms, but
* For a context-free grammar, it really doesn't make much difference in what
  order we expand the variables.

### Parse Trees and Ambiguity

A **parse tree** is a hierarchical syntactic entity which represents the
structure of the derivation of a terminal string from some non-terminal (not
necessarily the start symbol). The root of the parse tree is the start symbol of
the grammar. The leaves of the tree are its yield. Each internal node, together
with its children, represents the use of a production.

A parse tree for the arithmetic expression grammar is shown down below:

![arithmetic-expression-ambiguous-grammar-example01.png](../images/arithmetic-expression-ambiguous-grammar-example01.png)


This tree is not unique. At the second level of the tree, we could have chosen
to turn the operator into a `+` instead of a `*`, and to further expand the
expression on the left, rather than the one on the right as shown in the figure
below:

![arithmetic-expression-ambiguous-grammar-example02.png](../images/arithmetic-expression-ambiguous-grammar-example02.png)

A grammar that allows the construction of more than one parse tree for some
string of terminals is said to be an **ambiguous grammar**. Ambiguity turns out
to be a problem when trying to build a parser: it requires some extra mechanism
to drive a choice between equally acceptable alternatives. 

When designing the grammar for a programming language, we generally try to find
one that reflects the internal structure of programs in a way that is useful to
the rest of the compiler.  One place in which structure is particularly
important is in arithmetic expressions, where we can use productions to capture
the  **precedence** and **associativity** of the various operators.


### Operator Precedence

Precedence tells us that multiplication and division in most languages group
more tightly than addition and subtraction, so that 3 + 4 * 5 means 3 + (4 * 5)
rather than (3 + 4) * 5 . (Note that these rules are not universal). Thus, if *
has been assigned **higher precedence** than + (by the language designer),
multiplication will be done first, regardless of the order of appearance of the
two operators in the expression.

The fact that an operator in an arithmetic expression is generated lower in the
parse tree (and therefore must be evaluated first) can be used to indicate that
it has precedence over an operator produced higher up in the tree. 

In one of the parse tree for `slope * x + intercept`, the multiplication
operator is generated lower in the tree, which could indicate that it has
precedence over the addition operator in the expression. Its other parse tree,
however, indicates just the opposite. It appears, therefore, that the two
parse trees indicate conflicting precedence information. 

In order to indicate the right operator precedence (and by "right" we mean the
language designer's type of "right"), we must fix the grammar for arithmetic
expressions. The correct ordering is specified by using separate nonterminal
symbols to represent the operands of the operators that have different
precedence. This requires additional nonterminals and some new rules:

* Instead of using `<expr>` for both operands of both `+` (and `-`) and `*` (and
  `/`), we could use several new nonterminals to represent operands, which
  allows the grammar to force different operators to different levels in the
  parse tree.

* If `<expr>` is the root symbol for expressions, `+` can be forced to the top
  of the parse tree by having `<expr>` directly generate only `+` and/or `-` operators,
  using the new nonterminal, `<term>`, as the right operand of `+` (or `-`).
  Let's create the nonterminal `<add_op>` that yields the terminals `+` or `-`.

* Next, we can define `<term>` to generate `*` and/or `/` operators, using
  `<term>` as the left operand and a new nonterminal, `<factor>`, as its right
  operand. Now, `*` will always be lower in the parse tree, simply because it is
  farther from the start symbol than `+` and/or `-` in every derivation. 
  Let's create the nonterminal `<mult_op>` that yields the terminals `*` or `/`.

The revised grammar for arithmetic expressions is as follows:

```bnf
<expr>    -> <term> | <expr> <add_op> <term>
<term>    -> <factor> | <term> <mult_op> <factor>
<factor>  -> <id> | <number> | - <factor> | ( <expr> )
<add_op>  -> + | -
<mult_op> -> * | /
```

This new grammar generates the same language as the previous one, but it is
unambiguous and it specifies the usual precedence order of multiplication and
addition operators. The leftmost and rightmost derivations for `slope * x +
intercept` are the following respectively:

**Leftmost derivation:**

```bnf
<expr> => <expr> <add_op> <term>
	   => <term> <add_op> <term>
	   => <term> <mult_op> <factor> <add_op> <term>
	   => <factor> <mult_op> <factor> <add_op> <term>
	   => <id> <mult_op> <factor> <add_op> <term>
	   => slope <mult_op> <factor> <add_op> <term>
	   => slope * <factor> <add_op> <term>
	   => slope * <id> <add_op> <term>
	   => slope * x <add_op> <term>
	   => slope * x + <term>
	   => slope * x + <factor>
	   => slope * x + <id>
	   => slope * x + intercept
```

* **Rightmost derivation**

```bnf
<expr> => <expr> <add_op> <term>
	   => <expr> <add_op> <factor>
	   => <expr> <add_op> <id>
	   => <expr> <add_op> intercept
	   => <expr> + intercept
	   => <term> + intercept
	   => <term> <mult_op> <factor> + intercept
	   => <term> <mult_op> <id> + intercept
	   => <term> <mult_op> x + intercept
	   => <term> * x + intercept
	   => <factor> * x + intercept
	   => <id> * x + intercept
	   => slope * x + intercept
```

The unique parse tree for this string using the unambiguous grammar is shown
down below:

![arithmetic-expression-unambiguous-grammar-example03.png](../images/arithmetic-expression-unambiguous-grammar-example03.png)

The connection between parse trees and derivations is very close: Either can
easily be constructed from the other. Every derivation with an unambiguous
grammar has a unique parse tree, although that tree can be represented by
different derivations.

### Associativity

Associativity tells us that the operators in most languages group left to right,
so that `12 / 2 * 3` means `(12 / 2) * 3` rather than `12 / (2 * 3)`. When an
expression includes two operators that have the same precedence (as `*` and `/`
usually have), **associativity** is the semantic rule that specifies which should
have precedence. An expression with two occurrences of the same operator has the
same issue; for example `12 / 2 / 3`, i.e., `(12 / 2) / 3` vs. `12 / (2 / 3)`.

Consider the parse tree for the arithmetic expression `x + y + z`:

![arithmetic-expression-unambiguous-grammar-associativity-example04.png](../images/arithmetic-expression-unambiguous-grammar-associativity-example04.png)

The parse tree shows the left addition operator lower than the right addition
operator. This is the correct order if addition is meant to be *left associative*,
which is typical. In most cases, the associativity of addition in a computer is
irrelevant. In mathematics, addition is associative, which means that left and
right associative orders of evaluation mean the same thing, i.e., 
`(x + y) + z = x + (y + z)`. Floating-point addition in a computer, however, is
not necessarily associative. Subtraction and division are not associative,
whether in mathematics or in a computer. Therefore, correct associativity may be
essential for an expression that contains either of them.

* **Left associativity.** When a grammar rule has its LHS also appearing at the
  beginning of its RHS, the rule is said to be left recursive; this left
  recursion specifies left associativity.

  For the updated grammar for arithmetic expressions, the left recursion of the
  rules of the grammar causes it to make both addition and multiplication left
  associative:

  ```bnf
  <expr> -> <expr> <add_op> <term> | ...
  <term> -> <term> <mult_op> <factor> | ...
  ```

  Unfortunately, left recursion disallows the use of some important syntax
  analysis algorithms. When one of these algorithms is to be used, the grammar
  must be modified to remove the left recursion. However, disallowing the
  grammar from precisely specifying that certain operators are left associative.
  Fortunately, left associativity can be enforced by the compiler, even though
  the grammar does not dictate it.

* **Right associativity.** When a grammar rule has its LHS also appearing at the
  right end of its RHS, the rule is said to be right recursive; this right
  recursion specifies right associativity.

  In most languages that provide it, the exponentiation operator is right
  associative, e.g., `2 ** 3 ** 2` means `2 ** (3 ** 2)` rather than `(2 ** 3)
  ** 2`. A rule such as the following could be used to describe
  exponentiation:

  ```bnf
  <factor> -> <expr> ** <factor> | <exp>
  <expr> -> ( <expr> ) | <id>
  ```

### Extended BNF (EBNF)

Due to a few minor inconveniences in BNF, it has been extended in several ways.
Most extended versions are called Extended BNF, or simply EBNF, even though they
are not all exactly the same. The extensions do not enhance the descriptive
power of BNF; they only increase its readability and writability. Three common
extensions included in the various versions of EBNF are:

* First extension denotes an optional part of an RHS, which is delimited by
  brackets.

  For example, a C if-else statement can be described as

```bnf
<if_stmt> -> if ( <expr> ) <stmt> [else <stmt>]
```

  which without the use of the brackets, the syntactic description of this
  statement would require the following two rules:

```bnf
<if_stmt> -> if ( <expr> ) <stmt>
          | if ( <expr> ) <stmt> else <stmt>
```

* Second extension uses braces (`{}`) in a RHS to indicate that the enclosed
  part can be repeated indefinitely or left out altogether. In other words, the
  enclosed part can be repeated part can have zero or more occurrences.

  For example, a list of identifiers separated by comma:

```bnf
<id_list> -> <id> {, <id>}
```

  Its BNF equivalent is:

```bnf
<id_list> -> <id> | <id>, <id_list>
```

* Third extension deals with multiple-choice options. When a single element must
  be chosen from a group, the options are placed in parentheses and separated by
  the OR operator, `|`. For example,

```bnf
<term> -> <term> (* | / | %) <factor>
```

  requires the following rules in BNF:

```bnf
<term> -> <term> * <factor>
        | <term> / <factor>
        | <term> % <factor>
```

The brackets, braces, and parentheses in the EBNF extensions are **metasymbols**,
which means they are notational tools and not terminal symbols in the syntactic
entities they help describe.

## Attribute Grammars

Context-free grammars (CFGs) allow us to specify the regular expressions that we
use to create words and other strings for our input string of characters and
they allow us to parse our programs, however they aren't always useful in
specifying the meaning of a statement or an expression. 

This is why **attribute grammars** are important; they give us a way to do this
in a notation that complements BNF and they allow us to specify the semantic
requirements of the language that we can use together with BNF.

An **attribute grammar** is an extension to a context-free grammar that's used
to describe features of a programming language that cannot be described in BNF
or can only be described in BNF with great difficulty. Examples:

* Describing the rules that float variables can be assigned integer values but
  the reverse is not true is difficult to describe completely in BNF.

* The rule requiring that all variables must be declared before being used is
  impossible to describe in BNF.








