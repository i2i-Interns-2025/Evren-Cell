package com.i2i.evrencell.aom.dto;

import lombok.Builder;

@Builder
public record PackageDto(
        Integer     packageId,
        String      packageName,
        Integer     amountMinutes,
        double      price,
        Integer     amountData,
        Integer     amountSms,
        Integer     period
) { }
