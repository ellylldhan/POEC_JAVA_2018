package fr.tact.poecjava.courses.jdbc.entity;

public class TchuTchu {
    private Integer id;
    private String nom;
    /**
     * The initial -max- speed (could be reduced by weight).
     */
    private Integer vitesse;
    /**
     * The real weight.
     */
    private Integer poids;
    // TODO: Add machineDeTete
    // TODO: Add typeDeRail
    // TODO: Add trajet

    public TchuTchu() {
        super();
    }

    public TchuTchu(Integer id, String nom, Integer vitesse, Integer poids) {
        this.setId(id);
        this.setNom(nom);
        this.setVitesse(vitesse);
        this.setPoids(poids);
    }

    @Override
    public String toString() {
        String result = "";

        if (this.getId() != null) {
            result += "(" + this.getId() + ") ";
        }

        result += this.getNom();

        return result;
    }

    /**
     * @return Returns the id.
     */
    public final Integer getId() {
        return this.id;
    }

    /**
     * Sets the id.
     *
     * @param id The id to set.
     */
    public final void setId(Integer id) {
        this.id = id;
    }

    /**
     * @return Returns the nom.
     */
    public final String getNom() {
        return this.nom;
    }

    /**
     * Sets the nom.
     *
     * @param nom The nom to set.
     */
    public final void setNom(String nom) {
        this.nom = nom;
    }

    /**
     * @return Returns the vitesse.
     */
    public final Integer getVitesse() {
        return this.vitesse;
    }

    /**
     * Sets the vitesse.
     *
     * @param vitesse The vitesse to set.
     */
    public final void setVitesse(Integer vitesse) {
        this.vitesse = vitesse;
    }

    /**
     * @return Returns the poids.
     */
    public final Integer getPoids() {
        return this.poids;
    }

    /**
     * Sets the poids.
     *
     * @param poids The poids to set.
     */
    public final void setPoids(Integer poids) {
        this.poids = poids;
    }
}
