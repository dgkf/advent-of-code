nl ← '
'

# Before you can read from Stdin in BQN you must first invent the While
Stdin ← {𝕩
  x ← " "
  While ← {𝕩{𝔽⍟𝔾∘𝔽_𝕣_𝔾∘𝔽⍟𝔾𝕩}𝕨@}´
  While {𝕤⋄(-1)⊑x≠0}‿{𝕤⋄x ∾↩ •term.CharN 0}
  1↓(-1)↓x
}

SplitLines ← { nl((⊢-˜¬×+`)∘=⊔⊢)𝕏1 }
SplitNums  ← { '0'((⊢-˜¬×+`)∘>⊔⊢)𝕏1 }
ParseNum   ← 10⊸×⊸+˜´∘⌽-⟜'0'
Parse      ← (∘‿4) ⥊ (ParseNum¨ ∘ ∾SplitNums¨ ∘ SplitLines)

elves ← Parse Stdin 0

# I am absolutely sure there is a far better way to do this, but it's late
•Show +´ (((((0 ⊏˘ elves) ≥ (2 ⊏˘ elves)) × ((1 ⊏˘ elves) ≤ (3 ⊏˘ elves))) + (((2 ⊏˘ elves) ≥ (0 ⊏˘ elves)) × ((3 ⊏˘ elves) ≤ (1 ⊏˘ elves)))) > 0)

•Show +´ (((((1 ⊏˘ elves) ≥ (2 ⊏˘ elves)) × ((3 ⊏˘ elves) ≥ (0 ⊏˘ elves))) + (((2 ⊏˘ elves) ≥ (1 ⊏˘ elves)) × ((0 ⊏˘ elves) ≥ (3 ⊏˘ elves)))) > 0)
