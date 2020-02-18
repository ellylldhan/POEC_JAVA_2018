package fr.tact.poecjava.courses.jdbc.repository;

import com.mysql.jdbc.jdbc2.optional.MysqlDataSource;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.Collections;
import java.util.Map;

public class EntityManager {

    private static volatile EntityManager instance;

    private Map<Class<?>, CrudRepository<?, ?>> repositories;

    private Connection connection;

    private EntityManager() {
        this.initConnection();
        this.repositories = Collections.singletonMap(TrainRepository.class, new TrainRepository());
    }

    public static synchronized final EntityManager instance() {
        if (EntityManager.instance == null) {
            EntityManager.instance = new EntityManager();
        }

        return EntityManager.instance;
    }

    public static <T extends CrudRepository<?, ?>> T repository(Class<?> clazz) {
        return EntityManager.instance().getRepository(clazz);
    }

    @Override
    protected void finalize() throws Throwable {
        super.finalize();

        this.connection.close();
    }

    @SuppressWarnings("unchecked")
    public <T extends CrudRepository<?, ?>> T getRepository(Class<?> clazz) {
        return (T) this.repositories.get(clazz);
    }

    public ResultSet query(String sql) throws SQLException {
        Statement st = this.connection.createStatement();
        ResultSet result = st.executeQuery(sql);

        return result;
    }

    public int update(String sql) throws SQLException {
        Statement st = this.connection.createStatement();
        int result = st.executeUpdate(sql);

        return result;
    }

    private final void initConnection() {
        MysqlDataSource dataSource = new MysqlDataSource();

        // Add settings about the data source.
        dataSource.setServerName("127.0.0.1");
        dataSource.setUser("root");
        dataSource.setPassword("jepreferepostgres");
        dataSource.setDatabaseName("poec_tchu_tchu");

        // Create the connection to our database.
        try {
            this.connection = dataSource.getConnection();
        } catch (SQLException e) {
            e.printStackTrace();
            System.err.println("Problème avec la base de données : " + e.getMessage());
            System.exit(-2);
        }
    }
}
