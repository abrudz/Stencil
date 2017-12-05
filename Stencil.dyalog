 res←{opts}(code Stencil specs)input;Try;Rank;rank;No;If;Axes;axes;Of;EMASK;VMASK;NMASK;SMASK;Template;Injected;Code;Post;Pre;Ⓔ;Pad;Cycle;Block;Twist;Ü;P;C;T;M;K;R;I;STATES;Collect;Expand;repeat;Repeat;World;Do;Add0s;Rem0s;⎕IO;DIM;FORE;AFT;Min1
 ⎕IO←1 ⋄ ⎕ML←1
 :If 900⌶⍬
     opts←⍬
 :EndIf

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
 DIM←1⌷specs
 axes←Axes DIM
 Of←{,⍺⍺/¨⍵}
 EMASK←⍲Of axes ⍝ moorE without self
 VMASK←∨Of axes ⍝ Von neumann with self
 NMASK←≠Of axes ⍝ von neumanN without self
 SMASK←∧Of axes ⍝ Self

 Template←{
     ⓇⒺⓈ←Ⓐ(Code Injected)Ⓦ;Count;M;m;E;e;V;v;N;n;S;s;P;p;code
     Count←⊢+.≠Ⓔ            ⍝ number of non-empties
     m←Count⊢M←,Ⓦ           ⍝ Moore with self
     e←Count⊢E←EMASK/M      ⍝ moorE without self
     v←Count⊢V←VMASK/M      ⍝ Von neumann with self
     n←Count⊢N←NMASK/M      ⍝ von neumanN without self
     s←Count⊢S←SMASK/M      ⍝ Self
     S←⊃S                   ⍝ scalarise
     p←Count⊢P←0≠Ⓐ          ⍝ Padded
     code←⎕NR'Code'
     :If 1=≢code
     Code←⍎⊃code
     :Else
     Code←⍎⎕FX ⎕NR'Code'
     :EndIf
     ⓇⒺⓈ←Ⓐ Code Ⓦ ⍝ call user code
 }
 ⎕FX ¯1↓1↓⎕NR'Template' ⍝ create "Injected" tradop

 Post←⊢ ⍝ no postprocessor
 Pre←⊢  ⍝ no preprocessor
 :If 3=⎕NC'code' ⍝ fn left operand → behave like ⌺
     Code←code
 :Else ⍝ text
     code←'''.*?''' '⎕\w+' '\pL'⎕R'&' '&' ' & '⊆code ⍝ put spaces around letters which are neither ⎕NAMES nor quoted
     :If 2≤≢code
         Post←⍎3⌽' ⍵}{0::⍵ ⋄ ',⊃code ⍝ create postprocessor
         code←1↓code
     :EndIf
     :If 2≤≢code
         Pre←⍎3⌽' ⍵}{0::⍵ ⋄ ',⊃⌽code ⍝ create preprocessor
         code←¯1↓code
     :EndIf
     ⎕FX'Code←{' '⎕IO←0',code,'}'    ⍝ create left operand
 :EndIf

⍝ "Polyfills":
 Ⓔ←⊃0⍴⊂
 Ü←{                    ⍝ Under (⍢)
     ⍵⍵⍣¯1 ⍺⍺ ⍵⍵ ⍵
 }

 FORE AFT←¯1 1×⌈¯1+⌈/DIM÷2   ⍝ max needed padding
 Min1←{     ⍝ ensure matrix is minimum 1-by-1
     No ⍵:⍵⍴⍨1⌈⍴⍵
     ⍵
 }
 Add0s←(⍉(FORE↑Ⓔ)⍪⊢⍪AFT↑Ⓔ)⍣2 Min1 ⍝ Add layers of prototype elements
 Rem0s←{⍉⌽⍵↓⍨+/∧\∧/⍵=Ⓔ ⍵}⍣4  ⍝ Remove layers of prototype elements
 Pad←{                       ⍝ pad with result of given function
     (AFT↓FORE↓∘⍺⍺(FORE↑⍵⍵)⍪⊢⍪AFT↑⍵⍵)Min1 ⍵
 }
 Cycle←Pad⊢             ⍝ ┌─→─┐
                        ⍝       pad top and bottom with self
                        ⍝ └─→─┘
 Block←Pad Ⓔ            ⍝ ┌───┐
                        ⍝       pad top and bottom with prototype
                        ⍝ └───┘ (manifold-with-boundary)
 Twist←Pad⌽             ⍝ ┌─←─┐
                        ⍝       pad top and bottom with reversed self
                        ⍝ └─→─┘
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
 I←{                    ⍝ ┌─→─┐ Infinite:
     Rem0s ⍺⍺ Add0s ⍵   ⍝ ⍋   ⍒  left and right  expand as needed
 }                      ⍝ └─←─┘  lower and upper expand as needed

 STATES←⊂{⎕←Post ⍵ ⋄ ⎕←⍬ ⋄ ⍵}If('≡'∊opts)⊢input
 Collect←{
     ⍺⍺⊃STATES,←⊂⍵
 }

 Expand←{                                ⍝ expand ⍣functions
     body←'≡'⎕R'⍺≡⍵:1 ⋄ ⎕←Post ⍺ ⋄ ⎕←⍬ ⋄ 0'⊢⍵
     body←'∊|≢'⎕R'STATES∊⍨⊂⍺'⊢body
     'Repeat←{'body'}'
 }
 repeat←'∊'If No opts~⎕A                 ⍝ how many times
 Repeat←⍎⎕FX∘Expand If(∨/'≡∊≢'∘∊)repeat

 World←⍎'P'If No opts∩⎕A

⍝ This is where the actual work happens:
 input←Pre input
 STATES←⊂input
 Do←Code Injected⌺specs World Collect⍣Repeat
 STATES←∪STATES,⊂Do input

⍝ Now we choose what to return:
 :If '≡'∊opts
     res←⍬⊤⍬           ⍝ silence if already printed
 :ElseIf '≢'∊opts
     res←Post≢STATES ⍝ count generations until stable or already found
 :ElseIf '∊'∊opts
     res←Post¨STATES   ⍝ list generations
 :Else
     res←Post⊃⌽STATES  ⍝ return final generation
 :EndIf
