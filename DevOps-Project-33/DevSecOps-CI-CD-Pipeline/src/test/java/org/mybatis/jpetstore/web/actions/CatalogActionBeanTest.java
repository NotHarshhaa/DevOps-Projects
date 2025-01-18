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

class CatalogActionBeanTest {

  @Test
  void getItemListOutputNull() {

    // Arrange
    final CatalogActionBean catalogActionBean = new CatalogActionBean();

    // Act and Assert result
    assertThat(catalogActionBean.getItemList()).isNull();

  }

  // Test written by Diffblue Cover.
  @Test
  void getProductListOutputNull() {

    // Arrange
    final CatalogActionBean catalogActionBean = new CatalogActionBean();

    // Act and Assert result
    assertThat(catalogActionBean.getProductList()).isNull();

  }

  // Test written by Diffblue Cover.
  @Test
  void getCategoryListOutputNull() {

    // Arrange
    final CatalogActionBean catalogActionBean = new CatalogActionBean();

    // Act and Assert result
    assertThat(catalogActionBean.getCategoryList()).isNull();

  }

  // Test written by Diffblue Cover.
  @Test
  void getItemOutputNull() {

    // Arrange
    final CatalogActionBean catalogActionBean = new CatalogActionBean();

    // Act and Assert result
    assertThat(catalogActionBean.getItem()).isNull();

  }

  // Test written by Diffblue Cover.
  @Test
  void getProductOutputNull() {

    // Arrange
    final CatalogActionBean catalogActionBean = new CatalogActionBean();

    // Act and Assert result
    assertThat(catalogActionBean.getProduct()).isNull();

  }

  // Test written by Diffblue Cover.
  @Test
  void getCategoryOutputNull() {

    // Arrange
    final CatalogActionBean catalogActionBean = new CatalogActionBean();

    // Act and Assert result
    assertThat(catalogActionBean.getCategory()).isNull();

  }

  // Test written by Diffblue Cover.
  @Test
  void getItemIdOutputNull() {

    // Arrange
    final CatalogActionBean catalogActionBean = new CatalogActionBean();

    // Act and Assert result
    assertThat(catalogActionBean.getItemId()).isNull();

  }

  // Test written by Diffblue Cover.
  @Test
  void getProductIdOutputNull() {

    // Arrange
    final CatalogActionBean catalogActionBean = new CatalogActionBean();

    // Act and Assert result
    assertThat(catalogActionBean.getProductId()).isNull();

  }

  // Test written by Diffblue Cover.
  @Test
  void getCategoryIdOutputNull() {

    // Arrange
    final CatalogActionBean catalogActionBean = new CatalogActionBean();

    // Act and Assert result
    assertThat(catalogActionBean.getCategoryId()).isNull();

  }

  // Test written by Diffblue Cover.
  @Test
  void getKeywordOutputNull() {

    // Arrange
    final CatalogActionBean catalogActionBean = new CatalogActionBean();

    // Act and Assert result
    assertThat(catalogActionBean.getKeyword()).isNull();

  }

  // Test written by Diffblue Cover.
  @Test
  void constructorOutputNotNull() {

    // Act, creating object to test constructor
    final CatalogActionBean actual = new CatalogActionBean();

    // Assert result
    assertThat(actual).isNotNull();
    assertThat(actual.getContext()).isNull();

  }
}
