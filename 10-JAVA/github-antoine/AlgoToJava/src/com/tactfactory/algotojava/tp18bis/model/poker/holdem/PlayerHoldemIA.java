package com.tactfactory.algotojava.tp18bis.model.poker.holdem;

import com.tactfactory.algotojava.tp18bis.model.poker.PokerActions;

import java.util.Random;

public class PlayerHoldemIA extends PlayerHoldem {

    public PlayerHoldemIA(double money, String name) {
        super(money, name);
    }

    @Override
    public PokerActions call() {
        Random rand = new Random();
        PokerActions choice = PokerActions.values()[rand.nextInt(PokerActions.values().length)
                % (PokerActions.values().length - 1)];

        return choice;
    }
}
