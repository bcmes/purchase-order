package com.github.bcmes.product.read;

import com.github.bcmes.repository.ProductEntity;
import com.github.bcmes.repository.ProductRepository;
import org.springframework.web.bind.annotation.*;

import java.util.Optional;
import java.util.logging.Logger;

@RestController
@RequestMapping("/products")
public class ReadOneProductController {

    private final Logger logger = Logger.getLogger(getClass().getName());
    private final ProductRepository productRepository;

    public ReadOneProductController(ProductRepository productRepository) {
        this.productRepository = productRepository;
    }

    @GetMapping("/{id}")
    public ProductEntity readOne(@PathVariable Long id) {
        logger.info("Recebemos uma requisićão para recuperar o produto de id " + id);
        Optional<ProductEntity> product = productRepository.findById(id);
        return product.orElseThrow();
    }
}
