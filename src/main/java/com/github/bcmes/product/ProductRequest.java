package com.github.bcmes.product;

public class ProductRequest {
    private String description;

    public String getDescription() {
        return description;
    }

    public ProductEntity toEntity() {
        return new ProductEntity(this.getDescription());
    }
}
