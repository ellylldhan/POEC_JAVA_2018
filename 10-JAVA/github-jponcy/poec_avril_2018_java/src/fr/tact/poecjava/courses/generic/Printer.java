package fr.tact.poecjava.courses.generic;


public class Printer<T> {

    private T o;

    public Printer(T o) {
        this.o = o;
    }

    public void execute() {
        System.out.println(this.o);
    }
}
