package fr.tact.poecjava.courses.jdbc.repository;

import java.util.List;

public interface CrudRepository<T, ID> {
    List<T> findAll();

    Integer create(T o);

    T find(ID id);

    Integer update(T o);

    Integer delete(ID id);
}
