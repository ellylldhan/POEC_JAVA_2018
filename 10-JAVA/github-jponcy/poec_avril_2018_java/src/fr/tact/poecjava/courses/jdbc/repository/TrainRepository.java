package fr.tact.poecjava.courses.jdbc.repository;

import fr.tact.poecjava.courses.jdbc.entity.TchuTchu;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class TrainRepository implements CrudRepository<TchuTchu, Integer> {

    @Override
    public List<TchuTchu> findAll() {
        List<TchuTchu> result = new ArrayList<>();

        try (ResultSet rs = EntityManager.instance().query("SELECT * FROM train")) {
            while (rs.next()) {
                int trainId = rs.getInt("id");
                String nom = rs.getString("name");
                int vitesse = rs.getInt("speed");
                int poids = rs.getInt("weight");

                result.add(new TchuTchu(trainId, nom, vitesse, poids));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return result;
    }

    @Override
    public Integer create(TchuTchu o) {
        Integer result = null;
        String sql = String.format("INSERT INTO train (name, speed, weight) VALUES ('%s', %d, %d)",
                o.getNom(), o.getVitesse(), o.getPoids());

        try {
            result = EntityManager.instance().update(sql);
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return result;
    }

    @Override
    public TchuTchu find(Integer id) {
        TchuTchu result = null;

        try (ResultSet rs = EntityManager.instance().query("SELECT * FROM train WHERE id = " + id)) {
            if (rs.next()) {
                result = new TchuTchu();

                result.setId(rs.getInt("id"));
                result.setNom(rs.getString("name"));
                result.setVitesse(rs.getInt("speed"));
                result.setPoids(rs.getInt("weight"));
            } else {
                System.out.println("Train non trouvé pour l'id '" + id + "'");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return result;
    }

    @Override
    public Integer update(TchuTchu o) {
        Integer result = null;
        String sql = String.format("UPDATE train SET name='%s', speed=%d, weight=%d WHERE id = %d",
                o.getNom(), o.getVitesse(), o.getPoids(), o.getId());

        try {
            result = EntityManager.instance().update(sql);
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return result;
    }

    @Override
    public Integer delete(Integer id) {
        Integer result = null;
        String sql = "DELETE train WHERE id = " + id;

        try {
            result = EntityManager.instance().update(sql);
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return result;
    }
}
