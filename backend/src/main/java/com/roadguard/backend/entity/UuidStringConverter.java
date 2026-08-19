package com.roadguard.backend.entity;

import jakarta.persistence.AttributeConverter;
import jakarta.persistence.Converter;

import java.util.UUID;

/**
 * Entities keep their ids/foreign keys typed as {@code String} throughout the
 * app (controllers, DTOs, repositories all use String), but the Postgres
 * columns are native {@code uuid}. {@code @JdbcTypeCode(SqlTypes.UUID)} alone
 * on a String field does NOT do the String<->UUID conversion for you - it
 * just tells Hibernate "the database column is UUID", so at bind time it
 * tries to unwrap the field's value (a String) into a java.util.UUID using
 * StringJavaType, which doesn't know how, and throws:
 *   "Could not convert 'java.lang.String' to 'java.util.UUID' ... to unwrap"
 *
 * This converter does the actual String <-> UUID conversion. Use it
 * TOGETHER WITH @JdbcTypeCode(SqlTypes.UUID) on any String field backed by a
 * uuid column - @Convert supplies the real UUID value, @JdbcTypeCode tells
 * Hibernate/JDBC (and schema validation) that the column type is uuid:
 *
 *   @JdbcTypeCode(SqlTypes.UUID)
 *   @Convert(converter = UuidStringConverter.class)
 *   private String id;
 *
 * Dropping @JdbcTypeCode causes schema-validation failures at startup
 * ("wrong column type ... found uuid, but expecting varchar"), since without
 * it Hibernate assumes a String field maps to varchar. Dropping @Convert
 * brings back the original unwrap crash. Both are required together.
 */
@Converter(autoApply = false)
public class UuidStringConverter implements AttributeConverter<String, UUID> {

    @Override
    public UUID convertToDatabaseColumn(String attribute) {
        return attribute == null ? null : UUID.fromString(attribute);
    }

    @Override
    public String convertToEntityAttribute(UUID dbData) {
        return dbData == null ? null : dbData.toString();
    }
}
