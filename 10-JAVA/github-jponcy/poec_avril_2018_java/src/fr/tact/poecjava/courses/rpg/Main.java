package fr.tact.poecjava.courses.rpg;

import java.util.List;
import java.util.Scanner;

public class Main {

    private final static HeroController heroController = new HeroController();

    /**
     * Entry point.
     */
    public static void main(String[] args) {
        final Scanner scanner = new Scanner(System.in);
        String username, password;

        System.out.println("Bienvenue sur JavaOnline, on va bien s'amuser !");
        System.out.println("Saisir votre login :");
        username = scanner.nextLine();
        System.out.println("Saisir votre mot de passe:");
        password = scanner.nextLine();

        Player player = heroController.loginAction(username, password);

        if (player == null) {
            System.out.println("Echec de connexion");
        } else {
            System.out.println("Vous êtes désormais connecté");

//            String choice = selectOne(Arrays.asList("Créer un nouveau personnage", "Charger un personnage"));
//            if (choice.equals("Créer un nouveau personnage")) {
//                Hero selectedHero = createNewHero(player);
//                System.out.println("Connexion en cours, avec le héro " + selectedHero);
//                return;
//            }

            switch (player.getHeroes().size()) {
                case 0:
                    System.out.println("Vous n'avez pas encore de personnage, créons en un");
                    createNewHero(player);
                    break;
                default:
                    System.out.println("Avec quel personnage voulez-vous vous connecter ?");
                    Hero selectedHero = selectOne(player.getHeroes());
                    System.out.println("Connexion en cours, avec le héro " + selectedHero);

                    break;
            }
        }

        scanner.close();
    }

    private static <T> T selectOne(List<T> elements) {
        final Scanner scanner = new Scanner(System.in);
        T result = null;

        do {
            for (int elementIndex = 1; elementIndex <= elements.size(); ++elementIndex) {
                System.out.println(elementIndex + ") " + elements.get(elementIndex - 1));
            }

            System.out.println();

            System.out.print("Votre choix (saisir le chiffre entre 1 et " + elements.size() + ") : ");
            String line = null;

            try {
                line = scanner.nextLine();
                int heroIndex = Integer.parseInt(line);

                if (heroIndex > 0 && heroIndex <= elements.size()) {
                    result = elements.get(heroIndex - 1);
                } else {
                    System.out.println("Le nombre saisie est trop petit ou trop grand");
                }
            } catch (NumberFormatException e) {
                System.out.println(line + " n'est pas un nombre");
            }
        } while (result == null);

        scanner.close();

        return result;
    }

    private static Hero createNewHero(Player player) {
        final Hero result = new Hero();
        final Scanner scanner = new Scanner(System.in);

        do {
            System.out.println("Nom du nouveau personnage : ");
            result.setName(scanner.nextLine());

        } while ("".equals(result.getName()));

        HeroClass heroClass = selectOne(heroController.getAllHeroClassAction());
        result.setHeroClass(heroClass);

        player.addHero(result);

        System.out.println("Bravo, nous avons créé votre nouveau personnage " + result);

        scanner.close();

        return result;
    }
}
