package com.github.bcmes.product.read;

import com.github.bcmes.repository.ProductEntity;
import com.github.bcmes.repository.ProductRepository;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.logging.Logger;

@RestController
@RequestMapping("/products")
public class ReadAllProductController {

    private final Logger logger = Logger.getLogger(getClass().getName());
    private final ProductRepository productRepository;

    public ReadAllProductController(ProductRepository productRepository) {
        this.productRepository = productRepository;
    }

    @GetMapping
    public List<ProductEntity> getAll() {
        logger.info("Recebemos a requisićão para listar todos os produtos da base de dados");
        return productRepository.findAll();
    }
}
