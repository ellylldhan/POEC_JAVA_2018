package fr.tact.poecjava.first_classes;

public class Main {
    public static void main(String[] args) {
        MugCollection store = new MugCollection();

        store.addMug(new Mug().setName("TACT"));
        store.addMug(new Mug()
                .setName("Meilleure maman du monde")
                .setStock(32)
                .setDescription("Un classique")
                .setPrice(10f));
        store.addMug(new Mug().setName("C'est MON mug!").setStock(3));
        store.addMug(new Mug()
                .setName("Meilleur papa du monde")
                .setStock(2)
                .setDescription("On fait semblant d'en vendre pour éviter les plaintes de sexisme, mais personne ne nous les achète ..."));

        store.printStore();
    }
}
