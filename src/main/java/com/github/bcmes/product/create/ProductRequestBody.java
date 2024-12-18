package com.github.bcmes.product.create;

import com.github.bcmes.repository.ProductEntity;
import jakarta.validation.constraints.Size;

public class ProductRequestBody {
    @Size(min=2, max=100, message = "deve ter entre 2 e 100 caracteres")
    private String description;

    public String getDescription() {
        return description;
    }

    public ProductEntity toEntity() {
        return new ProductEntity(this.getDescription());
    }
}
