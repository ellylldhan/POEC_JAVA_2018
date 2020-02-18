package fr.tact.poecjava.courses.rpg;

public class HeroClass {

    private String name;

    private boolean magic;

    public HeroClass(String name, boolean magic) {
        this.name = name.toLowerCase().trim();
        this.magic = magic;
    }

    @Override
    public String toString() {
        return this.getName() + ", c'est une classe "
                + (this.isMagic() ? "" : "NON ") + "magique";
    }

    /**
     * @return the name
     */
    public final String getName() {
        return this.name;
    }

    /**
     * @return the magic
     */
    public final boolean isMagic() {
        return this.magic;
    }
}
