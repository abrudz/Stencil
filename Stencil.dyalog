Stencil←{
     ⍺←⍬
     opts code specs input←⍺ ⍺⍺ ⍵⍵ ⍵

     Try←{
         0::⍵
         ⍎⍵
     }
     specs input←Try¨specs input ⍝ evaluate if possible

     Rank←≢⍴
     rank←Rank input

     No←0∊⍴
     If←{
         ⍺←⊢
         ⍵⍵⊣⍵:⍺ ⍺⍺⊣⍵
         ⍵
     }
     specs←(rank⍴3)If No specs   ⍝ default to 3 3 …
     specs←⍉∘⍪If(1≥Rank)specs    ⍝ make matrix if not
     specs←2↑specs⍪1             ⍝ add step if missing
     specs←rank/If(2 1≡⍴)specs   ⍝ replicate to all dimensions if needed

     Axes←⍳=∘⊂∘⌈÷∘2 ⍝ middle coordinates
     #.AXES←Axes 1⌷specs
     Of←{,⍺⍺/¨⍵}
     #.EMASK←⍲Of #.AXES ⍝ moorE without self
     #.VMASK←∨Of #.AXES ⍝ Von neumann with self
     #.NMASK←≠Of #.AXES ⍝ von neumanN without self
     #.SMASK←∧Of #.AXES ⍝ Self

     Template←{
         Type←⊃0⍴⊂           ⍝ 0 for nums, space for chars
         Count←⊢+.≠Type      ⍝ number of non-empties
         m←Count⊢M←,⍵        ⍝ Moore with self
         e←Count⊢E←#.EMASK/M ⍝ moorE without self
         v←Count⊢V←#.VMASK/M ⍝ Von neumann with self
         n←Count⊢N←#.NMASK/M ⍝ von neumanN without self
         s←Count⊢S←#.SMASK/M ⍝ Self
         S←⊃S                ⍝ scalarise
         p←Count⊢P←0≠⍺       ⍝ Padded
         ⎕IO←0
     }

     code←'''.*?''' '⎕\w+' '\pL'⎕R'&' '&' ' & '⊆code ⍝ put spaces around letters which are neither ⎕NAMES nor quoted
     code,⍨←¯1↓⎕NR'Template'
     code,←'}'
     Code←⍎⎕FX code ⍝ create left operand

     Ⓔ←⊃0⍴⊂
     Pad←{                  ⍝ pad with result of given function
         (≢↑≢↓∘⍺⍺ ⍵⍵⍪⊢⍪⍵⍵)⍵
     }
     Cycle←Pad⊢             ⍝ ┌─→─┐
                            ⍝       pad top and bottom with self
                            ⍝ └─→─┘
     Block←Pad Ⓔ           ⍝ ┌───┐
                            ⍝       pad top and bottom with prototype
                            ⍝ └───┘ (manifold-with-boundary)
     Twist←Pad⌽             ⍝ ┌─←─┐
                            ⍝       pad top and bottom with reversed self
                            ⍝ └─→─┘
     Ü←{                    ⍝ Under (⍢)
         ⍵⍵⍣¯1 ⍺⍺ ⍵⍵ ⍵
     }
     P←{                    ⍝ ┌───┐ Plane:
         ⍺⍺ Block Ü⍉Block ⍵ ⍝ │   │  left and right  disconnected
     }                      ⍝ └───┘  lower and upper disconnected
     C←{                    ⍝ ┌───┐ Cylinder:
         ⍺⍺ Cycle Ü⍉Block ⍵ ⍝ ⍋   ⍋  left and right  joined
     }                      ⍝ └───┘  lower and upper disconnected
     T←{                    ⍝ ┌─→─┐ Torus:
         ⍺⍺ Cycle Ü⍉Cycle ⍵ ⍝ ⍋   ⍋  left and right  joined
     }                      ⍝ └─→─┘  lower and upper joined
     M←{                    ⍝ ┌─→─┐ Möbius strip:
         ⍺⍺ Block Ü⍉Twist ⍵ ⍝ │   │  left and right  disconnected
     }                      ⍝ └─←─┘  lower and upper twist-joined
     K←{                    ⍝ ┌─→─┐ Klein bottle:
         ⍺⍺ Cycle Ü⍉Twist ⍵ ⍝ ⍋   ⍋  left and right  joined
     }                      ⍝ └─←─┘  lower and upper twist-joined
     R←{                    ⍝ ┌─→─┐ Real projective plane:
         ⍺⍺ Twist Ü⍉Twist ⍵ ⍝ ⍋   ⍒  left and right  twist-joined
     }                      ⍝ └─←─┘  lower and upper twist-joined
     I←{
         Add0s←(⍉Ⓔ,⊢,Ⓔ)⍣2           ⍝ Add layers of prototype elements
         Rem0s←{⍉⌽⍵↓⍨+/∧\∧/⍵=Ⓔ ⍵}⍣4 ⍝ Remove layers of prototype elements
                            ⍝ ┌─→─┐ Infinite:
         Rem0s ⍺⍺ Add0s ⍵   ⍝ ⍋   ⍒  left and right  expand as needed
     }                      ⍝ └─←─┘  lower and upper expand as needed

     #.STATES←⊂{⍵⊣⎕←⍵⍪' '}If('≡'∊opts)⊢input
     Collect←{
         ⍺⍺⊃#.STATES,←⊂⍵
     }

     Expand←{                                ⍝ expand ⍣functions
         body←'≡'⎕R'⍺≡⍵:1 ⋄ ⎕←⍺⍪'' '' ⋄ 0'⊢⍵
         body←'∊|≢'⎕R'#.STATES∊⍨⊂⍺'⊢body
         'Repeat←{'body'}'
     }
     repeat←'∊'If No opts~⎕A                 ⍝ how many times
     Repeat←⍎⎕FX∘Expand If(∨/'≡∊≢'∘∊)repeat

     World←⍎'P'If No opts∩⎕A

⍝ This is where the actual work happens:
     #.STATES←⊂input
     Do←Code⌺specs World Collect⍣Repeat
     #.STATES←∪#.STATES,⊂Do input

     '≡'∊opts:⍬⊤⍬         ⍝ silence if already printed
     '≢'∊opts:≢1↓#.STATES ⍝ count generations until stable
     '∊'∊opts:#.STATES    ⍝ list generations
     ⊃⌽#.STATES           ⍝ return final generation
 }
