package fr.tact.poecjava.courses.exceptions;

class StupidNumberException extends Exception {
    private static final long serialVersionUID = -2692883198310941319L;

    public StupidNumberException(String message) {
        super(message);
    }
}

public class StupidExceptionUse {
    public static void main(String[] args) {
        int number = 6;
        boolean success = false;

        while (!success) {
            try {
                encapsulate(number);
                success = true;
            } catch (StupidNumberException e) {
                ++number;
            } catch (Exception e) {
                System.out.println(9 + " reached");
                ++number;
            }
        }

        System.out.println(number);
    }

    private static void encapsulate(int number) throws StupidNumberException {
        stupidFunction(number);
        System.out.println("Encapsulate passed");
    }

    private static void stupidFunction(int number) throws StupidNumberException {
        if (number < 9) {
//            throw new Exception("Nombre invalide");
            throw new StupidNumberException("Nombre invalide");
        } else if (number == 9) {
            throw new RuntimeException("nop");
        }
    }
}
