needsPackage "Divisor"

DualToIdeal = method();
DualToIdeal(Ideal) := (I) -> (
	R := ring(I);
	M :=module(I);
	moduleToIdeal(Hom(M,R),IsGraded=>true,ReturnMap=>true)
);

mRegular = method();

mRegular(CoherentSheaf,ZZ) := (F,n) -> ( 			--Case of a general CoherentSheaf on a projective variety
	V := variety(F);					--Takes inputs a sheaf F and lower bound for m-regularity n. 
	dV := dim(V);						--Returns m>=n minimal for which the sheaf is m-regular.
	j:=1;
	m:=n;
	while (j<(dV+1)) do (
		while (HH^j(F(>=(m-j))) != 0) do (
			m = m+1;
		);
		j=j+1;
	);
	m
);

mRegular(CoherentSheaf) := (F) -> ( 				--Case of a general CoherentSheaf on a projective 
	mRegular(F,0)
);

mRegular(Ideal) := (I) -> ( 					--Returns the number m for which O_X(D) is m-regular, where  I is an ideal,
	R := ring(I);						--and check regularity of the sheaf of functions with Poles along V(I).
	dR := dim(R);
	--F := sheaf(Hom(module(I),R));
	--mRegular(F)
	m=dR;
	bool=0;
        while (bool!=1) do(
           bool = 1;
            i = dR;
            while (i>0) do(
		G = first entries gens I;
		J_(m-i) = apply(G, z -> z^(m-i));
		J_(m-i) = ideal(J_(m-i));
              if (HH^i(sheaf(Hom(module(J_(m-i)),R))) == 0) then(
                  i = i-1;
                )
                else (
                    i=0;
                    m = m+1;
                    bool = 0;
                );
            );
        );
        m
);

sectionRing = method();						--Creates the section ring corresponding to the divisor D.
sectionRing(Ideal) := (I) -> (
	R := ring(I);						--Initial data to save on inputs from the user.
	dR:= dim(R);
	g := genus(R);
	KK:= coefficientRing(R);
	degD := degree(I);
	bound := mRegular(I);

	myVars := {};						--Begins to create a list for the necessary variables
	DegreeList :={};					--and a list of their corresponding degrees.
	i:=1; 
	G = first entries gens I;
	while ( i < (bound+1)) do(
		J_i = apply(G, z -> z^i);
		J_i = ideal(J_i);
		N_i = Hom(module(J_i),R);
		n_i = numColumns(basis(0,N_i));			--Computes the rank of H^0(O_X(iD)) and makes a list of lists
		myVars = (myVars) | {toList(YY_{i,1}..YY_{i,n_i})};  --of variables, grouped internally by degree for convenience
		Vars = flatten myVars;
		l=0;
		while(l<n_i) do(
			DegreeList = DegreeList | toList({i});
			l = l+1;
		);
	i=i+1;
	);

	Spar = KK [Vars,Degrees=>DegreeList];

	D2I_1 = DualToIdeal(J_1);

	j:=2;

	while ( (dim(Spar) >  dim(R)) or (isDomain(Spar) != true)) do ( --Create a list of relations
		Partj = partitions(j);				--Uses the partitions of j to get relations coming from products of elements
		LengP = #Partj;   				--of lower degrees
		a=1;
		if ((isIdeal(J_j)!=true) or (isIdeal(D2I_j#0)!= true)) then (			--may need additional modules and their size
			J_j = apply(G, z -> z^j);
			J_j = ideal(J_j);
			N_j = Hom(module(J_j),R);
			n_j = numColumns(basis(0,N_j));
			D2I_j = moduleToIdeal(N_j,IsGraded=>true,ReturnMap=>true);
		);
		while(a<LengP) do (  				--Relate each of the partitions in the form (a1>=a2>=...>=an) of j
			DegShiftTens = (D2I_(Partj#a#0))#1;	--by creating \otimes_i H^0(a_i*D) \osum H^0(nD) to a ring
			TMap = (D2I_(Partj#a#0))#2;	 	
			B0Map = basis(0,N_(Partj#a#0));
			TotMap = TMap*B0Map;
			Tens = source B0Map;
			b=1;
			LengPa = #(Partj#a);

			while (b<LengPa) do (
				TotMap = TotMap ** (((D2I_(Partj#a#b))#2)*basis(0,N_(Partj#a#b)));
				DegShiftTens = DegShiftTens + (D2I_(Partj#a#b))#1;
				Tens = Tens ** source(basis(0,N_(Partj#a#b)));
				b = b+1;
			);

			--A = (findElementOfDegree(DegShiftTens,R))#0*(findElementOfDegree(D2I_j#1,R))#1;	--Used to shift the degrees manually
			--B = (findElementOfDegree(D2I_j#1,R))#0*(findElementOfDegree(DegShiftTens,R))#1;

			--TotMap = (B*(TMap*B0Map)) | (A*(((D2I_j)#2) * basis(0,N_j)));	--Total Map from the tensor product
			TotMap = TotMap | ((D2I_j)#2 * basis(0,N_j));	--Total Map from the tensor product  
			Tens = Tens ++ module(D2I_j)#0;

			c=0;
			listmin = {};
			listmax = {};

			while (c< #(Partj#a)) do (				--Creates the vector to multiply with the kernel
				listmin = listmin | {1};
				listmax = listmax | {n_(Partj#a#c)};
				c = c+1;
			); 


			if(listmin == listmax) then (
				megaList = {listmin};
			)
			else if(listmin != listmax) then (
				megaList = listmin..listmax;
			);
	
			d=#megaList -1;
			e=0;
			Z=1;
			while(e< (#Partj#a)) do(
				if ((Partj#a#e) < i) then (
					Z = YY_{Partj#a#e,megaList#d#e} * Z;
				)
				else (
					Z = 0;
	  			);
				e = e+1;
			);
			d=d-1;
			Vect = matrix{{Z}};

			while(d>-1) do (
			e=0;
			Z = 1;
			while(e< (#Partj#a)) do(
				if ((Partj#a#e) < i) then (
		  		Z = YY_{Partj#a#e,megaList#d#e} * Z;
				)
				else (
				Z =0;
				);
			e = e+1;
			);

			Vect = Vect || matrix{{Z}};
			d = d-1;
			);

			d = 0;
			while(d < n_j) do (
				if (j<i) then (
			 		Vect = Vect || matrix{{YY_{j,d+1}}};
				)
				else (
					Vect = Vect || matrix{{0}}
				);
				d = d+1;
			);

			KerT = generators ker(TotMap);

			NumCols = numColumns(KerT);
			e := 0;
	
			while (e < NumCols) do (
				L = flatten entries KerT_{e};
				if ((isVectScalar L) == true) then (
					L = convertScalarVect(Spar,L);
					Rel = (entries (matrix{L}*Vect))#0#0;
					Spar = Spar/ideal(Rel);
				);
				e=e+1;
			); 

			a = a+1;
		);
		j=j+1;
	);
	Spar
);

isVectScalar = L -> (
	Ramb = ring (L#0); 
	all(L, z -> (degree(z) <= degree (sub(1, Ramb))) ) 
);

convertScalarVect = (newS, L) -> (apply(L, z->sub(z, newS)));
