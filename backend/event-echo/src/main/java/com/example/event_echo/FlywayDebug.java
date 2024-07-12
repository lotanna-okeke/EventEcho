//package com.example.event_echo;
//
//import org.flywaydb.core.Flyway;
//import org.flywaydb.core.api.configuration.FluentConfiguration;
//
//public class FlywayDebug {
//    public static void main(String[] args) {
//        try {
//            Class.forName("org.postgresql.Driver");
//        } catch (ClassNotFoundException e) {
//            System.out.println("PostgreSQL JDBC Driver not found.");
//            e.printStackTrace();
//            return;
//        }
//
//        FluentConfiguration configuration = Flyway.configure()
//                .dataSource("jdbc:postgresql://127.0.0.1/event_echo_db", "event_echo_user", "secret")
//                .connectRetries(10)
//                .baselineOnMigrate(true)
//                .group(true)
//                .outOfOrder(true)
//                .loadDefaultConfigurationFiles(String.valueOf(true))
//                .failOnMissingLocations(true)
//                .validateOnMigrate(true);
//
//        Flyway flyway = new Flyway(configuration);
//
//        try {
//            flyway.migrate();
//            System.out.println("Migration successful!");
//        } catch (Exception e) {
//            System.out.println("Migration failed!");
//            e.printStackTrace();
//        }
//    }
//}