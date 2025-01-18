<%--

       Copyright 2010-2022 the original author or authors.

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

<h2>My Orders</h2>

<table>
	<tr>
		<th>Order ID</th>
		<th>Date</th>
		<th>Total Price</th>
	</tr>

	<c:forEach var="order" items="${actionBean.orderList}">
		<tr>
			<td><stripes:link
				beanclass="org.mybatis.jpetstore.web.actions.OrderActionBean"
				event="viewOrder">
				<stripes:param name="orderId" value="${order.orderId}" />
			    ${order.orderId}
			  </stripes:link></td>
			<td><fmt:formatDate value="${order.orderDate}"
				pattern="yyyy/MM/dd hh:mm:ss" /></td>
			<td>$<fmt:formatNumber value="${order.totalPrice}"
				pattern="#,##0.00" /></td>
		</tr>
	</c:forEach>
</table>

<%@ include file="../common/IncludeBottom.jsp"%>


