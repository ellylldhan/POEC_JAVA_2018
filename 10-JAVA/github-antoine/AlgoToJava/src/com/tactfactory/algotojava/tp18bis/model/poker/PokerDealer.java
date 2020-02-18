package com.tactfactory.algotojava.tp18bis.model.poker;

import com.tactfactory.algotojava.tp18bis.model.Card;
import com.tactfactory.algotojava.tp18bis.model.Player;

import java.util.List;

public interface PokerDealer {

    void dealCards(Player player);

    void dealInitialCards(List<Player> players);

    void retreiveCard(Card card);

    void renewDeck();
}
