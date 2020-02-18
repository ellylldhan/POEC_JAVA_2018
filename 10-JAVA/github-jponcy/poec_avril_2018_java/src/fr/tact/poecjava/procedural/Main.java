package fr.tact.poecjava.procedural;

public class Main {
    public static void main(String[] args) {
        int i = 2;

        for (int j = 1; j <= 4; ++j, i *= j) ;

        System.out.println(i);
    }
}
