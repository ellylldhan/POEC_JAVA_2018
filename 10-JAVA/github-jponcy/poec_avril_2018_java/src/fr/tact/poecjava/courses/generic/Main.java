package fr.tact.poecjava.courses.generic;


public class Main {
    public static void main(String[] args) {
//        printer();

        int i = 3;

        if (i < 0) {
            i = 0;
        } else if (i > 10) {
            i = 10;
        }

        i = Math.max(0, Math.min(10, i));

        Math.max(1, 1);
        Math.max(1f, 2f);
        Math.max(1l, 2d);

        MyMath.genericMax(1, 1);
        MyMath.genericMax(1f, 1f);
        MyMath.genericMax(1d, 2.3d);
        MyMath.genericMax(1l, 2l);
        MyMath.genericMax(1l, 2d);
    }

    @SuppressWarnings("all")
    private static void printer() {
        Printer<Double> pi = new Printer<>(3.14d);

        pi.execute();

        new Printer<String>("toto").execute();
    }
}
