/*
 *    Copyright 2010-2022 the original author or authors.
 *
 *    Licensed under the Apache License, Version 2.0 (the "License");
 *    you may not use this file except in compliance with the License.
 *    You may obtain a copy of the License at
 *
 *       https://www.apache.org/licenses/LICENSE-2.0
 *
 *    Unless required by applicable law or agreed to in writing, software
 *    distributed under the License is distributed on an "AS IS" BASIS,
 *    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *    See the License for the specific language governing permissions and
 *    limitations under the License.
 */
package org.mybatis.jpetstore.mapper;

import static org.assertj.core.api.Assertions.assertThat;

import java.math.BigDecimal;
import java.util.List;
import java.util.Map;

import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mybatis.jpetstore.domain.LineItem;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit.jupiter.SpringExtension;
import org.springframework.transaction.annotation.Transactional;

@ExtendWith(SpringExtension.class)
@ContextConfiguration(classes = MapperTestContext.class)
@Transactional
class LineItemMapperTest {

  @Autowired
  private LineItemMapper mapper;

  @Autowired
  private JdbcTemplate jdbcTemplate;

  @Test
  void insertLineItem() {
    // given
    LineItem lineItem = new LineItem();
    lineItem.setOrderId(1);
    lineItem.setLineNumber(1);
    lineItem.setItemId("EST-1");
    lineItem.setQuantity(4);
    lineItem.setUnitPrice(BigDecimal.valueOf(100));

    // when
    mapper.insertLineItem(lineItem);

    // then
    Map<String, Object> record = jdbcTemplate.queryForMap("SELECT * FROM lineitem WHERE orderid = ? AND linenum = ?", 1,
        1);
    assertThat(record).hasSize(5).containsEntry("ORDERID", lineItem.getOrderId())
        .containsEntry("LINENUM", lineItem.getLineNumber()).containsEntry("ITEMID", lineItem.getItemId())
        .containsEntry("QUANTITY", lineItem.getQuantity()).containsEntry("UNITPRICE", new BigDecimal("100.00"));

  }

  @Test
  void getLineItemsByOrderId() {
    // given
    LineItem lineItem = new LineItem();
    lineItem.setOrderId(1);
    lineItem.setLineNumber(1);
    lineItem.setItemId("EST-1");
    lineItem.setQuantity(4);
    lineItem.setUnitPrice(BigDecimal.valueOf(100));
    mapper.insertLineItem(lineItem);

    // when
    List<LineItem> lineItems = mapper.getLineItemsByOrderId(1);

    // then
    assertThat(lineItems).hasSize(1);
    assertThat(lineItems.get(0).getOrderId()).isEqualTo(lineItem.getOrderId());
    assertThat(lineItems.get(0).getLineNumber()).isEqualTo(lineItem.getOrderId());
    assertThat(lineItems.get(0).getItemId()).isEqualTo(lineItem.getItemId());
    assertThat(lineItems.get(0).getQuantity()).isEqualTo(lineItem.getQuantity());
    assertThat(lineItems.get(0).getUnitPrice()).isEqualTo(new BigDecimal("100.00"));

  }

}
