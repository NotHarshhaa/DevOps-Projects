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
package org.mybatis.jpetstore.service;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.mybatis.jpetstore.domain.Account;
import org.mybatis.jpetstore.mapper.AccountMapper;

/**
 * @author Eduardo Macarron
 */
@ExtendWith(MockitoExtension.class)
class AccountServiceTest {

  @Mock
  private AccountMapper accountMapper;

  @InjectMocks
  private AccountService accountService;

  @Test
  void shouldCallTheMapperToInsertAnAccount() {
    // given
    Account account = new Account();

    // when
    accountService.insertAccount(account);

    // then
    verify(accountMapper).insertAccount(eq(account));
    verify(accountMapper).insertProfile(eq(account));
    verify(accountMapper).insertSignon(eq(account));
  }

  @Test
  void shouldCallTheMapperToUpdateAnAccount() {
    // given
    Account account = new Account();
    account.setPassword("foo");

    // when
    accountService.updateAccount(account);

    // then
    verify(accountMapper).updateAccount(eq(account));
    verify(accountMapper).updateProfile(eq(account));
    verify(accountMapper).updateSignon(eq(account));
  }

  @Test
  void shouldCallTheMapperToGetAccountAnUsername() {
    // given
    String username = "bar";
    Account expectedAccount = new Account();
    when(accountMapper.getAccountByUsername(username)).thenReturn(expectedAccount);

    // when
    Account account = accountService.getAccount(username);

    // then
    assertThat(account).isSameAs(expectedAccount);
  }

  @Test
  void shouldCallTheMapperToGetAccountAnUsernameAndPassword() {
    // given
    String username = "bar";
    String password = "foo";

    // when
    Account expectedAccount = new Account();
    when(accountMapper.getAccountByUsernameAndPassword(username, password)).thenReturn(expectedAccount);
    Account account = accountService.getAccount(username, password);

    // then
    assertThat(account).isSameAs(expectedAccount);
  }

}
