package fr.tact.poecjava.courses.objects;

public final class Customer extends Person {

    private static int counter;

    /**
     * The customer number into our system.
     */
    private String number;

    public Customer(String name, int age) {
        super(name, age);
    }

    @Override
    public String toString() {
        String result = "Le client " + super.toString();

        if (this.number != null) {
            result += " (" + this.number + ")";
        }

        return result;
    }

    /**
     * @return Tells if we have recorded a new number. TRUE if it is, FALSE otherwise.
     */
    public boolean register() {
        boolean notHasNumber = this.number == null;

        if (notHasNumber) {
            this.number = String.format("%010d", ++Customer.counter); // .replace(" ", "X");
        }

        return !notHasNumber;
    }
}
