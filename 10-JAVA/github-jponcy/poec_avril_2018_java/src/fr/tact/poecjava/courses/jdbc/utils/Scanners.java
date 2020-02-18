package fr.tact.poecjava.courses.jdbc.utils;

import java.util.Scanner;

public class Scanners {

    private static Scanners instance = new Scanners();
    private Scanner scanner = new Scanner(System.in);

    /**
     * Private constructor because utility class.
     */
    private Scanners() {
    }

    public static int getInt() {
        return Integer.parseInt(Scanners.getIntValue());
    }

    public static String getIntValue() {
        String result;

        while (!(result = Scanners.scanLine()).matches("^\\d+$")) ;

        return result;
    }

    public static Integer getEmptyableInt() {
        String fill;

        do {
            fill = Scanners.scanLine();

            if ("".equals(fill)) {
                return null;
            }
        } while (!fill.matches("^\\d+$"));

        return Integer.parseInt(fill);
    }

    public static String getEmptyableString() {
        return Scanners.scanLine();
    }

    public static String getString() {
        String result;

        while ("".equals(result = Scanners.scanLine())) ;

        return result;
    }

    private static String scanLine() {
        return Scanners.instance().scanner.nextLine().trim();
    }

    private static Scanners instance() {
        return Scanners.instance;
    }
}
