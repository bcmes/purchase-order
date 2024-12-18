package com.github.bcmes.product.update;

import com.github.bcmes.repository.ProductEntity;
import com.github.bcmes.repository.ProductRepository;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.lang.NonNull;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.support.ServletUriComponentsBuilder;

import java.util.logging.Logger;

@RestController
@RequestMapping("/products")
public class UpdatePartiallyOneProductController {

    private final Logger logger = Logger.getLogger(getClass().getName());
    private final ProductRepository productRepository;

    public UpdatePartiallyOneProductController(ProductRepository productRepository) {
        this.productRepository = productRepository;
    }

    @PutMapping
    public ResponseEntity<ProductEntity> updatePartially(@RequestBody @NonNull ProductRequestBody body) {
        logger.info("Recebemos uma requisićão para alterar o produto");
        ProductEntity productEntity = productRepository.saveAndFlush(body.toEntity());
        return ResponseEntity
                .status(HttpStatus.CREATED)
                .location(ServletUriComponentsBuilder.fromCurrentRequest().path("/{id}").buildAndExpand(productEntity.getId()).toUri())
                .body(productEntity);
    }
}
