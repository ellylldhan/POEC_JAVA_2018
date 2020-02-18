package com.tactfactory.algotojava.tp18bis.model;

import java.util.ArrayList;
import java.util.List;

public class Deck implements Printable {

    protected List<Card> deck;

    public Deck() {
        this.deck = new ArrayList<Card>();
    }

    public List<Card> getDeck() {
        return deck;
    }

    @Override
    public void print() {
        for (Card card : deck) {
            card.print();
        }
    }
}
