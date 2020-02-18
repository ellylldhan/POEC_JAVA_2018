package fr.tact.poecjava.courses.rpg;

import java.util.ArrayList;
import java.util.List;

public class Player {

    private final List<Hero> heroes = new ArrayList<>();
    private String username;
    private String password;

    /**
     * Constructor.
     */
    public Player(String username, String password) {
        this.username = username;
        this.password = password;
    }
    /* Could provide heroes into construct to provide list.
    public Player(String username, String password, List<Hero> heroes) {
        this.username = username;
        this.password = password;
        this.heroes.addAll(heroes);
    }
    */

    /**
     * Tells if given parameters corresponding to current object.
     */
    public boolean checkLogin(String username, String password) {
        return this.username.equals(username) && this.password.equals(password);
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    /**
     * Returns the list of heroes.
     */
    public List<Hero> getHeroes() {
        return this.heroes;
    }

    /**
     * Add the provided hero into our list.
     */
    public Player addHero(Hero hero) {
        /*
         * We have ArrayList which not manage duplicate values.
         *
         *  We could:
         *  - use another container class
         *  - manage manually (chosen solution)
         */
        if (!this.heroes.contains(hero)) {
            this.heroes.add(hero);
        }

        return this;
    }

    public void removeHero(Hero hero) {
        this.heroes.remove(hero);
    }
}
