package com.github.bcmes;

import com.github.bcmes.product.ProductEntity;
import com.github.bcmes.product.ProductRepository;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.test.mock.mockito.MockBean;
import org.springframework.http.MediaType;
import org.springframework.test.web.servlet.MockMvc;

import java.util.Collections;
import java.util.Optional;

import static org.hamcrest.Matchers.is;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.*;

@SpringBootTest
@AutoConfigureMockMvc
class ProductControllerTest {

    @Autowired
    private MockMvc mockMvc;

    @MockBean
    private ProductRepository productRepository;

    @Test
    void getAll_ShouldReturnListOfProducts() throws Exception {
        // Arrange
        ProductEntity product = new ProductEntity(1L, "Product Description");
        when(productRepository.findAll()).thenReturn(Collections.singletonList(product));

        // Act & Assert
        mockMvc.perform(get("/products"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$[0].id", is(1)))
                .andExpect(jsonPath("$[0].description", is("Product Description")));

        verify(productRepository, times(1)).findAll();
    }

    @Test
    void getOne_ShouldReturnProduct_WhenProductExists() throws Exception {
        // Arrange
        Long productId = 1L;
        ProductEntity product = new ProductEntity(productId, "Product Description");
        when(productRepository.findById(productId)).thenReturn(Optional.of(product));

        // Act & Assert
        mockMvc.perform(get("/products/{id}", productId))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.id", is(1)))
                .andExpect(jsonPath("$.description", is("Product Description")));

        verify(productRepository, times(1)).findById(productId);
    }

    @Test
    void addOne_ShouldSaveProductAndReturnCreatedStatus() throws Exception {
        // Arrange
        ProductEntity productEntity = new ProductEntity(1L, "Product Description");
        when(productRepository.saveAndFlush(any(ProductEntity.class))).thenReturn(productEntity);

        // Act & Assert
        mockMvc.perform(post("/products")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content("{\"description\": \"Product Description\"}"))
                .andExpect(status().isCreated())
                .andExpect(header().exists("Location"))
                .andExpect(jsonPath("$.id", is(1)))
                .andExpect(jsonPath("$.description", is("Product Description")));

        verify(productRepository, times(1)).saveAndFlush(any(ProductEntity.class));
    }

    @Test
    void deleteOne_ShouldDeleteProductAndReturnNoContentStatus() throws Exception {
        // Arrange
        Long productId = 1L;
        doNothing().when(productRepository).deleteById(productId);

        // Act & Assert
        mockMvc.perform(delete("/products/{id}", productId))
                .andExpect(status().isNoContent());

        verify(productRepository, times(1)).deleteById(productId);
    }

    @Test
    void alterOne_ShouldUpdateProductAndReturnCreatedStatus() throws Exception {
        // Arrange
        ProductEntity productEntity = new ProductEntity(1L, "Updated Product Description");
        when(productRepository.saveAndFlush(any(ProductEntity.class))).thenReturn(productEntity);

        // Act & Assert
        mockMvc.perform(put("/products")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content("{\"id\": 1, \"description\": \"Updated Product Description\"}"))
                .andExpect(status().isCreated())
                .andExpect(header().exists("Location"))
                .andExpect(jsonPath("$.id", is(1)))
                .andExpect(jsonPath("$.description", is("Updated Product Description")));

        verify(productRepository, times(1)).saveAndFlush(any(ProductEntity.class));
    }

    @Test
    void addOne_ShouldReturnBadRequest_WhenRequestIsInvalid() throws Exception {
        // Act & Assert
        mockMvc.perform(post("/products")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content("{\"description\": \"P\"}"))
                .andExpect(status().isBadRequest());

        verify(productRepository, times(0)).saveAndFlush(any(ProductEntity.class));
    }
}
