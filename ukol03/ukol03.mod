param numFacilities, integer;
param numCustomers, integer;
set F:=0..numFacilities-1;
set C:=0..numCustomers-1;
param costs{f in F};
param capacities{f in F};
param facilityXs{f in F};
param facilityYs{f in F};
param demands{c in C};
param customerXs{c in C};
param customerYs{c in C};

# promenne
var built{f in F}, binary;
var T{f in F, c in C}, binary;

# kriteria
minimize total: sum{f in F} built[f]*costs[f] + sum{f in F, c in C} T[f,c]*sqrt( (facilityXs[f]-customerXs[c])^2 + (facilityYs[f]-customerYs[c])^2 );

#podminky
s.t. fBuilt {f in F}: sum{c in C} T[f,c] >= built[f];
s.t. fCapacity {f in F}: sum{c in C} T[f,c]*demands[c] <= capacities[f]*built[f];
s.t. cSupplied {c in C}: sum{f in F} T[f,c] = 1;

solve;

printf "%f\n", total;
for {f in F: sum{c in C} T[f,c]*demands[c] > 0}{
	printf "%d", f;
    for {c in C: T[f,c]}{
    	printf " %d", c;
    }
    printf "\n";
}
#printf "Coconut total demand: %d\n", sum{c in C} demands[c];
#printf {c in C, f in F: T[f,c]} "Customer %d is supplied by facility %d\n", c, f;
#printf {f in F: sum{c in C} T[f,c]*demands[c] > 0} "Facility %d supplies customers by %d coconuts of %d total capacity\n", f, sum{c in C} T[f,c]*demands[c], capacities[f];
#printf "Coconut total supplied: %d\n", sum{f in F, c in C} T[f,c]*demands[c];
#printf "Total costs: %d\n", total;

