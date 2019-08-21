turtles-own [chromosome  ;; a string of digits representing a candidate solution to the problem
             fitness     ;; the numerical value of the chromosomal strings
             ]

globals [best            ;; the numerical value of the chromosome  closer to the goal
         worst           ;; the numerical value of the chromosome more distant from the goal
         donor           ;; the agent having the best chromosome
         recipient       ;; an agent not having the best chromosome
         chromcopy       ;; the copy of the best chromosome
         a-split         ;; the position of one extreme of a chromosome's fragment
         b-split         ;; the position of the second extreme of a chromosome's fragment
         counter         ;; a counter usefull in different blocks
         ]



;;  ----------   SETUP PROCEDURES   -----------------------------------------------------------------------------
;;  -------------------------------------------------------------------------------------------------------------


to setup                 ;; reset parameters and create a number of agents given by the user
  clear-all
  set counter 0
  reset-ticks
  create-turtles turtles-number [
    set shape "circle 2"
    set size 1.8
    fd 7
    genotype/phenotype-construction
   ]
end


to genotype/phenotype-construction
  ;; the genotype (chromosome) and the corresponding fenotype (fitness) of the agent
  ;; is initially equal to the worst response to the problem; it is shown as a label
  set fitness 10 ^ (genes-number - 1)
  ;; the lowest fitness value is converted into a string:
  ;; it will be the initial chromosome structure
  set chromosome word fitness ""
  ;; chromosome is displayed as a label
  set label chromosome
end



;;  ----------   RUNTIME PROCEDURES   ---------------------------------------------------------------------------
;;  -------------------------------------------------------------------------------------------------------------

to search
  ;; worse and best fitness value are detected
  set worst min [fitness] of turtles
  set best max [fitness] of turtles
  ;; the problem is resolved when an agent gain the higher value of fitness having a
  ;; user-specified number of digits
  if best = 10 ^ genes-number - 1 [show "DONE!!!" stop]
  ;; when  diversity between chromosomes is null, genetic-shuffling is skipped
  if best != worst [genetic-shuffling]
  ;; mutations occur according to a frequency set by the user
  if random-float 1 < mutation-rate [mutate]
  tick
end


to genetic-shuffling
  ;; hybridization occurs between the chromosome of a randomly chosen turtle (recipient)
  ;; and the chromosome of the most performing one (donor) that offer a fragment of its
  ;; chromosome to the first turtle; the two involved agents are highlighted by a link
  clear-links
  set donor [who] of one-of turtles with [fitness = best]
  set recipient [who] of one-of turtles with [fitness != best]
  ask turtle donor [create-link-to turtle recipient ]
  set counter 0
  set a-split random genes-number
  set b-split random genes-number
  set chromcopy [chromosome] of turtle donor
  ask turtle recipient [
     hybridization
     set fitness read-from-string chromosome
     set label fitness
    ]
end


to hybridization
  ;; the two selected chromosomal strings give place to hybridization with a mechanism inspired both
  ;; to crossing-over and bacterial conjugation: the recipient string will be hybridized with a fragment
  ;; of the donor one; strings are treated as circular, as occur in bacterial chromosomes or plasmids
  ifelse a-split < b-split [set chromosome
            replace-item (a-split + counter) chromosome (item (a-split + counter) chromcopy)
            set counter (counter + 1)
            if counter < b-split - a-split [hybridization]]
       [if b-split < a-split [set chromosome
              replace-item ((a-split + counter) mod genes-number)
                  chromosome (item ((a-split + counter) mod genes-number) chromcopy)
              set counter (counter + 1)
              if counter < genes-number - a-split + b-split [hybridization]]
    ]
end


to mutate
  ;; mutations happen randomly with a given frequency on just one digit place
  ask turtle random turtles-number
       [set chromosome replace-item random genes-number chromosome word random 10 ""
        set fitness read-from-string chromosome
        set label fitness
       ]
end
@#$#@#$#@
GRAPHICS-WINDOW
175
20
561
407
-1
-1
18.0
1
12
1
1
1
0
0
0
1
-10
10
-10
10
0
0
1
ticks
30.0

BUTTON
580
145
695
178
NIL
setup
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
580
190
695
223
search indefinitely
search
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

MONITOR
580
350
830
399
hybridized chromosome
[chromosome] of turtle recipient
0
1
12

MONITOR
580
300
655
345
a-split
a-split
0
1
11

MONITOR
665
300
740
345
b-split
b-split
0
1
11

MONITOR
755
300
830
345
replacements
counter
0
1
11

SLIDER
580
20
830
53
turtles-number
turtles-number
0
100
10.0
1
1
NIL
HORIZONTAL

SLIDER
580
60
830
93
genes-number
genes-number
1
15
7.0
1
1
NIL
HORIZONTAL

BUTTON
710
145
830
178
search once
search
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

MONITOR
710
240
832
289
best chromosome
best
0
1
12

MONITOR
580
240
695
289
worst chrom.
worst
0
1
12

PLOT
40
420
830
700
performances
NIL
NIL
0.0
10.0
0.0
100.0
true
true
"" ""
PENS
"best" 1.0 0 -14070903 true "" "plot best"
"worst" 1.0 0 -2139308 true "" "plot worst"

SLIDER
580
100
830
133
mutation-rate
mutation-rate
0
1
0.4
0.01
1
NIL
HORIZONTAL

TEXTBOX
715
195
835
251
The largest number having as digits as the set genes number is:
11
102.0
1

TEXTBOX
710
180
835
198
____________________
11
102.0
1

TEXTBOX
710
275
840
293
____________________
11
101.0
1

TEXTBOX
40
10
160
411
_________________\n\nThe goal of this model is using the genetic algorithms approach to search the largest number having the same digits as the set genes number along chromosomes.\n\nInterestingly, computational problems can be solved through the \"chance and necessity\" interplay recognized in natural evolution.
13
0.0
1

@#$#@#$#@
## WHAT IS IT?

Genetic algorithms try to solve a computational problem following some principles of organic evolution. This model has didactic purposes; it can give us an answer to the simple arithmetic problem on how to find the highest number composed by a given number of digits. We approach the task using a genetic algorithm, where the candidate answers to solve the problem are represented by agents that in logo programming environment are usually named "turtles"


## HOW IT WORKS

Every turtle owns a “chromosome” made up by a string of digits each one representing a "gene"; chromosomes can mutate on a single gene and can exchange fragments (sequence of genes) with the chromosome carried by other turtles: we can see the mechanism as a mixture of eukaryotic crossing-over and prokaryotic conjugation, here we will refer to it as a genetic-shuffling. The total sequence of genes in a chromosome can be read as a number and its value can be considered the turtles “phenotype” as well as a candidate solution to the problem. A turtle will be as fit as the value expressed by its chromosome will be high. The best theoretical fitness can be easily mathematically established as the nearest to the result of a simple formula. If n is the number of digits in a string, the higher number having n digits is: 
(10 ^ n) - 1, that is a sequence of n 9s; on the contrary 10 ^ (n - 1) will give the lower number composed by n digits; in other words, the two formulas give us the  extremes of search space.
Only the fittest turtle can conjugate with another turtle giving part of its chromosome. So the best answer is searched fundamentally in two steps: mutation and selective reproduction of (part of) the fittest chromosome by genetic-shuffling. 
Mutations happen randomly with a given frequency on just one gene that is a digit place on the chromosome. 
Genetic-shuffling takes place between a randomly chosen turtle (recipient) and the most performing one (donor) that offers a fragment of its chromosome to the first one; the two turtles involved in this process will be highlighted by a link. Genetic-shuffling leads to the formation of a new hybrid chromosome made up by the chromosome of the recipient turtle in which a fragment of genes (digits) included between two randomly chosen positions are replaced by the corresponding genes (digits) of one of the donor turtle's chromosome. 


## HOW TO USE IT

SETUP button creates the selected number of turtles having a chromosome constituted by a string long till 20 genes (digits), as chosen by the user. Initially, all chromosomes show the lowest suitability. 
SEARCH buttons launch a block of instructions that after the detection of the current best and worst chromosomes, recall the genetic-shuffling and mutation operators. 
Four displays show some data concerning the last processed genetic-shuffling: the starting point (a-split) and the ending point (b-split) of the donor's fragment insertion (the first extreme is included into the fragment but not the second one) and the number of genes replaced; the resulting hybridized chromosome is reported, as well.
Step by step the less and the most suitable phenotypes (the numerical value of the chromosomal string) are monitored. 


## THINGS TO NOTICE

1. During genetic-shuffling, the replaced chromosomal fragment can have random length, so sometimes it can have a null extension or it could cover the entire chromosome but a gene (the fragment's final digit).
2. Because of the strict correspondence between genotype and phenotype, this model doesn't require the computation of a fitness function: such value is enclosed in the same chromosome. 
3. In sciences, mathematical language is largely used to describe natural systems and to compute their future evolution. In this case, the language of natural sciences is utilized to compute the solution of an arithmetic problem.


## THINGS TO TRY

Search a possible statistical relationship between the number of cycles required to obtain the right answer to the problem and the single parameters adjustable by sliders. Particularly interesting could be the relationship between mutation rate and the average of cycles' number required to reach the right answer to the problem. 
Another approach could be checking if it is more determinant the influence of the random mutations or the selective genetic shuffling or a balanced ratio between the two factors to obtain efficiently the final goal: this feature would require a variation in the code.


## EXTENDING THE MODEL

Minimal Genetic Algorithm can be furtherly extended by adding new routines and plots: e.g. it would be interesting to introduce a block evaluating the genotypes diversity dynamic during the search process.


## NETLOGO FEATURES

In this model, chromosomes have two features: as a string and as a number. To switch them each other, two NetLogo commands are very useful: "read-from-string" interprets the given chromosome and reports the resulting numerical value; on the contrary "word" command allows to revert a number into a string (because it requires two inputs, the second one could be double quotation marks: "")
A third command is useful in mutation and genetic shuffling operators: "replace-item" allows an easy single gene variation as well as a substitution with a chromosome fragment from a donor turtle into the corresponding loci of a recipient turtle. 



## RELATED MODELS

- Stonedahl, F. and Wilensky, U. (2008). NetLogo Simple Genetic Algorithm model. http://ccl.northwestern.edu/netlogo/models/SimpleGeneticAlgorithm. Center for Connected Learning and Computer-Based Modeling, Northwestern Institute on Complex Systems, Northwestern University, Evanston, IL.



## CREDITS AND REFERENCES 

A nice introduction to genetic algorithms could be the chapter nine of the book "Complexity - A guided tour" by Melanie Mitchel (2009 - Oxford University Press) where the GA "Robby the Robot" is described; see also Mitchell, M., Tisue, S. and Wilensky, U. (2012). NetLogo Robby the Robot model http://ccl.northwestern.edu/netlogo/models/RobbytheRobot. Center for Connected Learning and Computer-Based Modeling, Northwestern University, Evanston, IL.


## COPYRIGHT AND LICENSE

Copyright 2018 Cosimo Leuci.

This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License. To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/4.0/ or send a letter to Creative Commons, 559 Nathan Abbott Way, Stanford, California 94305, USA.
@#$#@#$#@
default
true
0
Polygon -7500403 true true 150 5 40 250 150 205 260 250

airplane
true
0
Polygon -7500403 true true 150 0 135 15 120 60 120 105 15 165 15 195 120 180 135 240 105 270 120 285 150 270 180 285 210 270 165 240 180 180 285 195 285 165 180 105 180 60 165 15

arrow
true
0
Polygon -7500403 true true 150 0 0 150 105 150 105 293 195 293 195 150 300 150

box
false
0
Polygon -7500403 true true 150 285 285 225 285 75 150 135
Polygon -7500403 true true 150 135 15 75 150 15 285 75
Polygon -7500403 true true 15 75 15 225 150 285 150 135
Line -16777216 false 150 285 150 135
Line -16777216 false 150 135 15 75
Line -16777216 false 150 135 285 75

bug
true
0
Circle -7500403 true true 96 182 108
Circle -7500403 true true 110 127 80
Circle -7500403 true true 110 75 80
Line -7500403 true 150 100 80 30
Line -7500403 true 150 100 220 30

butterfly
true
0
Polygon -7500403 true true 150 165 209 199 225 225 225 255 195 270 165 255 150 240
Polygon -7500403 true true 150 165 89 198 75 225 75 255 105 270 135 255 150 240
Polygon -7500403 true true 139 148 100 105 55 90 25 90 10 105 10 135 25 180 40 195 85 194 139 163
Polygon -7500403 true true 162 150 200 105 245 90 275 90 290 105 290 135 275 180 260 195 215 195 162 165
Polygon -16777216 true false 150 255 135 225 120 150 135 120 150 105 165 120 180 150 165 225
Circle -16777216 true false 135 90 30
Line -16777216 false 150 105 195 60
Line -16777216 false 150 105 105 60

car
false
0
Polygon -7500403 true true 300 180 279 164 261 144 240 135 226 132 213 106 203 84 185 63 159 50 135 50 75 60 0 150 0 165 0 225 300 225 300 180
Circle -16777216 true false 180 180 90
Circle -16777216 true false 30 180 90
Polygon -16777216 true false 162 80 132 78 134 135 209 135 194 105 189 96 180 89
Circle -7500403 true true 47 195 58
Circle -7500403 true true 195 195 58

circle
false
0
Circle -7500403 true true 0 0 300

circle 2
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240

cow
false
0
Polygon -7500403 true true 200 193 197 249 179 249 177 196 166 187 140 189 93 191 78 179 72 211 49 209 48 181 37 149 25 120 25 89 45 72 103 84 179 75 198 76 252 64 272 81 293 103 285 121 255 121 242 118 224 167
Polygon -7500403 true true 73 210 86 251 62 249 48 208
Polygon -7500403 true true 25 114 16 195 9 204 23 213 25 200 39 123

cylinder
false
0
Circle -7500403 true true 0 0 300

dot
false
0
Circle -7500403 true true 90 90 120

face happy
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 255 90 239 62 213 47 191 67 179 90 203 109 218 150 225 192 218 210 203 227 181 251 194 236 217 212 240

face neutral
false
0
Circle -7500403 true true 8 7 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Rectangle -16777216 true false 60 195 240 225

face sad
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 168 90 184 62 210 47 232 67 244 90 220 109 205 150 198 192 205 210 220 227 242 251 229 236 206 212 183

fish
false
0
Polygon -1 true false 44 131 21 87 15 86 0 120 15 150 0 180 13 214 20 212 45 166
Polygon -1 true false 135 195 119 235 95 218 76 210 46 204 60 165
Polygon -1 true false 75 45 83 77 71 103 86 114 166 78 135 60
Polygon -7500403 true true 30 136 151 77 226 81 280 119 292 146 292 160 287 170 270 195 195 210 151 212 30 166
Circle -16777216 true false 215 106 30

flag
false
0
Rectangle -7500403 true true 60 15 75 300
Polygon -7500403 true true 90 150 270 90 90 30
Line -7500403 true 75 135 90 135
Line -7500403 true 75 45 90 45

flower
false
0
Polygon -10899396 true false 135 120 165 165 180 210 180 240 150 300 165 300 195 240 195 195 165 135
Circle -7500403 true true 85 132 38
Circle -7500403 true true 130 147 38
Circle -7500403 true true 192 85 38
Circle -7500403 true true 85 40 38
Circle -7500403 true true 177 40 38
Circle -7500403 true true 177 132 38
Circle -7500403 true true 70 85 38
Circle -7500403 true true 130 25 38
Circle -7500403 true true 96 51 108
Circle -16777216 true false 113 68 74
Polygon -10899396 true false 189 233 219 188 249 173 279 188 234 218
Polygon -10899396 true false 180 255 150 210 105 210 75 240 135 240

house
false
0
Rectangle -7500403 true true 45 120 255 285
Rectangle -16777216 true false 120 210 180 285
Polygon -7500403 true true 15 120 150 15 285 120
Line -16777216 false 30 120 270 120

leaf
false
0
Polygon -7500403 true true 150 210 135 195 120 210 60 210 30 195 60 180 60 165 15 135 30 120 15 105 40 104 45 90 60 90 90 105 105 120 120 120 105 60 120 60 135 30 150 15 165 30 180 60 195 60 180 120 195 120 210 105 240 90 255 90 263 104 285 105 270 120 285 135 240 165 240 180 270 195 240 210 180 210 165 195
Polygon -7500403 true true 135 195 135 240 120 255 105 255 105 285 135 285 165 240 165 195

line
true
0
Line -7500403 true 150 0 150 300

line half
true
0
Line -7500403 true 150 0 150 150

pentagon
false
0
Polygon -7500403 true true 150 15 15 120 60 285 240 285 285 120

person
false
0
Circle -7500403 true true 110 5 80
Polygon -7500403 true true 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Rectangle -7500403 true true 127 79 172 94
Polygon -7500403 true true 195 90 240 150 225 180 165 105
Polygon -7500403 true true 105 90 60 150 75 180 135 105

plant
false
0
Rectangle -7500403 true true 135 90 165 300
Polygon -7500403 true true 135 255 90 210 45 195 75 255 135 285
Polygon -7500403 true true 165 255 210 210 255 195 225 255 165 285
Polygon -7500403 true true 135 180 90 135 45 120 75 180 135 210
Polygon -7500403 true true 165 180 165 210 225 180 255 120 210 135
Polygon -7500403 true true 135 105 90 60 45 45 75 105 135 135
Polygon -7500403 true true 165 105 165 135 225 105 255 45 210 60
Polygon -7500403 true true 135 90 120 45 150 15 180 45 165 90

sheep
false
15
Circle -1 true true 203 65 88
Circle -1 true true 70 65 162
Circle -1 true true 150 105 120
Polygon -7500403 true false 218 120 240 165 255 165 278 120
Circle -7500403 true false 214 72 67
Rectangle -1 true true 164 223 179 298
Polygon -1 true true 45 285 30 285 30 240 15 195 45 210
Circle -1 true true 3 83 150
Rectangle -1 true true 65 221 80 296
Polygon -1 true true 195 285 210 285 210 240 240 210 195 210
Polygon -7500403 true false 276 85 285 105 302 99 294 83
Polygon -7500403 true false 219 85 210 105 193 99 201 83

square
false
0
Rectangle -7500403 true true 30 30 270 270

square 2
false
0
Rectangle -7500403 true true 30 30 270 270
Rectangle -16777216 true false 60 60 240 240

star
false
0
Polygon -7500403 true true 151 1 185 108 298 108 207 175 242 282 151 216 59 282 94 175 3 108 116 108

target
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240
Circle -7500403 true true 60 60 180
Circle -16777216 true false 90 90 120
Circle -7500403 true true 120 120 60

tree
false
0
Circle -7500403 true true 118 3 94
Rectangle -6459832 true false 120 195 180 300
Circle -7500403 true true 65 21 108
Circle -7500403 true true 116 41 127
Circle -7500403 true true 45 90 120
Circle -7500403 true true 104 74 152

triangle
false
0
Polygon -7500403 true true 150 30 15 255 285 255

triangle 2
false
0
Polygon -7500403 true true 150 30 15 255 285 255
Polygon -16777216 true false 151 99 225 223 75 224

truck
false
0
Rectangle -7500403 true true 4 45 195 187
Polygon -7500403 true true 296 193 296 150 259 134 244 104 208 104 207 194
Rectangle -1 true false 195 60 195 105
Polygon -16777216 true false 238 112 252 141 219 141 218 112
Circle -16777216 true false 234 174 42
Rectangle -7500403 true true 181 185 214 194
Circle -16777216 true false 144 174 42
Circle -16777216 true false 24 174 42
Circle -7500403 false true 24 174 42
Circle -7500403 false true 144 174 42
Circle -7500403 false true 234 174 42

turtle
true
0
Polygon -10899396 true false 215 204 240 233 246 254 228 266 215 252 193 210
Polygon -10899396 true false 195 90 225 75 245 75 260 89 269 108 261 124 240 105 225 105 210 105
Polygon -10899396 true false 105 90 75 75 55 75 40 89 31 108 39 124 60 105 75 105 90 105
Polygon -10899396 true false 132 85 134 64 107 51 108 17 150 2 192 18 192 52 169 65 172 87
Polygon -10899396 true false 85 204 60 233 54 254 72 266 85 252 107 210
Polygon -7500403 true true 119 75 179 75 209 101 224 135 220 225 175 261 128 261 81 224 74 135 88 99

wheel
false
0
Circle -7500403 true true 3 3 294
Circle -16777216 true false 30 30 240
Line -7500403 true 150 285 150 15
Line -7500403 true 15 150 285 150
Circle -7500403 true true 120 120 60
Line -7500403 true 216 40 79 269
Line -7500403 true 40 84 269 221
Line -7500403 true 40 216 269 79
Line -7500403 true 84 40 221 269

wolf
false
0
Polygon -16777216 true false 253 133 245 131 245 133
Polygon -7500403 true true 2 194 13 197 30 191 38 193 38 205 20 226 20 257 27 265 38 266 40 260 31 253 31 230 60 206 68 198 75 209 66 228 65 243 82 261 84 268 100 267 103 261 77 239 79 231 100 207 98 196 119 201 143 202 160 195 166 210 172 213 173 238 167 251 160 248 154 265 169 264 178 247 186 240 198 260 200 271 217 271 219 262 207 258 195 230 192 198 210 184 227 164 242 144 259 145 284 151 277 141 293 140 299 134 297 127 273 119 270 105
Polygon -7500403 true true -1 195 14 180 36 166 40 153 53 140 82 131 134 133 159 126 188 115 227 108 236 102 238 98 268 86 269 92 281 87 269 103 269 113

x
false
0
Polygon -7500403 true true 270 75 225 30 30 225 75 270
Polygon -7500403 true true 30 75 75 30 270 225 225 270
@#$#@#$#@
NetLogo 6.0.4
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
default
0.0
-0.2 0 0.0 1.0
0.0 1 1.0 0.0
0.2 0 0.0 1.0
link direction
true
0
Line -7500403 true 150 150 90 180
Line -7500403 true 150 150 210 180
@#$#@#$#@
1
@#$#@#$#@
