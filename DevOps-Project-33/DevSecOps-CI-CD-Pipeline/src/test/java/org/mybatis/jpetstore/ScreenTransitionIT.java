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
package org.mybatis.jpetstore;

import static com.codeborne.selenide.Browsers.CHROME;
import static com.codeborne.selenide.CollectionCondition.size;
import static com.codeborne.selenide.Condition.empty;
import static com.codeborne.selenide.Condition.text;
import static com.codeborne.selenide.Condition.value;
import static com.codeborne.selenide.Configuration.baseUrl;
import static com.codeborne.selenide.Configuration.browser;
import static com.codeborne.selenide.Configuration.headless;
import static com.codeborne.selenide.Configuration.timeout;
import static com.codeborne.selenide.Selenide.$;
import static com.codeborne.selenide.Selenide.$$;
import static com.codeborne.selenide.Selenide.open;
import static com.codeborne.selenide.Selenide.title;
import static org.assertj.core.api.Assertions.assertThat;

import com.codeborne.selenide.SelenideElement;
import com.codeborne.selenide.junit5.ScreenShooterExtension;

import java.util.concurrent.TimeUnit;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.BeforeAll;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.openqa.selenium.By;

/**
 * Integration tests for screen transition.
 *
 * @author Kazuki Shimizu
 */
@ExtendWith(ScreenShooterExtension.class)
class ScreenTransitionIT {

  @BeforeAll
  static void setupSelenide() {
    browser = CHROME;
    headless = true;
    timeout = TimeUnit.SECONDS.toMillis(10);
    baseUrl = "http://localhost:8080/jpetstore";
  }

  @AfterEach
  void logout() {
    SelenideElement element = $(By.linkText("Sign Out"));
    if (element.exists()) {
      element.click();
    }
  }

  @Test
  void testOrder() {

    // Open the home page
    open("/");
    assertThat(title()).isEqualTo("JPetStore Demo");
    $(By.cssSelector("#Content h2")).shouldBe(text("Welcome to JPetStore 6"));

    // Move to the top page
    $(By.linkText("Enter the Store")).click();
    $(By.id("WelcomeContent")).shouldBe(empty);

    // Move to sign in page & sign
    $(By.linkText("Sign In")).click();
    $(By.name("username")).setValue("j2ee");
    $(By.name("password")).setValue("j2ee");
    $(By.name("signon")).click();
    $(By.id("WelcomeContent")).shouldBe(text("Welcome ABC!"));

    // Search items
    $(By.name("keyword")).setValue("fish");
    $(By.name("searchProducts")).click();
    $$(By.cssSelector("#Catalog table tr")).shouldHave(size(4));

    // Select item
    $(By.linkText("Fresh Water fish from China")).click();
    $(By.cssSelector("#Catalog h2")).shouldBe(text("Goldfish"));

    // Add a item to the cart
    $(By.linkText("Add to Cart")).click();
    $(By.cssSelector("#Catalog h2")).shouldBe(text("Shopping Cart"));

    // Add a item to the cart
    $(By.cssSelector("#QuickLinks a:nth-of-type(5)")).click();
    $(By.linkText("AV-CB-01")).click();
    $(By.linkText("EST-18")).click();
    $(By.linkText("Add to Cart")).click();
    $(By.cssSelector("#Cart tr:nth-of-type(4) td")).shouldBe(text("Sub Total: $199.00"));

    // Update quantity
    $(By.name("EST-20")).setValue("10");
    $(By.name("updateCartQuantities")).click();
    $(By.cssSelector("#Catalog tr td:nth-of-type(7)")).shouldBe(text("$55.00"));
    $(By.cssSelector("#Cart tr:nth-of-type(4) td")).shouldBe(text("Sub Total: $248.50"));

    // Remove item
    $(By.cssSelector("#Cart tr:nth-of-type(3) td:nth-of-type(8) a")).click();
    $(By.cssSelector("#Cart tr:nth-of-type(3) td")).shouldBe(text("Sub Total: $55.00"));

    // Checkout cart items
    $(By.linkText("Proceed to Checkout")).click();
    assertThat(title()).isEqualTo("JPetStore Demo");

    // Changing shipping address
    $(By.name("shippingAddressRequired")).click();
    $(By.name("newOrder")).click();
    $(By.cssSelector("#Catalog tr th")).shouldBe(text("Shipping Address"));
    $(By.name("order.shipAddress2")).setValue("MS UCUP02-207");

    // Confirm order information
    $(By.name("newOrder")).click();
    $(By.cssSelector("#Catalog")).shouldBe(text("Please confirm the information below and then press continue..."));

    // Submit order
    $(By.linkText("Confirm")).click();
    $(By.cssSelector(".messages li")).shouldBe(text("Thank you, your order has been submitted."));
    String orderId = extractOrderId($(By.cssSelector("#Catalog table tr")).text());

    // Show profile page
    $(By.linkText("My Account")).click();
    $(By.cssSelector("#Catalog h3")).shouldBe(text("User Information"));

    // Show orders
    $(By.linkText("My Orders")).click();
    $(By.cssSelector("#Content h2")).shouldBe(text("My Orders"));

    // Show order detail
    $(By.linkText(orderId)).click();
    assertThat(extractOrderId($(By.cssSelector("#Catalog table tr")).text())).isEqualTo(orderId);

    // Sign out
    $(By.linkText("Sign Out")).click();
    $(By.id("WelcomeContent")).shouldBe(empty);

  }

  @Test
  void testUpdateProfile() {
    // Open the home page
    open("/");
    assertThat(title()).isEqualTo("JPetStore Demo");

    // Move to the top page
    $(By.linkText("Enter the Store")).click();
    $(By.id("WelcomeContent")).shouldBe(empty);

    // Move to sign in page & sign
    $(By.linkText("Sign In")).click();
    $(By.name("username")).setValue("j2ee");
    $(By.name("password")).setValue("j2ee");
    $(By.name("signon")).click();
    $(By.id("WelcomeContent")).shouldBe(text("Welcome ABC!"));

    // Show profile page
    $(By.linkText("My Account")).click();
    $(By.cssSelector("#Catalog h3")).shouldBe(text("User Information"));
    $$(By.cssSelector("#Catalog table td")).get(1).shouldBe(text("j2ee"));

    // Edit account
    $(By.name("account.phone")).setValue("555-555-5556");
    $(By.name("editAccount")).click();
    $(By.cssSelector("#Catalog h3")).shouldBe(text("User Information"));
    $$(By.cssSelector("#Catalog table td")).get(1).shouldBe(text("j2ee"));
    $(By.name("account.phone")).shouldBe(value("555-555-5556"));
  }

  @Test
  void testRegistrationUser() {
    // Open the home page
    open("/");
    assertThat(title()).isEqualTo("JPetStore Demo");

    // Move to the top page
    $(By.linkText("Enter the Store")).click();
    $(By.id("WelcomeContent")).shouldBe(empty);

    // Move to sign in page & sign
    $(By.linkText("Sign In")).click();
    $(By.cssSelector("#Catalog p")).shouldBe(text("Please enter your username and password."));

    // Move to use registration page
    $(By.linkText("Register Now!")).click();
    $(By.cssSelector("#Catalog h3")).shouldBe(text("User Information"));

    // Create a new user
    String userId = String.valueOf(System.currentTimeMillis());
    $(By.name("username")).setValue(userId);
    $(By.name("password")).setValue("password");
    $(By.name("repeatedPassword")).setValue("password");
    $(By.name("account.firstName")).setValue("Jon");
    $(By.name("account.lastName")).setValue("MyBatis");
    $(By.name("account.email")).setValue("jon.mybatis@test.com");
    $(By.name("account.phone")).setValue("09012345678");
    $(By.name("account.address1")).setValue("Address1");
    $(By.name("account.address2")).setValue("Address2");
    $(By.name("account.city")).setValue("Minato-Ku");
    $(By.name("account.state")).setValue("Tokyo");
    $(By.name("account.zip")).setValue("0001234");
    $(By.name("account.country")).setValue("Japan");
    $(By.name("account.languagePreference")).selectOption("japanese");
    $(By.name("account.favouriteCategoryId")).selectOption("CATS");
    $(By.name("account.listOption")).setSelected(true);
    $(By.name("account.bannerOption")).setSelected(true);
    $(By.name("newAccount")).click();
    $(By.id("WelcomeContent")).shouldBe(empty);

    // Move to sign in page & sign
    $(By.linkText("Sign In")).click();
    $(By.name("username")).setValue(userId);
    $(By.name("password")).setValue("password");
    $(By.name("signon")).click();
    $(By.id("WelcomeContent")).shouldBe(text("Welcome Jon!"));

  }

  @Test
  void testSelectItems() {
    // Open the home page
    open("/");
    assertThat(title()).isEqualTo("JPetStore Demo");

    // Move to the top page
    $(By.linkText("Enter the Store")).click();
    $(By.id("WelcomeContent")).shouldBe(empty);

    // Move to category
    $(By.cssSelector("#SidebarContent a")).click();
    $(By.cssSelector("#Catalog h2")).shouldBe(text("Fish"));

    // Move to items
    $(By.linkText("FI-SW-01")).click();
    $(By.cssSelector("#Catalog h2")).shouldBe(text("Angelfish"));

    // Move to item detail
    $(By.linkText("EST-1")).click();
    $$(By.cssSelector("#Catalog table tr td")).get(2).shouldBe(text("Large Angelfish"));

    // Back to items
    $(By.linkText("Return to FI-SW-01")).click();
    $(By.cssSelector("#Catalog h2")).shouldBe(text("Angelfish"));

    // Back to category
    $(By.linkText("Return to FISH")).click();
    $(By.cssSelector("#Catalog h2")).shouldBe(text("Fish"));

    // Back to the top page
    $(By.linkText("Return to Main Menu")).click();
    $(By.id("WelcomeContent")).shouldBe(empty);

  }

  @Test
  void testViewCart() {

    // Open the home page
    open("/");
    assertThat(title()).isEqualTo("JPetStore Demo");

    // Move to the top page
    $(By.linkText("Enter the Store")).click();
    $(By.id("WelcomeContent")).shouldBe(empty);

    // Move to cart
    $(By.name("img_cart")).click();
    $(By.cssSelector("#Catalog h2")).shouldBe(text("Shopping Cart"));

  }

  @Test
  void testViewHelp() {

    // Open the home page
    open("/");
    assertThat(title()).isEqualTo("JPetStore Demo");

    // Move to the top page
    $(By.linkText("Enter the Store")).click();
    $(By.id("WelcomeContent")).shouldBe(empty);

    // Move to help
    $(By.linkText("?")).click();
    $(By.cssSelector("#Content h1")).shouldBe(text("JPetStore Demo"));

  }

  @Test
  void testSidebarContentOnTopPage() {
    // Open the home page
    open("/");
    assertThat(title()).isEqualTo("JPetStore Demo");

    // Move to the top page
    $(By.linkText("Enter the Store")).click();
    $(By.id("WelcomeContent")).shouldBe(empty);

    // Move to Fish category
    $(By.cssSelector("#SidebarContent a:nth-of-type(1)")).click();
    $(By.cssSelector("#Catalog h2")).shouldBe(text("Fish"));
    $(By.linkText("Return to Main Menu")).click();

    // Move to Dogs category
    $(By.cssSelector("#SidebarContent a:nth-of-type(2)")).click();
    $(By.cssSelector("#Catalog h2")).shouldBe(text("Dogs"));
    $(By.linkText("Return to Main Menu")).click();

    // Move to Cats category
    $(By.cssSelector("#SidebarContent a:nth-of-type(3)")).click();
    $(By.cssSelector("#Catalog h2")).shouldBe(text("Cats"));
    $(By.linkText("Return to Main Menu")).click();

    // Move to Reptiles category
    $(By.cssSelector("#SidebarContent a:nth-of-type(4)")).click();
    $(By.cssSelector("#Catalog h2")).shouldBe(text("Reptiles"));
    $(By.linkText("Return to Main Menu")).click();

    // Move to Birds category
    $(By.cssSelector("#SidebarContent a:nth-of-type(5)")).click();
    $(By.cssSelector("#Catalog h2")).shouldBe(text("Birds"));
    $(By.linkText("Return to Main Menu")).click();
  }

  @Test
  void testQuickLinks() {
    // Open the home page
    open("/");
    assertThat(title()).isEqualTo("JPetStore Demo");

    // Move to the top page
    $(By.linkText("Enter the Store")).click();
    $(By.id("WelcomeContent")).shouldBe(empty);

    // Move to Fish category
    $(By.cssSelector("#QuickLinks a:nth-of-type(1)")).click();
    $(By.cssSelector("#Catalog h2")).shouldBe(text("Fish"));

    // Move to Dogs category
    $(By.cssSelector("#QuickLinks a:nth-of-type(2)")).click();
    $(By.cssSelector("#Catalog h2")).shouldBe(text("Dogs"));

    // Move to Reptiles category
    $(By.cssSelector("#QuickLinks a:nth-of-type(3)")).click();
    $(By.cssSelector("#Catalog h2")).shouldBe(text("Reptiles"));

    // Move to Cats category
    $(By.cssSelector("#QuickLinks a:nth-of-type(4)")).click();
    $(By.cssSelector("#Catalog h2")).shouldBe(text("Cats"));

    // Move to Birds category
    $(By.cssSelector("#QuickLinks a:nth-of-type(5)")).click();
    $(By.cssSelector("#Catalog h2")).shouldBe(text("Birds"));
  }

  @Test
  void testMainImageContentOnTopPage() {
    // Open the home page
    open("/");
    assertThat(title()).isEqualTo("JPetStore Demo");

    // Move to the top page
    $(By.linkText("Enter the Store")).click();
    $(By.id("WelcomeContent")).shouldBe(empty);

    // Move to Birds category
    $(By.cssSelector("#MainImageContent area:nth-of-type(1)")).click();
    $(By.cssSelector("#Catalog h2")).shouldBe(text("Birds"));
    $(By.linkText("Return to Main Menu")).click();

    // Move to Fish category
    $(By.cssSelector("#MainImageContent area:nth-of-type(2)")).click();
    $(By.cssSelector("#Catalog h2")).shouldBe(text("Fish"));
    $(By.linkText("Return to Main Menu")).click();

    // Move to Dogs category
    $(By.cssSelector("#MainImageContent area:nth-of-type(3)")).click();
    $(By.cssSelector("#Catalog h2")).shouldBe(text("Dogs"));
    $(By.linkText("Return to Main Menu")).click();

    // Move to Reptiles category
    $(By.cssSelector("#MainImageContent area:nth-of-type(4)")).click();
    $(By.cssSelector("#Catalog h2")).shouldBe(text("Reptiles"));
    $(By.linkText("Return to Main Menu")).click();

    // Move to Cats category
    $(By.cssSelector("#MainImageContent area:nth-of-type(5)")).click();
    $(By.cssSelector("#Catalog h2")).shouldBe(text("Cats"));
    $(By.linkText("Return to Main Menu")).click();

    // Move to Birds category
    $(By.cssSelector("#MainImageContent area:nth-of-type(6)")).click();
    $(By.cssSelector("#Catalog h2")).shouldBe(text("Birds"));
    $(By.linkText("Return to Main Menu")).click();
  }

  @Test
  void testLogoContent() {
    // Open the home page
    open("/");
    assertThat(title()).isEqualTo("JPetStore Demo");

    // Move to the top page
    $(By.linkText("Enter the Store")).click();
    $(By.id("WelcomeContent")).shouldBe(empty);

    // Move to Birds category
    $(By.cssSelector("#MainImageContent area:nth-of-type(1)")).click();
    $(By.cssSelector("#Catalog h2")).shouldBe(text("Birds"));

    // Move to top by clicking logo
    $(By.cssSelector("#LogoContent a")).click();

    // Move to Cats category
    $(By.cssSelector("#MainImageContent area:nth-of-type(5)")).click();
    $(By.cssSelector("#Catalog h2")).shouldBe(text("Cats"));
  }

  private static String extractOrderId(String target) {
    Matcher matcher = Pattern.compile("Order #(\\d{4}) .*").matcher(target);
    String orderId = "";
    if (matcher.find()) {
      orderId = matcher.group(1);
    }
    return orderId;
  }

}
