package com.github.bcmes.product;

import jakarta.validation.Valid;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.lang.NonNull;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.support.ServletUriComponentsBuilder;
import java.util.List;
import java.util.Optional;
import java.util.logging.Logger;

@RestController
@RequestMapping("/products")
public class ProductController {

    private final Logger logger = Logger.getLogger(ProductController.class.getName());
    private final ProductRepository productRepository;


    public ProductController(ProductRepository productRepository) {
        this.productRepository = productRepository;
    }

    @GetMapping
    public List<ProductEntity> getAll() {
        logger.info("Recebemos a requisićão para listar todos os produtos da base de dados");
        return productRepository.findAll();
    }

    @GetMapping("/{id}")
    public ProductEntity getOne(@PathVariable Long id) {
        logger.info("Recebemos uma requisićão para recuperar o produto de id " + id);
        Optional<ProductEntity> product = productRepository.findById(id);
        return product.orElseThrow();
    }

    @PostMapping
    public ResponseEntity<ProductEntity> addOne(@Valid @RequestBody @NonNull ProductRequest body) {
        logger.info("Recebemos uma requisićão para add um produto na base de dados");
        ProductEntity productEntity = productRepository.saveAndFlush(body.toEntity());
        return ResponseEntity
                .status(HttpStatus.CREATED)
                .location(ServletUriComponentsBuilder.fromCurrentRequest().path("/{id}").buildAndExpand(productEntity.getId()).toUri())
                .body(productEntity);
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteOne(@PathVariable Long id) {
        logger.info("Recebemos uma requisićão para deletar um produto da base de dados de id " + id);
        productRepository.deleteById(id);
        return ResponseEntity.status(HttpStatus.NO_CONTENT).build();
    }

    @PutMapping
    public ResponseEntity<ProductEntity> alterOne(@RequestBody @NonNull ProductPutRequest body) {
        logger.info("Recebemos uma requisićão para alterar o produto");
        ProductEntity productEntity = productRepository.saveAndFlush(body.toEntity());
        return ResponseEntity
                .status(HttpStatus.CREATED)
                .location(ServletUriComponentsBuilder.fromCurrentRequest().path("/{id}").buildAndExpand(productEntity.getId()).toUri())
                .body(productEntity);
    }
}
