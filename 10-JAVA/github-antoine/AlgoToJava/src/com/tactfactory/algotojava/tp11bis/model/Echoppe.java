package com.tactfactory.algotojava.tp11bis.model;

import com.tactfactory.algotojava.tp11bis.model.produits.*;

import java.util.ArrayList;
import java.util.List;

public class Echoppe {

    List<Produit> produits = new ArrayList<Produit>();


    public Echoppe() {

        for (int i = 0; i < 10; i++) {
            produits.add(new Fruit(2, "pomme"));
            produits.add(new Legume(3, "salade"));
            produits.add(new Jouet(10, "lego"));
            produits.add(new Soda(2, "coca cola"));
            produits.add(new Viande(10, "steack"));
        }
    }

    public List<Produit> getProduits() {
        return produits;
    }

    public void setProduits(List<Produit> echoppe) {
        this.produits = echoppe;
    }
}
