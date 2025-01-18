/*
 *    Copyright 2010-2023 the original author or authors.
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
package org.mybatis.jpetstore.service;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.fail;
import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.mybatis.jpetstore.domain.Item;
import org.mybatis.jpetstore.domain.LineItem;
import org.mybatis.jpetstore.domain.Order;
import org.mybatis.jpetstore.domain.Sequence;
import org.mybatis.jpetstore.mapper.ItemMapper;
import org.mybatis.jpetstore.mapper.LineItemMapper;
import org.mybatis.jpetstore.mapper.OrderMapper;
import org.mybatis.jpetstore.mapper.SequenceMapper;

/**
 * @author coderliux
 */
@ExtendWith(MockitoExtension.class)
class OrderServiceTest {

  @Mock
  private ItemMapper itemMapper;
  @Mock
  private OrderMapper orderMapper;
  @Mock
  private LineItemMapper lineItemMapper;
  @Mock
  private SequenceMapper sequenceMapper;

  @InjectMocks
  private OrderService orderService;

  @Test
  void shouldReturnOrderWhenGivenOrderIdWithOutLineItems() {
    // given
    int orderId = 1;
    Order order = new Order();
    List<LineItem> lineItems = new ArrayList<>();

    // when
    when(orderMapper.getOrder(orderId)).thenReturn(order);
    when(lineItemMapper.getLineItemsByOrderId(orderId)).thenReturn(lineItems);

    // then
    assertThat(orderService.getOrder(orderId)).isEqualTo(order);
    assertThat(orderService.getOrder(orderId).getLineItems()).isEmpty();
  }

  @Test
  void shouldReturnOrderWhenGivenOrderIdExistedLineItems() {
    // given
    int orderId = 1;
    Order order = new Order();
    List<LineItem> lineItems = new ArrayList<>();
    LineItem item = new LineItem();
    String itemId = "abc";
    item.setItemId(itemId);
    lineItems.add(item);

    // when
    when(orderMapper.getOrder(orderId)).thenReturn(order);
    when(lineItemMapper.getLineItemsByOrderId(orderId)).thenReturn(lineItems);
    when(itemMapper.getItem(itemId)).thenReturn(new Item());
    when(itemMapper.getInventoryQuantity(itemId)).thenReturn(5);

    // then
    Order expectedOrder = orderService.getOrder(orderId);
    assertThat(expectedOrder).isEqualTo(order);
    assertThat(expectedOrder.getLineItems()).hasSize(1);
    assertThat(expectedOrder.getLineItems().get(0).getItem().getQuantity()).isEqualTo(5);
  }

  @Test
  void shouldReturnOrderList() {

    // given
    String username = "foo";
    List<Order> expectedOrders = new ArrayList<>();

    // when
    when(orderMapper.getOrdersByUsername(username)).thenReturn(expectedOrders);
    List<Order> orders = orderService.getOrdersByUsername(username);

    // then
    assertThat(orders).isSameAs(expectedOrders);

  }

  @Test
  void shouldReturnNextId() {

    // given
    Sequence expectedSequence = new Sequence("order", 100);

    // when
    when(sequenceMapper.getSequence(any())).thenReturn(expectedSequence);
    int nextId = orderService.getNextId("order");

    // then
    assertThat(nextId).isEqualTo(100);
    verify(sequenceMapper).getSequence(argThat(v -> v.getName().equals("order") && v.getNextId() == -1));
    verify(sequenceMapper).updateSequence(argThat(v -> v.getName().equals("order") && v.getNextId() == 101));

  }

  @Test
  void shouldThrowExceptionWhenSequenceNotFound() {

    // given

    // when
    when(sequenceMapper.getSequence(any())).thenReturn(null);
    try {
      orderService.getNextId("order");
      fail("Should throw an exception when sequence not found.");
    } catch (RuntimeException e) {
      // then
      assertThat(e.getMessage())
          .isEqualTo("Error: A null sequence was returned from the database (could not get next order sequence).");
      verify(sequenceMapper).getSequence(argThat(v -> v.getName().equals("order") && v.getNextId() == -1));
    }

  }

  @Test
  void shouldCallTheMapperToInsert() {
    // given
    Order order = new Order();
    LineItem item = new LineItem();
    String itemId = "I01";
    int quantity = 4;
    item.setItemId(itemId);
    item.setQuantity(quantity);
    order.addLineItem(item);

    Sequence orderNumSequence = new Sequence("ordernum", 100);

    Map<String, Object> expectedItemParam = new HashMap<>(2);
    expectedItemParam.put("itemId", itemId);
    expectedItemParam.put("increment", quantity);

    // when
    when(sequenceMapper.getSequence(any())).thenReturn(orderNumSequence);
    orderService.insertOrder(order);

    // then
    verify(orderMapper).insertOrder(argThat(v -> v == order && v.getOrderId() == 100));
    verify(orderMapper).insertOrderStatus(eq(order));
    verify(lineItemMapper).insertLineItem(argThat(v -> v == item && v.getOrderId() == 100));
    verify(itemMapper).updateInventoryQuantity(eq(expectedItemParam));
  }

}
