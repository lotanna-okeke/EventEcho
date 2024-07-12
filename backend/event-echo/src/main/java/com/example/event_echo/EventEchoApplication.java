package com.example.event_echo;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication
public class EventEchoApplication {

	public static void main(String[] args) {

		SpringApplication.run(EventEchoApplication.class, args);

	}

}

//package com.example.event_echo;
//
//import org.flywaydb.core.Flyway;
//import org.springframework.boot.SpringApplication;
//import org.springframework.boot.autoconfigure.SpringBootApplication;
//import org.springframework.context.ConfigurableApplicationContext;
//
//@SpringBootApplication
//public class EventEchoApplication {
//
//	public static void main(String[] args) {
//
//		ConfigurableApplicationContext context = SpringApplication.run(EventEchoApplication.class, args);
//
//		// Run Flyway repair
//		Flyway flyway = Flyway.configure()
//				.dataSource("jdbc:postgresql://127.0.0.1/event_echo_db", "event_echo_user", "secret")
//				.load();
//		flyway.repair();
//	}
//
//}
