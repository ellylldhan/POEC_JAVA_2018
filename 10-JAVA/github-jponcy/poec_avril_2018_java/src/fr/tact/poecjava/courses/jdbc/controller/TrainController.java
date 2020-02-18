package fr.tact.poecjava.courses.jdbc.controller;

import com.google.common.base.Strings;
import fr.tact.poecjava.courses.jdbc.entity.TchuTchu;
import fr.tact.poecjava.courses.jdbc.repository.EntityManager;
import fr.tact.poecjava.courses.jdbc.repository.TrainRepository;
import fr.tact.poecjava.courses.jdbc.utils.Scanners;

import java.util.List;

public class TrainController {

    private TrainRepository repository;

    public TrainController() {
        this.repository = EntityManager.repository(TrainRepository.class);
    }


    public void printAll() {
        List<TchuTchu> entities = this.repository.findAll();

        System.out.println("Liste initialisée");
        System.out.println("Les trains disponibles sont :");

        for (TchuTchu tchutchu : entities) {
            System.out.println("\t- " + tchutchu);
        }
    }

    public void create() {
        TchuTchu o = new TchuTchu();

        if (this.repository.create(this.fill(o)) > 0) {
            System.out.println("Création réussi");
        } else {
            System.err.println("Création échouée");
        }
    }

    public void update(int id) {
        TchuTchu o = this.repository.find(id);

        this.fill(o);

        this.repository.update(o);
    }

    public void getOne(Integer id) {
        TchuTchu one = this.repository.find(id);

        System.out.println("Détails du train (" + one.getId() + ") " + one.getNom());
        System.out.println("id : " + one.getId());
        System.out.println("nom : " + one.getNom());
        System.out.println("vitesse : " + one.getVitesse());
        System.out.println("poids : " + one.getPoids());
    }

    private TchuTchu fill(TchuTchu o) {
        System.out.println("Quel nom " + this.defaultValue(o.getNom()) + " ?");
        do {
            String nom = Scanners.getEmptyableString();
            if (!Strings.isNullOrEmpty(nom)) o.setNom(nom);
        } while (Strings.isNullOrEmpty(o.getNom()));

        System.out.println("Quel est le poids (en Kg)" + this.defaultValue(o.getPoids()) + " ?");
        do {
            Integer poids = Scanners.getEmptyableInt();
            if (poids != null) o.setPoids(poids);
        } while (o.getPoids() == null);

        System.out.println("Quel est la vitesse (en Km/h) " + this.defaultValue(o.getVitesse()) + " ?");
        do {
            Integer vitesse = Scanners.getEmptyableInt();
            if (vitesse != null) o.setVitesse(vitesse);
        } while (o.getVitesse() == null);

        return o;
    }

    private <T> String defaultValue(T value) {
        String result = "";

        if (value != null) {
            result = "[" + value + "]";
        }

        return result;
    }


    public void delete(int id) {
        if (this.repository.delete(id) > 0) {
            System.out.println("Suppression réussie");
        } else {
            System.out.println("Train non trouvé pour l'id '" + id + "'");
        }
    }
}
