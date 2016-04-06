param n, integer;
param W, integer;
param w{i in 1..n};
param v{i in 1..n};

# promenne
var x{i in 1..n}, binary;

# kriteria
maximize total: sum{i in 1..n} v[i]*x[i];

# podminky
s.t. capacity: sum{i in 1..n} w[i]*x[i] <= W;

solve;

printf "packed value: %d\n", total;
printf "capacity filled: %d\n", capacity;
printf {i in 1..n: x[i]} "packed %d with value %d and weight %d\n", i, v[i], w[i];

data;

param n := 20;

param W := 30;

param : w v :=
1     3 3
2     2 5
3     7 1
4     5 8
5     4 7
6     7 6
7     3 4
8     2 10
9     7 4
10    5 10
11    4 7
12    7 6
13    3 2
14    2 5
15    7 7
16    5 2
17    4 2
18    7 9
19    3 3
20    6 4
;
end;
