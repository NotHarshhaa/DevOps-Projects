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
	beanclass="org.mybatis.jpetstore.web.actions.CartActionBean">
	Return to Shopping Cart</stripes:link></div>

<div id="Catalog">

<table>
	<tr>
		<td>
		<h2>Checkout Summary</h2>

		<table>

			<tr>
				<td><b>Item ID</b></td>
				<td><b>Product ID</b></td>
				<td><b>Description</b></td>
				<td><b>In Stock?</b></td>
				<td><b>Quantity</b></td>
				<td><b>List Price</b></td>
				<td><b>Total Cost</b></td>
			</tr>

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
					<td>${cartItem.quantity}</td>
					<td><fmt:formatNumber value="${cartItem.item.listPrice}"
						pattern="$#,##0.00" /></td>
					<td><fmt:formatNumber value="${cartItem.total}"
						pattern="$#,##0.00" /></td>
				</tr>
			</c:forEach>
			<tr>
				<td colspan="7">Sub Total: <fmt:formatNumber
					value="${actionBean.cart.subTotal}" pattern="$#,##0.00" /></td>
			</tr>
		</table>

		<td>&nbsp;</td>

	</tr>
</table>

</div>

<%@ include file="../common/IncludeBottom.jsp"%>
