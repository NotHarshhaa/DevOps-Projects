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
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;

import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mybatis.jpetstore.domain.Order;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit.jupiter.SpringExtension;
import org.springframework.transaction.annotation.Transactional;

@ExtendWith(SpringExtension.class)
@ContextConfiguration(classes = MapperTestContext.class)
@Transactional
class OrderMapperTest {

  @Autowired
  private OrderMapper mapper;

  @Autowired
  private JdbcTemplate jdbcTemplate;

  @Test
  void insertOrder() {
    // given
    Order order = new Order();
    order.setOrderId(1);
    order.setOrderDate(java.sql.Timestamp.valueOf(LocalDateTime.of(2018, 12, 31, 23, 59, 59)));
    order.setUsername("j2ee");
    order.setCardType("Visa");
    order.setCreditCard("1234 5678 9012 3456");
    order.setExpiryDate("06/2022");
    order.setCourier("Courier");
    order.setLocale("ja");
    order.setTotalPrice(new BigDecimal("2000.05"));
    order.setBillAddress1("Bill Address1");
    order.setBillAddress2("Bill Address2");
    order.setBillCity("Bill City");
    order.setBillState("Bill State");
    order.setBillCountry("USA");
    order.setBillZip("80001");
    order.setBillToFirstName("Bill First Name");
    order.setBillToLastName("Bill Last Name");
    order.setShipAddress1("Ship Address1");
    order.setShipAddress2("Ship Address2");
    order.setShipCity("Ship City");
    order.setShipState("Ship State");
    order.setShipCountry("JPN");
    order.setShipZip("70001");
    order.setShipToFirstName("Ship First Name");
    order.setShipToLastName("Ship Last Name");

    // when
    mapper.insertOrder(order);

    // then
    Map<String, Object> record = jdbcTemplate.queryForMap("SELECT * FROM orders WHERE orderid = ?", 1);
    assertThat(record).hasSize(25).containsEntry("ORDERID", order.getOrderId())
        .containsEntry("USERID", order.getUsername())
        .containsEntry("ORDERDATE", java.sql.Date.valueOf(LocalDate.of(2018, 12, 31)))
        .containsEntry("SHIPADDR1", order.getShipAddress1()).containsEntry("SHIPADDR2", order.getShipAddress2())
        .containsEntry("SHIPCITY", order.getShipCity()).containsEntry("SHIPSTATE", order.getShipState())
        .containsEntry("SHIPZIP", order.getShipZip()).containsEntry("SHIPCOUNTRY", order.getShipCountry())
        .containsEntry("SHIPTOFIRSTNAME", order.getShipToFirstName())
        .containsEntry("SHIPTOLASTNAME", order.getShipToLastName()).containsEntry("BILLADDR1", order.getBillAddress1())
        .containsEntry("BILLADDR2", order.getBillAddress2()).containsEntry("BILLCITY", order.getBillCity())
        .containsEntry("BILLSTATE", order.getBillState()).containsEntry("BILLZIP", order.getBillZip())
        .containsEntry("BILLCOUNTRY", order.getBillCountry())
        .containsEntry("BILLTOFIRSTNAME", order.getBillToFirstName())
        .containsEntry("BILLTOLASTNAME", order.getBillToLastName()).containsEntry("COURIER", order.getCourier())
        .containsEntry("TOTALPRICE", order.getTotalPrice()).containsEntry("CREDITCARD", order.getCreditCard())
        .containsEntry("EXPRDATE", order.getExpiryDate()).containsEntry("CARDTYPE", order.getCardType())
        .containsEntry("LOCALE", order.getLocale());

  }

  @Test
  void insertOrderStatus() {
    // given
    Order order = new Order();
    order.setOrderId(1);
    order.setOrderDate(java.sql.Timestamp.valueOf(LocalDateTime.of(2018, 12, 31, 23, 59, 59)));
    order.setStatus("OK");

    // when
    mapper.insertOrderStatus(order);

    // then
    Map<String, Object> record = jdbcTemplate.queryForMap("SELECT * FROM orderstatus WHERE orderid = ?", 1);
    assertThat(record).hasSize(4).containsEntry("ORDERID", order.getOrderId())
        .containsEntry("LINENUM", order.getOrderId())
        .containsEntry("TIMESTAMP", java.sql.Date.valueOf(LocalDate.of(2018, 12, 31)))
        .containsEntry("STATUS", order.getStatus());

  }

  @Test
  void getOrdersByUsername() {
    // given
    Order newOrder = new Order();
    newOrder.setOrderId(1);
    newOrder.setOrderDate(java.sql.Timestamp.valueOf(LocalDateTime.of(2018, 12, 31, 23, 59, 59)));
    newOrder.setStatus("OK");
    newOrder.setUsername("j2ee");
    newOrder.setCardType("Visa");
    newOrder.setCreditCard("1234 5678 9012 3456");
    newOrder.setExpiryDate("06/2022");
    newOrder.setCourier("Courier");
    newOrder.setLocale("ja");
    newOrder.setTotalPrice(new BigDecimal("2000.05"));
    newOrder.setBillAddress1("Bill Address1");
    newOrder.setBillAddress2("Bill Address2");
    newOrder.setBillCity("Bill City");
    newOrder.setBillState("Bill State");
    newOrder.setBillCountry("USA");
    newOrder.setBillZip("80001");
    newOrder.setBillToFirstName("Bill First Name");
    newOrder.setBillToLastName("Bill Last Name");
    newOrder.setShipAddress1("Ship Address1");
    newOrder.setShipAddress2("Ship Address2");
    newOrder.setShipCity("Ship City");
    newOrder.setShipState("Ship State");
    newOrder.setShipCountry("JPN");
    newOrder.setShipZip("70001");
    newOrder.setShipToFirstName("Ship First Name");
    newOrder.setShipToLastName("Ship Last Name");
    mapper.insertOrder(newOrder);
    mapper.insertOrderStatus(newOrder);

    // when
    List<Order> orders = mapper.getOrdersByUsername("j2ee");

    // then
    assertThat(orders).hasSize(1);
    assertThat(orders.get(0).getOrderId()).isEqualTo(newOrder.getOrderId());
    assertThat(orders.get(0).getOrderDate()).isEqualTo(java.sql.Date.valueOf(LocalDate.of(2018, 12, 31)));
    assertThat(orders.get(0).getCardType()).isEqualTo(newOrder.getCardType());
    assertThat(orders.get(0).getCreditCard()).isEqualTo(newOrder.getCreditCard());
    assertThat(orders.get(0).getExpiryDate()).isEqualTo(newOrder.getExpiryDate());
    assertThat(orders.get(0).getCourier()).isEqualTo(newOrder.getCourier());
    assertThat(orders.get(0).getLocale()).isEqualTo(newOrder.getLocale());
    assertThat(orders.get(0).getTotalPrice()).isEqualTo(newOrder.getTotalPrice());
    assertThat(orders.get(0).getBillAddress1()).isEqualTo(newOrder.getBillAddress1());
    assertThat(orders.get(0).getBillAddress2()).isEqualTo(newOrder.getBillAddress2());
    assertThat(orders.get(0).getBillCity()).isEqualTo(newOrder.getBillCity());
    assertThat(orders.get(0).getBillState()).isEqualTo(newOrder.getBillState());
    assertThat(orders.get(0).getBillCountry()).isEqualTo(newOrder.getBillCountry());
    assertThat(orders.get(0).getBillZip()).isEqualTo(newOrder.getBillZip());
    assertThat(orders.get(0).getBillToFirstName()).isEqualTo(newOrder.getBillToFirstName());
    assertThat(orders.get(0).getBillToLastName()).isEqualTo(newOrder.getBillToLastName());
    assertThat(orders.get(0).getShipAddress1()).isEqualTo(newOrder.getShipAddress1());
    assertThat(orders.get(0).getShipAddress2()).isEqualTo(newOrder.getShipAddress2());
    assertThat(orders.get(0).getShipCity()).isEqualTo(newOrder.getShipCity());
    assertThat(orders.get(0).getShipState()).isEqualTo(newOrder.getShipState());
    assertThat(orders.get(0).getShipCountry()).isEqualTo(newOrder.getShipCountry());
    assertThat(orders.get(0).getShipZip()).isEqualTo(newOrder.getShipZip());
    assertThat(orders.get(0).getShipToFirstName()).isEqualTo(newOrder.getShipToFirstName());
    assertThat(orders.get(0).getShipToLastName()).isEqualTo(newOrder.getShipToLastName());
  }

  @Test
  void getOrder() {
    // given
    Order newOrder = new Order();
    newOrder.setOrderId(1);
    newOrder.setOrderDate(java.sql.Timestamp.valueOf(LocalDateTime.of(2018, 12, 31, 23, 59, 59)));
    newOrder.setStatus("OK");
    newOrder.setUsername("j2ee");
    newOrder.setCardType("Visa");
    newOrder.setCreditCard("1234 5678 9012 3456");
    newOrder.setExpiryDate("06/2022");
    newOrder.setCourier("Courier");
    newOrder.setLocale("ja");
    newOrder.setTotalPrice(new BigDecimal("2000.05"));
    newOrder.setBillAddress1("Bill Address1");
    newOrder.setBillAddress2("Bill Address2");
    newOrder.setBillCity("Bill City");
    newOrder.setBillState("Bill State");
    newOrder.setBillCountry("USA");
    newOrder.setBillZip("80001");
    newOrder.setBillToFirstName("Bill First Name");
    newOrder.setBillToLastName("Bill Last Name");
    newOrder.setShipAddress1("Ship Address1");
    newOrder.setShipAddress2("Ship Address2");
    newOrder.setShipCity("Ship City");
    newOrder.setShipState("Ship State");
    newOrder.setShipCountry("JPN");
    newOrder.setShipZip("70001");
    newOrder.setShipToFirstName("Ship First Name");
    newOrder.setShipToLastName("Ship Last Name");
    mapper.insertOrder(newOrder);
    mapper.insertOrderStatus(newOrder);

    // when
    Order order = mapper.getOrder(1);

    // then
    assertThat(order.getOrderId()).isEqualTo(newOrder.getOrderId());
    assertThat(order.getOrderDate()).isEqualTo(java.sql.Date.valueOf(LocalDate.of(2018, 12, 31)));
    assertThat(order.getCardType()).isEqualTo(newOrder.getCardType());
    assertThat(order.getCreditCard()).isEqualTo(newOrder.getCreditCard());
    assertThat(order.getExpiryDate()).isEqualTo(newOrder.getExpiryDate());
    assertThat(order.getCourier()).isEqualTo(newOrder.getCourier());
    assertThat(order.getLocale()).isEqualTo(newOrder.getLocale());
    assertThat(order.getTotalPrice()).isEqualTo(newOrder.getTotalPrice());
    assertThat(order.getBillAddress1()).isEqualTo(newOrder.getBillAddress1());
    assertThat(order.getBillAddress2()).isEqualTo(newOrder.getBillAddress2());
    assertThat(order.getBillCity()).isEqualTo(newOrder.getBillCity());
    assertThat(order.getBillState()).isEqualTo(newOrder.getBillState());
    assertThat(order.getBillCountry()).isEqualTo(newOrder.getBillCountry());
    assertThat(order.getBillZip()).isEqualTo(newOrder.getBillZip());
    assertThat(order.getBillToFirstName()).isEqualTo(newOrder.getBillToFirstName());
    assertThat(order.getBillToLastName()).isEqualTo(newOrder.getBillToLastName());
    assertThat(order.getShipAddress1()).isEqualTo(newOrder.getShipAddress1());
    assertThat(order.getShipAddress2()).isEqualTo(newOrder.getShipAddress2());
    assertThat(order.getShipCity()).isEqualTo(newOrder.getShipCity());
    assertThat(order.getShipState()).isEqualTo(newOrder.getShipState());
    assertThat(order.getShipCountry()).isEqualTo(newOrder.getShipCountry());
    assertThat(order.getShipZip()).isEqualTo(newOrder.getShipZip());
    assertThat(order.getShipToFirstName()).isEqualTo(newOrder.getShipToFirstName());
    assertThat(order.getShipToLastName()).isEqualTo(newOrder.getShipToLastName());
  }

}
