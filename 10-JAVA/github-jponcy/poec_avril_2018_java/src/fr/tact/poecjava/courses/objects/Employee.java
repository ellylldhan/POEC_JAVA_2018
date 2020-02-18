package fr.tact.poecjava.courses.objects;

import java.time.LocalDate;

public class Employee extends Person {

    private LocalDate startedAt;

    public Employee(String name, int age) {
        super(name, age);
    }

    @Override
    public boolean register() {
        if (this.startedAt == null) {
            this.startedAt = LocalDate.now();
            return true;
        }

        return false;
    }
}
