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
import org.mybatis.jpetstore.domain.Account;

class AccountActionBeanTest {

  // Test written by Diffblue Cover.
  @Test
  void getMyListOutputNull() {

    // Arrange
    final AccountActionBean accountActionBean = new AccountActionBean();

    // Act and Assert result
    assertThat(accountActionBean.getMyList()).isNull();

  }

  // Test written by Diffblue Cover.
  @Test
  void constructorOutputNotNull() {

    // Act, creating object to test constructor
    final AccountActionBean actual = new AccountActionBean();

    // Assert result
    assertThat(actual).isNotNull();
    assertThat(actual.getContext()).isNull();

  }

  // Test written by Diffblue Cover.
  @Test
  void getPasswordOutputNull() {

    // Arrange
    final AccountActionBean accountActionBean = new AccountActionBean();

    // Act and Assert result
    assertThat(accountActionBean.getPassword()).isNull();

  }

  // Test written by Diffblue Cover.
  @Test
  void isAuthenticatedOutputFalse() {

    // Arrange
    final AccountActionBean accountActionBean = new AccountActionBean();

    // Act and Assert result
    assertThat(accountActionBean.isAuthenticated()).isFalse();

  }

  // Test written by Diffblue Cover.
  @Test
  void getUsernameOutputNull() {

    // Arrange
    final AccountActionBean accountActionBean = new AccountActionBean();

    // Act and Assert result
    assertThat(accountActionBean.getUsername()).isNull();

  }

  // Test written by Diffblue Cover.
  @Test
  void getAccountOutputNotNull() {

    // Arrange
    final AccountActionBean accountActionBean = new AccountActionBean();

    // Act
    final Account actual = accountActionBean.getAccount();

    // Assert result
    assertThat(actual).isNotNull();
    assertThat(actual.getAddress2()).isNull();
    assertThat(actual.getState()).isNull();
    assertThat(actual.getFirstName()).isNull();
    assertThat(actual.getPassword()).isNull();
    assertThat(actual.getLanguagePreference()).isNull();
    assertThat(actual.getFavouriteCategoryId()).isNull();
    assertThat(actual.getCountry()).isNull();
    assertThat(actual.getPhone()).isNull();
    assertThat(actual.getUsername()).isNull();
    assertThat(actual.getLastName()).isNull();
    assertThat(actual.getAddress1()).isNull();
    assertThat(actual.getEmail()).isNull();
    assertThat(actual.getStatus()).isNull();
    assertThat(actual.getBannerName()).isNull();
    assertThat(actual.getZip()).isNull();
    assertThat(actual.getCity()).isNull();

  }
}
