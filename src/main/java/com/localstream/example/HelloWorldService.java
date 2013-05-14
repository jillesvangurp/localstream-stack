package com.localstream.example;

import static com.github.jsonj.tools.JsonBuilder.object;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.github.jsonj.JsonObject;

public class HelloWorldService {
    private static final Logger LOG = LoggerFactory.getLogger(HelloWorldService.class);

    public JsonObject sayHi(String name) {
        LOG.info("sayHi " + name);
        return object().put("message", "Hi " + name).get();
    }

    public boolean hasLogConfig() {
        LOG.info("hasLogConfig");
        return this.getClass().getClassLoader().getResource("logback.xml") != null;
    }

    public static void main(String[] args) {
        LOG.info("test message");
    }


}
