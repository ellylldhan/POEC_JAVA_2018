package fr.tact.poecjava.courses.rpg;

public class Hero {
    private String name;
    private HeroClass heroClass;
    private int level = 1;

    public Hero() {
    }

    public Hero(String name, HeroClass heroClass) {
        this.setName(name);
        this.setHeroClass(heroClass);
    }

    @Override
    public String toString() {
        return this.getName() + " (" + this.getHeroClass().getName() + ")";
    }

    /**
     * @return the name
     */
    public final String getName() {
        return name;
    }

    /**
     * @param name The name to set.
     */
    public final void setName(String name) {
        this.name = name.trim();
    }

    /**
     * @return the heroClass
     */
    public final HeroClass getHeroClass() {
        return this.heroClass;
    }

    /**
     * @param heroClass The heroClass to set.
     */
    public final void setHeroClass(HeroClass heroClass) {
        this.heroClass = heroClass;
    }

    public int getLevel() {
        return level;
    }

    public void levelUp() {
        ++this.level;
    }
}
