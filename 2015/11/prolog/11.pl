% advent of code 2015, day 11
:- initialization main.
:- use_module(library(readutil)).
:- use_module(library(clpfd)).  % for bi-directional equality 

main :- 
  read_line_to_string(user_input, Input),
  passcode(Input, InputCode), 
  next_valid_passcode(InputCode, PartACode),
  password(PartACode, PartA),
  format("~n~s~n", PartA), 
  next_valid_passcode(PartACode, PartBCode),
  password(PartBCode, PartB),
  format("~s~n", PartB),
  halt.

rule_three_increasing([]) :- false.
rule_three_increasing([_|T]) :- rule_three_increasing(T).
rule_three_increasing([A,B,C|_]) :-
  B is A + 1,
  C is B + 1.

rule_no_ambiguous([]) :- true.
rule_no_ambiguous([H|T]) :-
  atom_codes("i", [Icode]), not(H #= Icode - 97),
  atom_codes("o", [Ocode]), not(H #= Ocode - 97),
  atom_codes("l", [Lcode]), not(H #= Lcode - 97),
  rule_no_ambiguous(T).

rule_n_doubles(X, N) :- rule_n_doubles(X, N, []).
rule_n_doubles(_, 0, _).
rule_n_doubles([A,B|T], N, Letters) :- 
  A is B, not(member(A, Letters)), Nm is N - 1, rule_n_doubles(T, Nm, [A|Letters]);
  rule_n_doubles([B|T], N, Letters).

is_valid(Pc) :- 
  rule_three_increasing(Pc), 
  rule_no_ambiguous(Pc), 
  rule_n_doubles(Pc, 2).

password(Pc, Pw) :- passcode(X, Pc), atom_codes(Pw, X).

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

