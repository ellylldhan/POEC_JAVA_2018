package com.tactfactory.algotojava.tp9.model;

public class Arme {
    private ArmeType armeType;
    private int action;
    private int degats;

    public Arme(ArmeType armeType) {
        this.armeType = armeType;

        switch (armeType) {
            case Concasseur:
                this.action = 4;
                this.degats = 3;
                break;

            case Pelle:
                this.action = 1;
                this.degats = 2;
                break;
            case Gatling:
                this.action = 6;
                this.degats = 10;
                break;
            case BatteDeCricket:
                this.action = 1;
                this.degats = 1;
                break;
            case Blaster:
                this.action = 3;
                this.degats = 6;
                break;
        }
    }

    public ArmeType getArmeType() {
        return armeType;
    }

    public void setArmeType(ArmeType armeType) {
        this.armeType = armeType;
    }

    public int getAction() {
        return action;
    }

    public void setAction(int action) {
        this.action = action;
    }

    public int getDegats() {
        return degats;
    }

    public void setDegats(int degats) {
        this.degats = degats;
    }
}
