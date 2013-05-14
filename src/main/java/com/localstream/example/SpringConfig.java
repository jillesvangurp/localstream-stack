package com.localstream.example;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class SpringConfig {
    @Bean
    public HelloWorldService helloWorldService() {
        return new HelloWorldService();
    }
}
