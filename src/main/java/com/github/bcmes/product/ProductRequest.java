package com.github.bcmes.product;

import jakarta.validation.constraints.Size;

public class ProductRequest {
    @Size(min=2, max=100)
    private String description;

    public String getDescription() {
        return description;
    }

    public ProductEntity toEntity() {
        return new ProductEntity(this.getDescription());
    }
}
