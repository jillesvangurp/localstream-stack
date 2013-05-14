package com.localstream.example;

import java.util.concurrent.atomic.AtomicBoolean;
import java.util.concurrent.locks.Lock;
import java.util.concurrent.locks.ReentrantLock;

import org.springframework.context.ApplicationContext;
import org.springframework.context.annotation.AnnotationConfigApplicationContext;

/**
 * Simple class that creates a singleton application context that can be accessed from anywhere in the jvm.
 *
 * The initialization of the context is synchronized so it happens only once.
 *
 */
public class SpringContextLoader {
    private static AnnotationConfigApplicationContext context = null;

    private static final AtomicBoolean contextCreated = new AtomicBoolean(false);

    private static final Lock LOCK = new ReentrantLock();

    public static ApplicationContext context() {
        if(contextCreated.get()) {
            return context;
        } else {
            LOCK.lock();
            try {

                if(!contextCreated.get()) {
                    context = new AnnotationConfigApplicationContext(SpringConfig.class);
                    contextCreated.set(true);
                }
                return context;
            } finally {
                LOCK.unlock();
            }
        }
    }
}
