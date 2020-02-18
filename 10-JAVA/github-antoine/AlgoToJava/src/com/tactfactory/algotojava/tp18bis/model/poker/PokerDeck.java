package com.tactfactory.algotojava.tp18bis.model.poker;

import com.tactfactory.algotojava.tp18bis.model.*;

import java.util.Random;

public class PokerDeck extends Deck implements Poker {

    public PokerDeck() {
        super();
        initPokerDeck();
    }

    @Override
    public void initPokerDeck() {
        for (int i = 0; i < Coeur.POKER_DECK.length; i++) {
            this.deck
                    .add(new Card(new CardValue(Coeur.POKER_DECK[i][0], Coeur.POKER_DECK[i][1], Integer.parseInt(Coeur.POKER_DECK[i][2])),
                            new Coeur()));
        }

        for (int i = 0; i < Carreau.POKER_DECK.length; i++) {
            this.deck
                    .add(new Card(new CardValue(Carreau.POKER_DECK[i][0], Carreau.POKER_DECK[i][1], Integer.parseInt(Carreau.POKER_DECK[i][2])),
                            new Carreau()));
        }

        for (int i = 0; i < Pique.POKER_DECK.length; i++) {
            this.deck
                    .add(new Card(new CardValue(Pique.POKER_DECK[i][0], Pique.POKER_DECK[i][1], Integer.parseInt(Pique.POKER_DECK[i][2])),
                            new Pique()));
        }

        for (int i = 0; i < Trefle.POKER_DECK.length; i++) {
            this.deck
                    .add(new Card(new CardValue(Trefle.POKER_DECK[i][0], Trefle.POKER_DECK[i][1], Integer.parseInt(Trefle.POKER_DECK[i][2])),
                            new Trefle()));
        }
    }

    @Override
    public Card dealACard() {
        Card result = null;

        if (deck.size() > 0) {
            Random rand = new Random();
            int cardToPick = rand.nextInt(deck.size()) % deck.size();
            result = deck.get(cardToPick);

            // Remind to remove picked card.
            deck.remove(cardToPick);
        }

        return result;
    }
}
