package snhu.it634.q1657;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.EnableAutoConfiguration;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.autoconfigure.domain.EntityScan;
import org.springframework.boot.autoconfigure.jdbc.DataSourceAutoConfiguration;
import org.springframework.boot.autoconfigure.web.servlet.error.ErrorMvcAutoConfiguration;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.data.jpa.repository.config.EnableJpaRepositories;

/*
Colby Lithyouvong
IT-634-Q1657 Distributed App Development 22TW1
Final Project Part I Submission: Web Application With Annotated Code
*/

@SpringBootApplication(exclude = {DataSourceAutoConfiguration.class })
@EnableAutoConfiguration(exclude = { ErrorMvcAutoConfiguration.class })
@ComponentScan(basePackages = {"snhu.it634.q1657"})
@EntityScan("snhu.it634.q1657.model")
@EnableJpaRepositories("snhu.it634.q1657.repository")
public class FlightsearchApplication {
	
	//main startup class
	public static void main(String[] args) {
		SpringApplication.run(FlightsearchApplication.class, args);
	}
}
