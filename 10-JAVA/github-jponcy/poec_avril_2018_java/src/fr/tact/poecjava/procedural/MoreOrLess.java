package fr.tact.poecjava.procedural;

import java.util.Random;
import java.util.Scanner;

public class MoreOrLess {

    public static void main(String[] args) {
        String line;
        int input;
        int mistery = new Random().nextInt(Integer.MAX_VALUE);
        boolean notFound;
        Integer lastInput = null;

        System.out.println("Essayez de trouver le chiffre mistère");
        // System.out.println("Indice, c'est " + mistery);
        Scanner scan = new Scanner(System.in);

        do {
            do {
                System.out.println("Saisir un nombre entre 0 et " + Integer.MAX_VALUE);
                line = scan.nextLine();
            } while (!isInt(line));

            input = Integer.parseInt(line);

            if ((notFound = mistery != input)) {
                if (lastInput != null && lastInput == input) {
                    System.out.println("Sérieux ? Vraiment, sérieux, t'es vraiment aussi bête ?");
                } else {
                    lastInput = input;
                }

                if (input < mistery) {
                    System.out.println("Le nombre à trouver est plus grand");
                } else { // Greater.
                    System.out.println("Le nombre à trouver est plus petit");
                }
            }
        } while (notFound);

        System.out.println("Bravo");

        scan.close();
    } // !main.

    private static boolean isInt(String value) {
        for (char c : value.toCharArray()) {
            if (!(c >= '0' && c <= '9')) {
                return false;
            }
        }

        return ("" + Integer.MAX_VALUE).compareTo(value) > 0;
    }
}
