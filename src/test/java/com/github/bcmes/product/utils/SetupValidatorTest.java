package com.github.bcmes.product.utils;

import org.assertj.core.api.Assertions;
import javax.validation.ConstraintViolation;
import javax.validation.Validation;
import javax.validation.ValidatorFactory;
import java.util.List;
import java.util.Locale;
import java.util.Set;

public abstract class SetupValidatorTest<T> {

    public void contractValidations(T invalidContract, List<String> expectedMessageError) {
        Locale.setDefault(Locale.ENGLISH);
        ValidatorFactory validatorFactory = Validation.buildDefaultValidatorFactory();
        Set<ConstraintViolation<T>> violations = validatorFactory.getValidator().validate(invalidContract);
        Assertions.assertThat(violations).hasSize(expectedMessageError.size());
        violations.forEach(violation ->
                Assertions.assertThat(expectedMessageError).contains(violation.getMessage())
        );
        validatorFactory.close();
    }
}
