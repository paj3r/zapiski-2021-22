(* testi predvidevajo tudi implementacijo funkcije simp *)
val ena = Succ Zero;
val dve = Succ (Succ Zero);
val tri = Succ (Succ (Succ Zero));
val minus_ena = Pred Zero;
val minus_dve = Pred (Pred Zero);
val minus_tri = Pred (Pred (Pred Zero));
val ena_grdo = Pred (Pred (Succ (Pred (Succ (Succ (Succ Zero))))));
val minus_ena_grdo = Succ (Pred (Succ (Pred (Pred (Succ (Pred Zero))))));

(* testi tipov manjkajo *)
val testSimp1 = simp ena_grdo = ena;
val testSimp2 = simp minus_ena_grdo = minus_ena;
val testSimp3 = simp Zero = Zero;
val testSimp4 = simp ena = ena;

val testNeg1 = simp (neg ena) = simp minus_ena; (* pravilen odgovor je katerakoli (ne nujno ekonomična) reprezentacija negacije vhodnega argumenta *)
val testNeg1 = simp (neg ena) = minus_ena; (* implementacija neg naj ne bi uporabljala simp *)
val testNeg2 = simp (neg Zero) = Zero;
val testNeg3 = simp (neg minus_ena) = ena;
val testNeg4 = simp (neg ena_grdo) = minus_ena;
val testNeg5 = simp (neg minus_dve) = dve;

val testAdd1 = simp (add (ena, Zero)) = simp ena; (* pravilen odgovor je katerakoli (ne nujno ekonomična) reprezentacija vsote vhodnih argumentov *)
val testAdd1 = simp (add (ena, Zero)) = ena; (* implementacija  add naj ne bi uporabljala simp *)
val testAdd2 = simp (add (ena, minus_ena)) = Zero;
val testAdd3 = simp (add (minus_ena, ena)) = Zero;
val testAdd4 = simp (add (minus_ena, minus_dve)) = minus_tri;
val testAdd5 = simp (add (minus_dve, tri)) = ena;
val testAdd6 = simp (add (dve, minus_tri)) = minus_ena;
val testAdd7 = simp (add (ena, dve)) = tri;

val testComp1 = comp (Zero, Zero) = EQUAL;
val testComp2 = comp (Zero, ena) = LESS;
val testComp3 = comp (Zero, minus_ena) = GREATER;
val testComp4 = comp (minus_dve, Zero) = LESS;
val testComp5 = comp (minus_dve, minus_tri) = GREATER;
val testComp6 = comp (minus_tri, minus_ena) = LESS;
val testComp7 = comp (minus_ena, tri) = LESS;
val testComp8 = comp (tri, Zero) = GREATER;
val testComp9 = comp (minus_dve, minus_dve) = EQUAL;
val testComp10 = comp (ena_grdo, ena_grdo) = EQUAL;
val testComp11 = comp (ena_grdo, minus_ena_grdo) = GREATER;
val testComp12 = comp (tri, ena_grdo) = GREATER;
val testComp13 = comp (minus_ena_grdo, minus_ena) = EQUAL;
val testComp14 = comp (ena, ena_grdo) = EQUAL;


val tree1 = Node (2, Node (3, Leaf 1, Leaf 4), Node (5, Leaf 0, Leaf 6));
val tree2 = Leaf 1;
val tree3 = Node (2, Leaf 1, Node (3, Leaf 0, Leaf 0));
val tree4 = Node (2, Leaf 1, Leaf 4);
val tree5 = Node (8, Node (6, Node (2, Leaf 1, Node (4, Leaf 3, Leaf 5)), Leaf 7), Node (10, Leaf 9, Leaf 11));

val testContains1 = contains (tree1, 1) = true;
val testContains2 = contains (tree1, 2) = true;
val testContains3 = contains (tree1, 3) = true;
val testContains4 = contains (tree1, 4) = true;
val testContains5 = contains (tree1, 5) = true;
val testContains6 = contains (tree1, 6) = true;
val testContains7 = contains (tree1, 7) = false;
val testContains8 = contains (tree1, 8) = false;

val testHeight1 = height tree1 = 3;
val testHeight2 = height tree2 = 1;
val testHeight3 = height tree3 = 3;
val testHeight4 = height tree4 = 2;
val testHeight5 = height tree5 = 5;

val testToList1 = toList tree1 = [1, 3, 4, 2, 0, 5, 6]
val testToList2 = toList tree2 = [1]
val testToList3 = toList tree3 = [1, 2, 0, 3, 0]
val testToList4 = toList tree4 = [1, 2, 4]
val testToList5 = toList tree5 = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11]

val testIsBalanced1 = isBalanced tree1 = true;
val testIsBalanced2 = isBalanced tree2 = true;
val testIsBalanced3 = isBalanced tree3 = true;
val testIsBalanced4 = isBalanced tree4 = true;
val testIsBalanced5 = isBalanced tree5 = false;

val testIsBST1 = isBST tree1 = false;
val testIsBST2 = isBST tree2 = true;
val testIsBST3 = isBST tree3 = false;
val testIsBST4 = isBST tree4 = true;
val testIsBST5 = isBST tree5 = true;



(* tukaj je se en paket testov. Predvidevajo tudi implementacijo funkcij minTree in maxTree, ki vrnejo min/max vrednost v drevesu*)
val all_tests : bool list ref = ref [];

val all_tests : bool list ref = ref [];
val _ : number -> number = neg; (* test tipa *)


val one = Succ Zero;
val two = Succ one;
val three = Succ two;
val minusOne = Pred Zero;
val minusTwo = Pred minusOne;

val _ = print "---------- neg ----------\n";
val test1 = neg(one) = minusOne;
val test2 = neg(Zero) = Zero;
val test3 = neg(two) = minusTwo;
val test4 = (neg(Zero) = one) = false;
val test5 = (neg(two) = minusOne) = false;
val _ = (all_tests := !all_tests @ [test1, test2, test3, test4, test5]);

val _ = print "---------- simp ----------\n";
val test1 = simp (Pred (Succ (Succ (Pred (Pred (Succ (Pred Zero))))))) = Pred Zero;
val test2 = simp (Succ Zero) = Succ Zero;
val test3 = simp (Pred (Pred (Pred (Pred (Pred Zero))))) = Pred (Pred (Pred (Pred (Pred Zero))));
val test4 = simp (Pred (Succ (Succ (Pred Zero)))) = Zero;
val test5 = simp (Pred (Succ (Pred (Succ Zero)))) = Zero;
val _ = (all_tests := !all_tests @ [test1, test2, test3, test4, test5]);

val _ = print "---------- add ----------\n";
val test1 = simp(add(one, two)) = three;
val test2 = simp(add(Zero, one)) = one;
val test3 = simp(add(minusTwo, two)) = Zero;
val test4 = simp(add(minusOne, one)) = Zero;
val test5 = simp(add(minusTwo, one)) = minusOne;
val test6 = simp(add(one, one)) = two;
val _ = (all_tests := !all_tests @ [test1, test2, test3, test4, test5, test6]);

val _ = print "---------- comp ----------\n";
val test1 = comp(one, two) = LESS;
val test2 = comp(Zero, one) = LESS;
val test3 = comp(minusTwo, two) = LESS;
val test4 = comp(minusOne, one) = LESS;
val test5 = comp(minusTwo, one) = LESS;
val test6 = comp(one, one) = EQUAL;
val test7 = comp(one, minusOne) = GREATER;
val _ = (all_tests := !all_tests @ [test1, test2, test3, test4, test5, test6, test7]);

val leaf1 = Leaf 1;
val leaf2 = Leaf 2;
val leaf3 = Leaf 3;
val tree1 = Node (0, leaf1, leaf2);
val tree2 = Node (5, tree1, leaf3);
val tree3 = Node (7, tree1, tree2);

val _ = print "---------- contains ----------\n";
val test1 = contains(leaf1, 1) = true;
val test2 = contains(leaf1, 2) = false;
val test3 = contains(tree1, 0) = true;
val test4 = contains(tree1, 1) = true;
val test5 = contains(tree1, 2) = true;
val test6 = contains(tree2, 1) = true;
val test7 = contains(tree3, 0) = true;
val test8 = contains(tree3, 3) = true;
val test9 = contains(tree3, 7) = true;
val test10 = contains(tree3, 17) = false;
val _ = (all_tests := !all_tests @ [test1, test2, test3, test4, test5, test6, test7, test8, test9, test10]);

val _ = print "---------- countLeaves ----------\n";
val test1 = countLeaves(leaf1) = 1; (* zakaj tukaj uporabljaš oklepaje ? *)
val test2 = countLeaves(leaf2) = 1;
val test3 = countLeaves(tree1) = 2;
val test4 = countLeaves(tree2) = 3;
val test5 = countLeaves(tree3) = 5;
val _ = (all_tests := !all_tests @ [test1, test2, test3, test4, test5]);


val _ = print "---------- countBranches ----------\n";
val test1 = countBranches(leaf1) = 0; (* zakaj tukaj uporabljaš oklepaje ? *)
val test2 = countBranches(leaf2) = 0;
val test3 = countBranches(tree1) = 2;
val test4 = countBranches(tree2) = 4;
val test5 = countBranches(tree3) = 8;
val _ = (all_tests := !all_tests @ [test1, test2, test3, test4, test5]);

val _ = print "---------- height ----------\n";
val test1 = height(leaf1) = 1; (* zakaj tukaj uporabljaš oklepaje ? *)
val test2 = height(leaf2) = 1;
val test3 = height(tree1) = 2;
val test4 = height(tree2) = 3;
val test5 = height(tree3) = 4;
val _ = (all_tests := !all_tests @ [test1, test2, test3, test4, test5]);

val _ = print "---------- tolist ----------\n";
val test1 = toList(leaf1) = [1]; (* zakaj tukaj uporabljaš oklepaje ? *)
val test2 = toList(leaf2) = [2];
val test3 = toList(tree1) = [1, 0, 2];
val test4 = toList(tree2) = [1, 0, 2, 5, 3];
val test5 = toList(tree3) = [1,0,2,7,1,0,2,5,3];
val _ = (all_tests := !all_tests @ [test1, test2, test3, test4, test5]);

val tree4 = Node (1, Leaf 1, tree3);

val _ = print "---------- balanced ----------\n";
val test1 = isBalanced(leaf1) = true; (* zakaj tukaj uporabljaš oklepaje ? *)
val test2 = isBalanced(leaf2) = true;
val test3 = isBalanced(tree1) = true;
val test4 = isBalanced(tree2) = true;
val test5 = isBalanced(tree3) = true;
val test6 = isBalanced(tree4) = false;
val _ = (all_tests := !all_tests @ [test1, test2, test3, test4, test5, test6]);

val _ = print "---------- maxTree ----------\n";
val test1 = maxTree(leaf1) = 1; (* zakaj tukaj uporabljaš oklepaje ? *)
val test2 = maxTree(leaf2) = 2;
val test3 = maxTree(tree1) = 2;
val test4 = maxTree(tree2) = 5;
val test5 = maxTree(tree3) = 7;
val _ = (all_tests := !all_tests @ [test1, test2, test3, test4, test5]);

val _ = print "---------- minTree ----------\n";
val test1 = minTree(leaf1) = 1; (* zakaj tukaj uporabljaš oklepaje ? *)
val test2 = minTree(leaf2) = 2;
val test3 = minTree(tree1) = 0;
val test4 = minTree(tree2) = 0;
val test5 = minTree(tree3) = 0;
val _ = (all_tests := !all_tests @ [test1, test2, test3, test4, test5]);

val bst1 = Node (1, Leaf 0, Leaf 2);
val bst2 = Node (10, Leaf 9, Leaf 11);
val bst3 = Node (3, bst1, bst2);

val _ = print "---------- binarno ----------\n";
val test1 = isBST(leaf1) = true; (* zakaj tukaj uporabljaš oklepaje ? *)
val test2 = isBST(leaf2) = true;
val test3 = isBST(tree1) = false;
val test4 = isBST(tree2) = false;
val test5 = isBST(tree3) = false;
val test6 = isBST(tree4) = false;
val test7 = isBST(bst1) = true;
val test8 = isBST(bst2) = true;
val test9 = isBST(bst3) = true;
val _ = (all_tests := !all_tests @ [test1, test2, test3, test4, test5, test6, test7, test8, test9]);

(* aggregation of all restuts *)
val nr_passes_tests = foldl (fn (true, acc) => acc + 1 | (false, acc) => acc) 0 (!all_tests);
val nr_all_tests = length (!all_tests);