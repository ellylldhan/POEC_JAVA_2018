package fr.tact.poecjava.courses.jdbc;

import fr.tact.poecjava.courses.jdbc.controller.TrainController;
import fr.tact.poecjava.courses.jdbc.utils.Scanners;

public class Main {

    /*
     * CREATE DATABASE poec_tchu_tchu;
     * CREATE TABLE train ( id INT(16) AUTO_INCREMENT NOT NULL PRIMARY KEY, name VARCHAR(255) NOT NULL UNIQUE, speed INT(5) NOT NULL, weight INT NOT NULL) ENGINE=InnoDB;
     * INSERT INTO train (name, speed, weight) VALUES ('transibérien', 5543, 103120432), ('213F3', 35, 215412), ('train3', 10, 103120432), ('train4', 35, 103120432), ('TTTGV', 54432, 103120432);
     */

    public static void main(String[] args) {
        TrainController controller = new TrainController();
        String mode;

        do {
            controller.printAll();

            System.out.println("");
            System.out.println("Que voulez-vous faire ?");
            System.out.println("1) ajouter un train");
            System.out.println("2) voir les détails d'un train");
            System.out.println("3) supprimer un train");
            System.out.println("4) modifier les informations d'un train");
            System.out.println("0) quitter l'application");

            mode = Scanners.getIntValue();

            switch (mode) {
                case "0": // Leave soft.
                    break;
                case "1": // Create.
                    controller.create();
                    break;
                case "2": // Read details.
                    controller.getOne(selectOne());
                    break;
                case "4": // Update.
                    controller.update(selectOne());
                    break;
                case "3": // Delete.
                    controller.delete(selectOne());
                    break;
            }
        } while (!"0".equals(mode));

        System.out.println("Merci, et à bientôt !");
    }

    public static int selectOne() {
        System.out.print("Sur quel train ? (donner l'id) : ");
        return Scanners.getInt();
    }
}
