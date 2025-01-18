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
package org.mybatis.jpetstore.domain;

import static org.assertj.core.api.Assertions.assertThat;

import java.math.BigDecimal;
import java.util.Date;

import org.junit.jupiter.api.Test;

class OrderTest {

  @Test
  void initOrder() {
    // given
    Account account = new Account();
    account.setUsername("mybatis");
    account.setEmail("mybatis@example.com");
    account.setFirstName("My");
    account.setLastName("Batis");
    account.setStatus("NG");
    account.setAddress1("Address 1");
    account.setAddress2("Address 2");
    account.setCity("City");
    account.setState("ST");
    account.setZip("99001");
    account.setCountry("JPN");
    account.setPhone("09012345678");

    Cart cart = new Cart();
    Item item = new Item();
    item.setItemId("I01");
    item.setListPrice(new BigDecimal("2.05"));
    cart.addItem(item, true);
    cart.addItem(item, true);

    Order order = new Order();

    // when
    order.initOrder(account, cart);

    // then
    assertThat(order.getUsername()).isSameAs(account.getUsername());
    assertThat(order.getOrderDate()).isBeforeOrEqualsTo(new Date());
    assertThat(order.getShipAddress1()).isEqualTo(account.getAddress1());
    assertThat(order.getShipAddress2()).isEqualTo(account.getAddress2());
    assertThat(order.getShipCity()).isEqualTo(account.getCity());
    assertThat(order.getShipState()).isEqualTo(account.getState());
    assertThat(order.getShipCountry()).isEqualTo(account.getCountry());
    assertThat(order.getShipZip()).isEqualTo(account.getZip());
    assertThat(order.getBillAddress1()).isEqualTo(account.getAddress1());
    assertThat(order.getBillAddress2()).isEqualTo(account.getAddress2());
    assertThat(order.getBillCity()).isEqualTo(account.getCity());
    assertThat(order.getBillState()).isEqualTo(account.getState());
    assertThat(order.getBillCountry()).isEqualTo(account.getCountry());
    assertThat(order.getBillZip()).isEqualTo(account.getZip());
    assertThat(order.getTotalPrice()).isEqualTo(new BigDecimal("4.10"));
    assertThat(order.getCreditCard()).isEqualTo("999 9999 9999 9999");
    assertThat(order.getCardType()).isEqualTo("Visa");
    assertThat(order.getExpiryDate()).isEqualTo("12/03");
    assertThat(order.getCourier()).isEqualTo("UPS");
    assertThat(order.getLocale()).isEqualTo("CA");
    assertThat(order.getStatus()).isEqualTo("P");
    assertThat(order.getLineItems()).hasSize(1);
    assertThat(order.getLineItems().get(0).getItem()).isSameAs(item);
    assertThat(order.getLineItems().get(0).getLineNumber()).isEqualTo(1);
    assertThat(order.getLineItems().get(0).getItemId()).isEqualTo("I01");
    assertThat(order.getLineItems().get(0).getUnitPrice()).isEqualTo(new BigDecimal("2.05"));
    assertThat(order.getLineItems().get(0).getQuantity()).isEqualTo(2);
    assertThat(order.getLineItems().get(0).getTotal()).isEqualTo(new BigDecimal("4.10"));
  }

}
