needsPackage "PosChar"

testOfHyperSurfaceBehavior = method(Options => {ListOfCounterEx => false});

testOfHyperSurfaceBehavior(ZZ,ZZ,ZZ,ZZ) := opt -> (n,p,d,dimen) -> (  				--tests all hypersurfaces of degree d in P^dimen(F_(p^n))
	K := GF(p,n,Variable=>b);
	S := K[X_0 .. X_dimen];								
	LinearVars := vars S;
	NumberOvars := numColumns(LinearVars);

	BasisDegd := basis(d,S);							--Build basis of monomials deg =< d

	N := (numColumns BasisDegd);
	
	TotalF := 2*p^(N-1)-1;								--Improves Speed for larger p by considering only (a_1,\ldots,a_(N-1),0) and (a_1,\ldots,a_(N-1),1)
	print TotalF;

	Lines = 2*p^(n*(NumberOvars)-1)-1;

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
			ListForCoeffsOfLi = getCoefficientListFromInteger(i,p^n,NumberOvars);

			if(ListForCoeffsOfLi#0==0) then (
				Vect = matrix{{sub(0,S)}};
			)
			else (
				Vect = matrix{{sub(b^(ListForCoeffsOfLi#0),S)}};
			);

			j=1;
			while (j<NumberOvars) do(
				if(ListForCoeffsOfLi#j==0) then (
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
			BoolVar2 = (dim(I/J)==0 or dim(I/J)==-1);
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
			print false; print F;
		)
		else if (BoolVar==true) then (
			print true;
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
			dimen := dim S-1;
			testOfHyperSurfaceBehavior(degreeExt,p,d,dimen)	
		);
	);
);

testForElement = method();				--Test in the affine case
testForElement(Ideal,ZZ) := (I,n) -> (
	S := ring(I);
	K := coefficientRing S;
	p := char K;
	K = GF(p^n,Variable=>b);
	newS := K[first entries (vars S)];
	newVars := vars newS;
	dimen := numColumns newVars;
	newI := sub(I,newS);

	Lines := 2*p^(n*dimen-1)-1;
							--Computes \Phi(F_*(I))
	newI2 := ethRoot(newI,1);

	BoolVar2 := false;				--Assume that \Phi(F_*(ideal(f)))^sat != \Phi(F_*(ideal(f*l^(p-1))))^sat

	i:=1;
	while(i<Lines and BoolVar2==false) do (		--Tests Examples one by one in terms of l, and if it finds one it stops the loop
		if(i == p^(n*(dimen-1))) then ( i = i+1; ) else (
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
		l = (first entries(newVars*Vect))#0;
		J = newI*ideal(l^(p-1));
		J = ethRoot(J,1);
		BoolVar2 = (dim(newI2/J)==0 or dim(newI2/J)==-1);
		i = i+1;
		if (i%10000 == 0) then print (i/Lines);
	); );

	i=1;


	print BoolVar2;
		
);

testForElement(RingElement,ZZ) := (F,n) -> (
	testForElement(ideal(F),n)
);

testForElementCustomY = method();				--Test in the affine case
testForElementCustomY(Ideal,ZZ) := (I,n) -> (
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

	BoolVar2 := false;				--Assume that \Phi(F_*(ideal(f)))^sat != \Phi(F_*(ideal(f*l^(p-1))))^sat

	i:=1;
	while(i<Lines and BoolVar2==false) do (		--Tests Examples one by one in terms of l, and if it finds one it stops the loop
		if(floor(i/(p^(n)))%(p^n) == 0 ) then ( i = i+1; )
		else (

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
		l = (first entries(newVars*Vect))#0;
		print l;
		J = newI*ideal(l^(p-1));
		J = ethRoot(J,1);
		BoolVar2 = (dim(newI2/J)==0 or dim(newI2/J)==-1);
		i = i+1;
		if (i%10000 == 0) then print (i/Lines);
	); );

	print BoolVar2;
		
);

testForElementCustomY(RingElement,ZZ) := (F,n) -> (
	testForElementCustomY(ideal(F),n)
);
