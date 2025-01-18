<%--

       Copyright 2010-2023 the original author or authors.

       Licensed under the Apache License, Version 2.0 (the "License");
       you may not use this file except in compliance with the License.
       You may obtain a copy of the License at

          https://www.apache.org/licenses/LICENSE-2.0

       Unless required by applicable law or agreed to in writing, software
       distributed under the License is distributed on an "AS IS" BASIS,
       WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
       See the License for the specific language governing permissions and
       limitations under the License.

--%>
<%@ include file="../common/IncludeTop.jsp"%>

<div id="BackLink"><stripes:link
	beanclass="org.mybatis.jpetstore.web.actions.CatalogActionBean">
	Return to Main Menu</stripes:link></div>

<div id="Catalog">

<div id="Cart">

<h2>Shopping Cart</h2>
<stripes:form
	beanclass="org.mybatis.jpetstore.web.actions.CartActionBean">
	<table>
		<tr>
			<th><b>Item ID</b></th>
			<th><b>Product ID</b></th>
			<th><b>Description</b></th>
			<th><b>In Stock?</b></th>
			<th><b>Quantity</b></th>
			<th><b>List Price</b></th>
			<th><b>Total Cost</b></th>
			<th>&nbsp;</th>
		</tr>

		<c:if test="${actionBean.cart.numberOfItems == 0}">
			<tr>
				<td colspan="8"><b>Your cart is empty.</b></td>
			</tr>
		</c:if>

		<c:forEach var="cartItem" items="${actionBean.cart.cartItems}">
			<tr>
				<td><stripes:link
					beanclass="org.mybatis.jpetstore.web.actions.CatalogActionBean"
					event="viewItem">
					<stripes:param name="itemId" value="${cartItem.item.itemId}" />
				${cartItem.item.itemId}
			  </stripes:link></td>
				<td>${cartItem.item.product.productId}</td>
				<td>${cartItem.item.attribute1} ${cartItem.item.attribute2}
				${cartItem.item.attribute3} ${cartItem.item.attribute4}
				${cartItem.item.attribute5} ${cartItem.item.product.name}</td>
				<td>${cartItem.inStock}</td>
				<td><stripes:text size="3" name="${cartItem.item.itemId}"
					value="${cartItem.quantity}" /></td>
				<td>$<fmt:formatNumber value="${cartItem.item.listPrice}"
					pattern="#,##0.00" /></td>
				<td>$<fmt:formatNumber value="${cartItem.total}"
					pattern="#,##0.00" /></td>
				<td><stripes:link class="Button"
					beanclass="org.mybatis.jpetstore.web.actions.CartActionBean"
					event="removeItemFromCart">
					<stripes:param name="workingItemId" value="${cartItem.item.itemId}" />
            	Remove
            </stripes:link></td>
			</tr>
		</c:forEach>
		<tr>
			<td colspan="7">Sub Total: $<fmt:formatNumber
				value="${actionBean.cart.subTotal}" pattern="#,##0.00" /> <stripes:submit
				name="updateCartQuantities" value="Update Cart" /></td>
			<td>&nbsp;</td>
		</tr>
	</table>

</stripes:form> <c:if test="${actionBean.cart.numberOfItems > 0}">
	<stripes:link class="Button"
		beanclass="org.mybatis.jpetstore.web.actions.OrderActionBean"
		event="newOrderForm">
      	Proceed to Checkout
      </stripes:link>
</c:if></div>

<div id="MyList">
  <c:if test="${sessionScope.accountBean != null}">
	<c:if test="${!sessionScope.accountBean.authenticated}">
	  <c:if test="${!empty sessionScope.accountBean.account.listOption}">
	    <%@ include file="IncludeMyList.jsp"%>
      </c:if>
	</c:if>
  </c:if>
</div>

<div id="Separator">&nbsp;</div>
</div>

<%@ include file="../common/IncludeBottom.jsp"%>
