package com.github.bcmes.product.delete;

import com.github.bcmes.repository.ProductRepository;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.logging.Logger;

@RestController
@RequestMapping("/products")
public class DeleteOneProductController {

    private final Logger logger = Logger.getLogger(getClass().getName());
    private final ProductRepository productRepository;


    public DeleteOneProductController(ProductRepository productRepository) {
        this.productRepository = productRepository;
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteOne(@PathVariable Long id) {
        logger.info("Recebemos uma requisićão para deletar um produto da base de dados de id " + id);
        productRepository.deleteById(id);
        return ResponseEntity.status(HttpStatus.NO_CONTENT).build();
    }
}
