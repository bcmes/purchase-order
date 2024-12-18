package com.github.bcmes.product.create;

import com.github.bcmes.product.ProductController;
import com.github.bcmes.repository.ProductEntity;
import com.github.bcmes.repository.ProductRepository;
import jakarta.validation.Valid;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.lang.NonNull;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.support.ServletUriComponentsBuilder;

import java.util.logging.Logger;

@RestController
public class CreateOneProductController implements ProductController {

    private final Logger logger = Logger.getLogger(getClass().getName());
    private final ProductRepository productRepository;

    public CreateOneProductController(ProductRepository productRepository) {
        this.productRepository = productRepository;
    }

    @PostMapping
    public ResponseEntity<ProductEntity> createOne(@Valid @RequestBody @NonNull ProductRequestBody body) {
        logger.info("Recebemos uma requisićão para add um produto na base de dados");
        ProductEntity productEntity = productRepository.saveAndFlush(body.toEntity());
        return ResponseEntity
                .status(HttpStatus.CREATED)
                .location(ServletUriComponentsBuilder.fromCurrentRequest().path("/{id}").buildAndExpand(productEntity.getId()).toUri())
                .body(productEntity);
    }
}
