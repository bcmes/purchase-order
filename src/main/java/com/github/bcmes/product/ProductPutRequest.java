package com.github.bcmes.product;

public class ProductPutRequest {
    private Long id;
    private String description;

    public Long getId() {
        return id;
    }

    public String getDescription() {
        return description;
    }

    public ProductEntity toEntity() {
        return new ProductEntity(this.getId(), this.getDescription());
    }
}
