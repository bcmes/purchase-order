package com.github.bcmes.product.create;

import com.fasterxml.jackson.databind.json.JsonMapper;
import com.github.bcmes.repository.ProductEntity;
import com.github.bcmes.repository.ProductRepository;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.test.mock.mockito.MockBean;
import org.springframework.http.MediaType;
import org.springframework.test.web.servlet.MockMvc;

import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.*;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

@SpringBootTest
@AutoConfigureMockMvc
class CreateOneProductControllerTest {

    @Autowired
    private MockMvc mockMvc;

    @MockBean
    private ProductRepository productRepository;

    private final JsonMapper jsonMapper = JsonMapper.builder().build();

    @Test//
    void DADO_nova_requisicao_QUANDO_queremos_cadastrar_um_novo_produto_ENTAO_produto_e_cadastrado_com_sucesso() throws Exception {
        // Arrange
        when(productRepository.saveAndFlush(any(ProductEntity.class))).thenReturn(mock(ProductEntity.class, RETURNS_SMART_NULLS));

        // Act & Assert
        mockMvc.perform(post("/products")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(jsonMapper.writeValueAsString(mock(ProductRequestBody.class, RETURNS_SELF))))
                .andExpect(status().isCreated())
                .andExpect(header().exists("Location"))
                .andExpect(jsonPath("$.id").exists())
                .andExpect(jsonPath("$.description").exists());

        verify(productRepository, times(1)).saveAndFlush(any(ProductEntity.class));
        //Validamos o request:
        //1. host
        //2. header
        //3. body
        //Validamos o response:
        //1. http status
        //2. header
        //3. existencia dos atributos no response body
        //Integracoes:
        //1. funcoes chamadas
    }

    @Test
    void DADO_nova_requisicao_QUANDO_payload_e_invalido_ENTAO_retorna_bad_request() throws Exception {
        // Act & Assert
        mockMvc.perform(post("/products")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content("{\"description\": \"P\"}"))
                .andExpect(status().isBadRequest());

        verify(productRepository, times(0)).saveAndFlush(any(ProductEntity.class));
    }
}
