package fr.tact.poecjava.courses.generic;

public class MyMath {
    public static <T extends Number> T genericMax(T a, T b) {
        return (a.doubleValue() > b.doubleValue()) ? a : b;
    }
//    public static <T extends Number & Comparable<? super Number>> T genericMax(T a, T b) {
//        return (a.compareTo(b) > 0) ? a : b;
//    }
//
//    public static double max(int a, int b) {
////        return (a > b) ? a : b;
//        return MyMath.max((double)a, (double) b);
//    }
//
//    public static double max(double a, double b) {
//        return (a > b) ? a : b;
//    }
}
