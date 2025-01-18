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
package org.mybatis.jpetstore.web.actions;

import static org.assertj.core.api.Assertions.assertThat;

import org.junit.jupiter.api.Test;

class OrderActionBeanTest {

  // Test written by Diffblue Cover.
  @Test
  void getOrderListOutputNull() {

    // Arrange
    final OrderActionBean orderActionBean = new OrderActionBean();

    // Act and Assert result
    assertThat(orderActionBean.getOrderList()).isNull();

  }

  // Test written by Diffblue Cover.
  @Test
  void isShippingAddressRequiredOutputFalse() {

    // Arrange
    final OrderActionBean orderActionBean = new OrderActionBean();

    // Act and Assert result
    assertThat(orderActionBean.isShippingAddressRequired()).isFalse();

  }

  // Test written by Diffblue Cover.
  @Test
  void constructorOutputNotNull() {

    // Act, creating object to test constructor
    final OrderActionBean actual = new OrderActionBean();

    // Assert result
    assertThat(actual).isNotNull().isNotNull();
    assertThat(actual.getContext()).isNull();

  }

  // Test written by Diffblue Cover.
  @Test
  void isConfirmedOutputFalse() {

    // Arrange
    final OrderActionBean orderActionBean = new OrderActionBean();

    // Act and Assert result
    assertThat(orderActionBean.isConfirmed()).isFalse();

  }
}
