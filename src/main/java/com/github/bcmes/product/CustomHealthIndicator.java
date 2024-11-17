package com.github.bcmes.product;

import org.springframework.boot.actuate.health.Health;
import org.springframework.boot.actuate.health.HealthIndicator;
import org.springframework.stereotype.Component;

@Component
public class CustomHealthIndicator implements HealthIndicator {

    private boolean serviceIsUp = true;

    @Override
    public Health health() {
        if (this.serviceIsUp) {
            return Health.up().withDetail("External Service", "Available").build();
        } else {
            return Health.down().withDetail("External Service", "Unavailable").build();
        }
    }

    public void setServiceIsUp(boolean serviceIsUp) {
        this.serviceIsUp = serviceIsUp;
    }
}