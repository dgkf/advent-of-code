% advent of code 2015, day 11
:- initialization main.
:- use_module(library(readutil)).
:- use_module(library(clpfd)).  % for bi-directional equality 

main :- 
  read_line_to_string(user_input, Input),
  passcode(Input, InputCode), 
  next_valid_passcode(InputCode, PartACode),
  passcode(PartAAscii, PartACode), atom_codes(PartA, PartAAscii),
  format("~n~s~n", PartA), 
  next_valid_passcode(PartACode, PartBCode),
  passcode(PartBAscii, PartBCode), atom_codes(PartB, PartBAscii),
  format("~s~n", PartB),
  halt.

rule_three_increasing([]) :- false.
rule_three_increasing([_|T]) :- rule_three_increasing(T).
rule_three_increasing([A,B,C|_]) :-
  B is A + 1,
  C is B + 1.

rule_no_ambiguous([]) :- true.
rule_no_ambiguous([H|T]) :-
  passcode("iol", Forbid), 
  not(member(H, Forbid)),
  rule_no_ambiguous(T).

rule_n_doubles(X, N) :- rule_n_doubles(X, N, []).
rule_n_doubles(_, 0, _).
rule_n_doubles([_,B|T], N, Letters) :- rule_n_doubles([B|T], N, Letters).
rule_n_doubles([A,B|T], N, Letters) :- 
  A is B, not(member(A, Letters)), Nm is N - 1, 
  rule_n_doubles(T, Nm, [A|Letters]).

is_valid(Pc) :- 
  rule_three_increasing(Pc), 
  rule_no_ambiguous(Pc), 
  rule_n_doubles(Pc, 2).

passcode(Pw, Pc) :- string(Pw), atom_codes(Pw, X), passcode(X, Pc).
passcode([H|T], [PcH|PcT]) :- PcH #= H - 97, passcode(T, PcT).
passcode([], []).

next_passcode([X], [Y]) :- Y is (X + 1) rem 26.
next_passcode([PcA,PcB|PcT], [A,B|T]) :-
  next_passcode([PcB|PcT], [B|T]),
  ((PcB is 25, B is 0) -> A is (PcA + 1) rem 26; A is PcA).

next_valid_passcode(Pc, Next) :- 
  next_passcode(Pc, Next), is_valid(Next).
next_valid_passcode(Pc, Next) :-
  next_passcode(Pc, X), !, next_valid_passcode(X, Next).

