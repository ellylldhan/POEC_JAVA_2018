package fr.tact.poecjava.hangman;

import java.util.ArrayList;
import java.util.Random;
import java.util.Scanner;

public class Main {
    public static void main(String[] args) {
        final String words[] = new String[]{"bottle", "cartridge", "ink", "dog", "cat", "pig"};
        final String mystery = words[new Random().nextInt(words.length)];
        final char state[] = new char[mystery.length()];
        Scanner scanner = new Scanner(System.in);
        boolean notFound = true;
        int lives = 5;
        int missingFoundLetterNumber = mystery.length();
        ArrayList<String> tries = new ArrayList<>();

        // Initialize state.
        for (int i = 0; i < mystery.length(); ++i) {
            state[i] = '_';
        }

        printWelcomMessage(words);

        // Main loop - game.
        do {
            if (!tries.isEmpty()) {
                System.out.print("\nYou already try following items: " + String.join(", ", tries));
                /* Other possibilities to write list items.
                for (String s : tries) System.out.print(s);

                tries.forEach(elt -> System.out.print(elt));

                tries.forEach(System.out::print);
                */
            }

            System.out.print("\nYou have " + lives + " lives. State: ");
            for (char letter : state) System.out.print(letter);
            System.out.println(". Do your try (letter or word):");

            String input = scanner.nextLine().trim();

            // Record try.
            if (!tries.contains(input)) {
                tries.add(input);
            }

            switch (input.length()) {
                case 0:
                    continue;

                case 1: // Letter.
                    char letter = input.charAt(0);
                    int counter = 0;
                    boolean found = false;

                    for (char c : mystery.toCharArray()) {
                        if (c == letter) {
                            found = true;

                            if (state[counter] == '_') {
                                state[counter] = letter;
                                --missingFoundLetterNumber;
                            } else {
                                System.out.println("You already has tried " + letter);
                                break; // Out of for loop.
                            }
                        }

                        ++counter;
                    }

                    if (found) {
                        if (missingFoundLetterNumber == 0) {
                            notFound = false;
                        }
                    } else {
                        --lives;
                    }

                    break;

                default: // Word.
                    if (mystery.equals(input.toLowerCase())) {
                        notFound = false;
                    } else {
                        System.out.println("Not correct response");
                        --lives;
                    }
                    break;
            }
        } while (notFound && lives > 0);

        if (notFound) {
            System.out.println("Too bad.");
        } else {
            System.out.println("Congratulation, you won the game.");
        }

        // Close external resources.
        scanner.close();
    }

    private static void printWelcomMessage(String[] words) {
        StringBuilder builder = new StringBuilder();

        builder.append("Write a word (among: ");

        for (int i = 0; i < words.length; ++i) {
            if (i > 0) {
                builder.append(", ");
            }

            builder.append(words[i]);
        }

        builder.append(")");

        System.out.println(builder.toString());
    }
}
