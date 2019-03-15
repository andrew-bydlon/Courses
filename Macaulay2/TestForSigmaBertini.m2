needsPackage "PosChar"

TestForSigmaDescent = method();		    --Takes a graded quotient of a polynomial rings R, and tests if sigma(R)^sat * (R/l_c) = sigma(R/l_c)^sat
TestForSigmaDescent(Ring,ZZ) = (R,n) -> (  --n represents the largest degree of the field extension that you would like to test
	I := ideal(R);
	MatVarsR := vars R
	VariablesOfR := first entries MatVarsR;
	N := # VariablesOfR;
	p := char R;

	K := GF(p,n,Variable=>b);	
	ExtPoly := K[VariablesOfR];
	I = sub(I,ExtPoly);
	R = ExtPoly/I;
	MatVarsR = sub(MatVarsR, R);
	l := 1;
	while(ethRoot(I^(p^l-1),l) != ethRoot(I^(p^(l+1)-1),l+1)) do(
		l=l+1;
	);

	Istab := saturate(ethRoot(I^(p^l-1),l));
	
	ListMin := {0};
	ListMax := {p^n-2};
	
	l=1;
	while(l<N-1) do (
		ListMin = ListMin | {0};
		ListMax = ListMax | {p^n-2};
		l=l+1;
	);

	ListExponents := ListMin..ListMax;
	NumberLists := #ListExponents;

	l = 0;
	TestOfData := true;
	while ((l<NumberLists) and (TestOfData == true)) do(
		Mat = matrix{{1}};
		k = 0;
		while(k<N-1) do (
			EXP = ListExponents#l#k;
			Mat = Mat | matrix{{b^EXP}};
			k = k+1;
		);
		Mat = sub(transpose Mat,R);

		linearElement = MatVarsR * Mat;
		linearElement = first entries linearElement;
		linearElement = linearElement#0;
		linearElement = sub(linearElement,ExtPoly);

		J = I * ideal(linearElement);
		k=1;
		while(ethRoot(J^(p^k-1),k) != ethRoot(J^(p^(k+1)-1),k+1)) do(
			k=k+1;
		);

		J = ethRoot(J^(p^k-1),k);
		J = saturate(J);
		TestOfData = (Istab == J);

		l = l+1;

	);

	if(TestOfData == true) then(
		TestOfData
	);

	else (
		linearElement
	);
);

