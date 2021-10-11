val test_next_1 = next 1 = 2;
val test_next_2 = next ~1 = 0;
val test_next_3 = next ~2 = ~1;

val test_add_1 = add (1, 2) = 3;
val test_add_2 = add (0, 0) = 0;
val test_add_3 = add (~8, 8) = 0;

val test_majority_1 = majority(true, true, true) = true;
val test_majority_2 = majority(true, true, false) = true;
val test_majority_3 = majority(true, false, true) = true;
val test_majority_4 = majority(true, false, false) = false;
val test_majority_5 = majority(false, true, true) = true;
val test_majority_6 = majority(false, true, false) = false;
val test_majority_7 = majority(false, false, true) = false;
val test_majority_8 = majority(false, false, false) = false;

val equalThreshold = 0.000001;
val test_median_1 = Real.abs(median(1.0, 1.0, 0.0) - 1.0) < equalThreshold;
val test_median_2 = Real.abs(median(1.0, 0.0, 0.0) - 0.0) < equalThreshold;
val test_median_3 = Real.abs(median(1.0, 0.0, 2.1) - 1.0) < equalThreshold;
val test_median_4 = Real.abs(median(0.0, 0.0, 1.0) - 0.0) < equalThreshold;
val test_median_5 = Real.abs(median(0.0, 1.0, 1.0) - 1.0) < equalThreshold;
val test_median_6 = Real.abs(median(1.0, 0.0, 1.0) - 1.0) < equalThreshold;
val test_median_7 = Real.abs(median(5.6, 1.1, 9.9) - 5.6) < equalThreshold;
val test_median_8 = Real.abs(median(1.1, 5.6, 9.9) - 5.6) < equalThreshold;
val test_median_9 = Real.abs(median(1.1, 9.9, 5.6) - 5.6) < equalThreshold;
val test_median_10 = Real.abs(median(5.6, 9.9, 1.1) - 5.6) < equalThreshold;

val test_triangle_1 = triangle(7, 10, 5) = true;
val test_triangle_2 = triangle(1, 10, 12) = false;
val test_triangle_3 = triangle(1, 1, 1) = true;
val test_triangle_4 = triangle(0, 0, 0) = false;
val test_triangle_5 = triangle(0, 0, 10) = false;
val test_triangle_6 = triangle(~2, ~2, ~2) = false;