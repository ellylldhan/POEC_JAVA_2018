package fr.tact.poecjava.courses.rpg;

import java.util.*;

public class HeroController {

    private static final String REDEMPTEUR = "redempteur";
    private static final String ORACLE = "oracle";
    private static final String PALADIN = "paladin";
    private static final String ARCHER_MAGE = "archer-mage";
    private static final String ARCHER = "archer";
    private static final String BERZERKER = "berzerker";


    final Map<String, HeroClass> heroClasses = generateMapFor(
            new HeroClass(BERZERKER, false),
            new HeroClass(ARCHER, false),
            new HeroClass(ARCHER_MAGE, true),
            new HeroClass(PALADIN, true),
            new HeroClass(ORACLE, true),
            new HeroClass(REDEMPTEUR, true));

    final List<Player> players = Arrays.asList(
            new Player("darkkillerdu35", "sesame")
                    .addHero(new Hero("TheBestBeast", heroClasses.get(BERZERKER))),
            new Player("dez", "dez")
                    .addHero(new Hero("thedezman", heroClasses.get(PALADIN)))
                    .addHero(new Hero("thedezvision", heroClasses.get(ORACLE)))
                    .addHero(new Hero("dezdeztheheal", heroClasses.get(REDEMPTEUR))),
            new Player("thebest", "2log"));

    private static Map<String, HeroClass> generateMapFor(HeroClass... elements) {
        final Map<String, HeroClass> result = new HashMap<>();

        for (HeroClass hc : elements) {
            result.put(hc.getName(), hc);
        }

        return result;
    }

    /**
     * Returns the player for provided identifiers, null if anyone found.
     */
    public Player loginAction(String username, String password) {
        Player player;
        int i = 0;
        boolean correctLogin = false;

        do {
            player = players.get(i);
            correctLogin = player.checkLogin(username, password);
            ++i;
        } while (!correctLogin && i < players.size());

        if (!correctLogin) {
            player = null;
        }

        return player;
    }

    public List<HeroClass> getAllHeroClassAction() {
        return new ArrayList<>(heroClasses.values());
    }
}
