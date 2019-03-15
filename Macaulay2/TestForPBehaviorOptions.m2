needsPackage "PosChar"

testOfHyperSurfaceBehavior = method(Options => {ListOfCounterEx => false});

testOfHyperSurfaceBehavior(ZZ,ZZ,ZZ,ZZ) := opt -> (n,p,d,dimen) -> (  				--tests all hypersurfaces of degree d in A^dimen(F_(p^n))
	K := GF(p,n,Variable=>b);
	S := K[X_1 .. X_dimen];								
	LinearVars := vars S;
	NumberOvars := numColumns(LinearVars);

	BasisDegd := basis(d,S);							--Build basis of monomials deg =< d
	Indexer := d-1;
	while(Indexer>= 0) do (
		BasisDegd = BasisDegd | basis(Indexer,S);
		Indexer = Indexer -1;
	);

	N := (numColumns BasisDegd);
	
	TotalF := 2*p^(N-1)-1;								--Improves Speed for larger p by considering only (a_1,\ldots,a_(N-1),0) and (a_1,\ldots,a_(N-1),1)

	print TotalF;

	ListForCoeffsOfL = MakeListNManyElements(NumberOvars,-1) .. MakeListNManyElements(NumberOvars,p^n-2);
	Lines = # ListForCoeffsOfL;

	if (opt.ListOfCounterEx == true) then (
		CounterExamples := {};
	);

	BoolVar = true;
	k = 1;
	while(k<TotalF and BoolVar==true) do (						--Looping through possible F of degree d
		ListForF = getCoefficientListFromInteger(k,p,N);
		MatrixFieldF = matrix{{sub(ListForF#0,S)}};

		i=1;
		while(i<N) do (								--Creates the F by use of possible coefficients times each element of the basis
			MatrixFieldF = MatrixFieldF | matrix{{sub(ListForF#i,S)}};
			i = i+1;
		);

		MatrixFieldF = transpose(MatrixFieldF);
		F = (first entries(BasisDegd * MatrixFieldF))#0;				--Computes \Phi(F_*(I))
		I = ethRoot(ideal(F),1);

		i=1;
		
		BoolVar2 := false;							--Assume that \Phi(F_*(ideal(f)))^sat != \Phi(F_*(ideal(f*l^(p-1))))^sat
		
		while(i<Lines and BoolVar2==false) do (					--Tests Examples one by one in terms of l, and if it finds one it stops the loop			
			ListForCoeffsOfLi = ListForCoeffsOfL#i;

			if(ListForCoeffsOfLi#0==-1) then (
				Vect = matrix{{sub(0,S)}};
			)
			else (
				Vect = matrix{{sub(b^(ListForCoeffsOfLi#0),S)}};
			);

			j=1;
			while (j<NumberOvars) do(
				if(ListForCoeffsOfLi#j==-1) then (
					Vect = Vect | matrix{{sub(0,S)}};
				)
				else (
					Vect = Vect | matrix{{sub(b^(ListForCoeffsOfLi#j),S)}};
				);
				j=j+1;
			);
			Vect = transpose(Vect);
			l = 1+(first entries(LinearVars*Vect))#0;
			
			J = ideal(F*l^(p-1));
			J = ethRoot(J,1);
			BoolVar2 = (I == J);
			i = i+1;
		);

		i = 1;

		while(i<Lines and BoolVar2==false) do (					--Tests Examples one by one in terms of l, and if it finds one it stops the loop			
			ListForCoeffsOfLi = ListForCoeffsOfL#i;

			if(ListForCoeffsOfLi#0==-1) then (
				Vect = matrix{{sub(0,S)}};
			)
			else (
				Vect = matrix{{sub(b^(ListForCoeffsOfLi#0),S)}};
			);

			j=1;
			while (j<NumberOvars) do(
				if(ListForCoeffsOfLi#j==-1) then (
					Vect = Vect | matrix{{sub(0,S)}};
				)
				else (
					Vect = Vect | matrix{{sub(b^(ListForCoeffsOfLi#j),S)}};
				);
				j=j+1;
			);
			Vect = transpose(Vect);
			l = (first entries(LinearVars*Vect))#0;
			
			J = ideal(F*l^(p-1));
			J = ethRoot(J,1);
			BoolVar2 = (I == J);
			i = i+1;
		);
		
		if (opt.ListOfCounterEx==true and BoolVar2==false) then(
			CounterExamples = CounterExamples | {F};
		)

		else (
			BoolVar = BoolVar2;
		);

		if (k%1000 == 0) then print (k/TotalF);				--Debugging to see percentage

		k=k+1;
	);

	if (opt.ListOfCounterEx == true) then(
		if (#CounterExamples == 0) then (
			print true;
		)
		else (
			print false;
			print CounterExamples;
		);
	)
	else (
		if (BoolVar==false) then (
			print Boolvar; print F;
		)
		else if (BoolVar==true) then (
			print BoolVar;
		);
	);
);

------------------------------------------------

getCoefficientListFromInteger = method()
getCoefficientListFromInteger(ZZ,ZZ,ZZ) := (i,pton,entryCount) -> (
	apply(entryCount, z -> (floor(i/pton^z)%pton))
)

------------------------------------------------

MakeListNManyElements = method()
MakeListNManyElements(ZZ,ZZ) := (M,r) -> (
	NList := {r};
	i:=1;
	while (i<M) do (
		NList = NList | {r};
		i = i+1;
	);
	NList
);

------------------------------------------------
--	Special Cases	------------------------
------------------------------------------------

testOfHyperSurfaceBehavior(Ring,ZZ) := (S,d) -> (		--Utilize for a given ring
	Bool := isPolynomialRing(S);
	if (Bool == false) then (
		print "Not Polynomial Ring!";
	)
	else(
		K = coefficientRing S;
		p := char K;
		if (p == 0) then (
			print "Not Positive Characteristic!";
		)
		else (
			FieldRing := ambient K;
			J := ideal FieldRing;
			degreeExt := degree(J_0);
			degreeExt = degreeExt#0;
			dimen := dim S;
			testOfHyperSurfaceBehavior(degreeExt,p,d,dimen)	
		);
	);
);

testForElement = method(Options => {ListOfCounterEx => false});				--Test in the affine case
testForElement(Ideal,ZZ) := opt -> (I,n) -> (
	S := ring(I);
	K := coefficientRing S;
	p := char K;
	K = GF(p^n,Variable=>b);
	newS := K[first entries (vars S)];
	newVars := vars newS;
	dimen := numColumns newVars;
	newI := sub(I,newS);

	Lines := p^(n*dimen-1)-1;
							--Computes \Phi(F_*(I))
	newI2 := ethRoot(newI,1);
	--newI = saturate(newI);

	if (opt.ListOfCounterEx == true) then (
		CounterExamples := {};
	);

	BoolVar2 := false;				--Assume that \Phi(F_*(ideal(f)))^sat != \Phi(F_*(ideal(f*l^(p-1))))^sat

	i:=1;
	while(i<Lines and BoolVar2==false) do (		--Tests Examples one by one in terms of l, and if it finds one it stops the loop
		Linei = getCoefficientListFromInteger(i,p^n,dimen);
		elem = Linei#0;

		if (elem == 0) then (
			Vect = matrix{{sub(0,newS)}};
		)
		else (
			Vect = matrix{{sub(b^(elem-1),newS)}};
		);

		j=1;
		while (j<dimen) do(
			elem = Linei#j;
			if (elem == 0) then (
				Vect = Vect | matrix{{sub(0,newS)}};
			)
			else (
				Vect = Vect | matrix{{sub(b^(elem-1),newS)}};
			);
			j= j+1;
		);
		Vect = transpose(Vect);
		l = 1+ (first entries(newVars*Vect))#0;
		print l;
		J = newI*ideal(l^(p-1));
		J = ethRoot(J,1);
		
		if (opt.ListOfCounterEx == true) then(
			CounterExamples=CounterExamples|{l};
		)
		else (
		BoolVar2 = (newI2 == J);
		);
		i = i+1;
		if (i%10000 == 0) then print (i/Lines);
	);

	i=1;
	while(i<Lines and BoolVar2==false) do (		--Tests Examples one by one in terms of l, and if it finds one it stops the loop
		Linei := getCoefficientListFromInteger(i,p^n,dimen);
		elem = Linei#0;
		if (elem == 0) then (
			Vect = matrix{{sub(0,newS)}};
		)
		else (
			Vect = matrix{{sub(b^(elem-1),newS)}};
		);

		j=1;
		while (j<dimen) do(
			elem = Linei#j;
			if (elem == 0) then (
				Vect = Vect | matrix{{sub(0,newS)}};
			)
			else (
				Vect = Vect | matrix{{sub(b^(elem-1),newS)}};
			);
			j= j+1;
		);
		Vect = transpose(Vect);
		l = (first entries(newVars*Vect))#0;
		
		J = newI*ideal(l^(p-1));
		J = ethRoot(J,1);
		if (opt.ListOfCounterEx == true) then(
			CounterExamples=CounterExamples|{l};
		)
		else (
		BoolVar2 = (newI2 == J);
		);
		i = i+1;
		if (i%10000 == 0) then print (i/Lines);
	);

	if (opt.ListOfCounterEx == true) then(
		print CounterExamples;
	)
	else (
		print BoolVar2;
	);	
);

testForElement(RingElement,ZZ) := (F,n) -> (
	testForElement(ideal(F),n)
);



