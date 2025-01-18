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

import java.util.Comparator;
import java.util.List;

import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mybatis.jpetstore.domain.Product;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit.jupiter.SpringExtension;
import org.springframework.transaction.annotation.Transactional;

@ExtendWith(SpringExtension.class)
@ContextConfiguration(classes = MapperTestContext.class)
@Transactional
class ProductMapperTest {

  @Autowired
  private ProductMapper mapper;

  @Test
  void getProductListByCategory() {
    // given
    String categoryId = "FISH";

    // when
    List<Product> products = mapper.getProductListByCategory(categoryId);

    // then
    products.sort(Comparator.comparing(Product::getProductId));
    assertThat(products).hasSize(4);
    assertThat(products.get(0).getProductId()).isEqualTo("FI-FW-01");
    assertThat(products.get(0).getName()).isEqualTo("Koi");
    assertThat(products.get(0).getCategoryId()).isEqualTo("FISH");
    assertThat(products.get(0).getDescription())
        .isEqualTo("<image src=\"../images/fish3.gif\">Fresh Water fish from Japan");
    assertThat(products.get(1).getProductId()).isEqualTo("FI-FW-02");
    assertThat(products.get(1).getName()).isEqualTo("Goldfish");
    assertThat(products.get(1).getCategoryId()).isEqualTo("FISH");
    assertThat(products.get(1).getDescription())
        .isEqualTo("<image src=\"../images/fish2.gif\">Fresh Water fish from China");
    assertThat(products.get(2).getProductId()).isEqualTo("FI-SW-01");
    assertThat(products.get(2).getName()).isEqualTo("Angelfish");
    assertThat(products.get(2).getCategoryId()).isEqualTo("FISH");
    assertThat(products.get(2).getDescription())
        .isEqualTo("<image src=\"../images/fish1.gif\">Salt Water fish from Australia");
    assertThat(products.get(3).getProductId()).isEqualTo("FI-SW-02");
    assertThat(products.get(3).getName()).isEqualTo("Tiger Shark");
    assertThat(products.get(3).getCategoryId()).isEqualTo("FISH");
    assertThat(products.get(3).getDescription())
        .isEqualTo("<image src=\"../images/fish4.gif\">Salt Water fish from Australia");
  }

  @Test
  void getProduct() {
    // given
    String productId = "FI-FW-01";

    // when
    Product product = mapper.getProduct(productId);

    // then
    assertThat(product.getProductId()).isEqualTo("FI-FW-01");
    assertThat(product.getName()).isEqualTo("Koi");
    assertThat(product.getCategoryId()).isEqualTo("FISH");
    assertThat(product.getDescription()).isEqualTo("<image src=\"../images/fish3.gif\">Fresh Water fish from Japan");
  }

  @Test
  void searchProductList() {
    // given
    String keywords = "%o%";

    // when
    List<Product> products = mapper.searchProductList(keywords);

    // then
    products.sort(Comparator.comparing(Product::getProductId));
    System.out.println(products);
    assertThat(products).hasSize(8);
    assertThat(products.get(0).getProductId()).isEqualTo("AV-CB-01");
    assertThat(products.get(0).getName()).isEqualTo("Amazon Parrot");
    assertThat(products.get(0).getCategoryId()).isEqualTo("BIRDS");
    assertThat(products.get(0).getDescription())
        .isEqualTo("<image src=\"../images/bird2.gif\">Great companion for up to 75 years");
    assertThat(products.get(1).getName()).isEqualTo("Koi");
    assertThat(products.get(2).getName()).isEqualTo("Goldfish");
    assertThat(products.get(3).getName()).isEqualTo("Bulldog");
    assertThat(products.get(4).getName()).isEqualTo("Dalmation");
    assertThat(products.get(5).getName()).isEqualTo("Poodle");
    assertThat(products.get(6).getName()).isEqualTo("Golden Retriever");
    assertThat(products.get(7).getName()).isEqualTo("Labrador Retriever");
  }

}
