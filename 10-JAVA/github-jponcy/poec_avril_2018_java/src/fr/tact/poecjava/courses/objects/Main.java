package fr.tact.poecjava.courses.objects;

public class Main {

    public static void main(String[] args) {
        People persons[] = new Person[]{
                new Employee(/* name */ "toto", /* age */ 106),
                new Employee("jo", 29),
                new Customer("Crésus", 1000000042)
        };

        System.out.println("Liste des personnes enregistrées :");

        for (People p : persons) {
            p.register();
            System.out.println(" - " + p);
        }
    }

    @SuppressWarnings("all")
    private static void possibilityWithoutObjects() {
        String names[] = new String[]{"Toto", "Jo"};
        int ages[] = new int[]{106, 29};
        short toto = 0, jo = 1;

        System.out.println(names[toto] + " a " + ages[toto] + " ans");
    }
}
