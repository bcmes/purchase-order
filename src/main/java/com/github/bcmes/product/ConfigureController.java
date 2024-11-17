package com.github.bcmes.product;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.logging.Logger;

@RestController
@RequestMapping("/configs")
public class ConfigureController {

    private final Logger logger = Logger.getLogger(ConfigureController.class.getName());
    private final CustomHealthIndicator healthIndicator;

    public ConfigureController(CustomHealthIndicator healthIndicator) {
        this.healthIndicator = healthIndicator;
    }

    @GetMapping
    public ResponseEntity<Void> alterStatusApp(@RequestParam(name = "status", defaultValue = "false") Boolean status) {
        String message = status ? "ativar" : "desativar";
        logger.info(String.format("Recebemos a requisićão para %s a aplicaćão.", message));
        healthIndicator.setServiceIsUp(status);
        return ResponseEntity.noContent().build();
    }
}
