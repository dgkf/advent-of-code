nl ← '
'

# Before you can read from Stdin in BQN you must first invent the While
Stdin ← {𝕩
  x ← " "
  # from: https://github.com/mlochbaum/BQN/blob/master/doc/control.md#while
  While ← {𝕩{𝔽⍟𝔾∘𝔽_𝕣_𝔾∘𝔽⍟𝔾𝕩}𝕨@}´
  While {𝕤⋄(-1)⊑x≠0}‿{𝕤⋄x ∾↩ •term.CharN 0}
  1↓(-1)↓x
}

SplitLines ← { nl((⊢-˜¬×+`)∘=⊔⊢)𝕏1 }
SplitNums  ← { '0'((⊢-˜¬×+`)∘>⊔⊢)𝕏1 }
ParseNum   ← 10⊸×⊸+˜´∘⌽-⟜'0'
Parse      ← (∘‿4) ⥊ (ParseNum¨ ∘ ∾SplitNums¨)

elves ← Parse Stdin 0

# I'm sure there is a way to make this frighteningly terse, but I haven't figured it out
•Show+´((((0⊏⍉)≥(2⊏⍉))∧((3⊏⍉)≥(1⊏⍉)))∨(((0⊏⍉)≤(2⊏⍉))∧((3⊏⍉)≤(1⊏⍉)))) elves
•Show+´((((1⊏⍉)≥(2⊏⍉))∧((3⊏⍉)≥(0⊏⍉)))∨(((1⊏⍉)≤(2⊏⍉))∧((3⊏⍉)≤(0⊏⍉)))) elves

# Almost there ... 
# •Show +´⥊ >1↓⚇1 1↓∧`⍉⟨≥,≤⟩{𝕎`𝕩}⌜(2/↕2)⊔(0‿2‿3‿1⊏⊢) ⍉elves
# •Show +´⥊ >1↓⚇1 1↓∧`⍉⟨≥,≤⟩{𝕎`𝕩}⌜(2/↕2)⊔(1‿2‿3‿0⊏⊢) ⍉elves
