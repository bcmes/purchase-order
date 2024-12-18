package com.github.bcmes.product.create;

import com.github.bcmes.product.utils.SetupValidatorTest;
import org.junit.jupiter.params.ParameterizedTest;
import org.junit.jupiter.params.provider.Arguments;
import org.junit.jupiter.params.provider.MethodSource;
import java.util.List;
import java.util.stream.Stream;

public class ProductRequestBodyTest extends SetupValidatorTest<ProductRequestBody> {

    private static Stream<Arguments> failureConditions() {
        return Stream.of(
                Arguments.arguments(
                        new ProductRequestBody(),
                        List.of("must match INTERNAL")
                )
        );
    }

    @ParameterizedTest
    @MethodSource("failureConditions")
    void givenContract(ProductRequestBody invalidContract, List<String> expectedMessageError) {
        super.contractValidations(invalidContract, expectedMessageError);
    }
}
