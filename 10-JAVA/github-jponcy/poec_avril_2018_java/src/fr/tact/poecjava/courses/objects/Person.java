package fr.tact.poecjava.courses.objects;

public abstract class Person implements People {

    private String name;

    private int age;

    public Person(String name, int age) {
        this.name = name;
        this.age = age;
    }

    @Override
    public String toString() {
        return this.name + " a " + this.age + " ans";
    }
}
