(* ::Package:: *)

(* numberth.m *)
(* Last updated August 8th 1995 *)

n = 2048;                                (* transform length *)
l = 2^256;                             (* computer's word length *)

inv[n_Integer] := PowerMod[n, -1, m]  (* inverse function *)

init[] :=                             (* init variables *)
Block[{},
  k = Floor[l/n]-1;
  While[PrimeQ[k*n+1] == False, k--];
  m= k*n+1;                           (* the prime modulo *)
  r=PrimitiveRoot[m];                 (* primitive root of m *)
  w=PowerMod[r, k, m];                (* root of order n, is r^((m-1)/n) *)
  w1=inv[w];                          (* inverse of w *)
  ];

initf[] :=                            (* init transform matrixes *)
Block[{},
  f=Table[PowerMod[w, i j, m], {i, 0, n-1}, {j, 0, n-1}];       (* transform *)
  f1=Table[PowerMod[w1, i j, m], {i, 0, n-1}, {j, 0, n-1}];     (* inverse *)
  f1 = Mod[inv[n] * f1, m];
  ];

carry[l_List] :=                      (* convert list to number *)
Block[{s = 0},
  For[k=Length[l], k > 0, k--, s=s*10+l[[k]]];
  Return[s]];

n2l[a_Integer] :=                     (* convert number to list *)
  Join[Reverse[IntegerDigits[a]], Table[0, {n-1-Floor[Log[10, a]]}]];

mulf[a_Integer, b_Integer] :=         (* multiply with slow algorithm *)
carry[Mod[f1.(Mod[f.n2l[a], m]*Mod[f.n2l[b], m]), m]];

mul[a_Integer, b_Integer] :=          (* multiply with fast algorithm *)
carry[ifnt[Mod[fnt[n2l[a]] * fnt[n2l[b]], m]]];

permute[a_Integer] :=                 (* bit reversal *)
Block[{t = 2 * n, o = 2 * a, p = 0},
  While[(t /= 2) > 1, p += p + Mod[(o = Floor[o / 2]), 2]];
  Return[p]];

scramble[l_List] :=                   (* bit reverse list order *)
Table[l[[permute[k]+1]], {k, 0, n-1}];

fnt[l_List] :=                        (* fast number theoretic transform *)
Block[{f = l, i1, i2, i3, i4, loop, loop1, loop2, a, b, y, z},
  y = w1;

  i1 = n / 2;
  i2 = 1;

  For[loop = i1, loop > 0, loop = Floor[loop / 2],
    Block[{},
      i3 = 0;
      i4 = i1;
      For[loop1 = 0, loop1 < i2, loop1++,
        Block[{},
          z = 1;
          For[loop2 = i3, loop2 < i4, loop2++,
            Block[{},
              a = f[[loop2 + 1]];
              b = f[[loop2 + i1+ 1]];
              f[[loop2 + 1]] = Mod[a + b, m];
              f[[loop2 + i1 + 1]] = Mod[z * (a - b), m];
              z = Mod[z * y, m]]];
          i3 += 2 * i1;
          i4 += 2 * i1]];
      y = Mod[y * y, m];
      i1 = Floor[i1 / 2];
      i2 *= 2]];
  Return[f]]

ifnt[l_List] :=                       (* inverse fnt *)
Block[{f = l, i, j, k, istep, mmax, wt, wr, wtemp},
  mmax = 1;
  While[n > mmax,
    Block[{},
      istep = 2 * mmax;
      wt = PowerMod[w, n / istep, m];
      wr = 1;
      For[k = 0, k < mmax, k++,
        Block[{},
          For[i = k, i < n, i += istep,
            Block[{},
              j = i + mmax;
              wtemp = Mod[wr * f[[j + 1]], m];
              f[[j + 1]] = Mod[f[[i + 1]] - wtemp, m];
              f[[i + 1]] = Mod[f[[i + 1]] + wtemp, m]]];
          wr = Mod[wr * wt, m]]];
      mmax = istep]];
  Return[Mod[inv[n] * f, m]]]

fntraw[l_List] := scramble[fnt[l]];                     (* for debug only *)
ifntraw[l_List] := Mod[ifnt[scramble[l]] n, m];         (* for debug only *)

(* end numberth.m *)
