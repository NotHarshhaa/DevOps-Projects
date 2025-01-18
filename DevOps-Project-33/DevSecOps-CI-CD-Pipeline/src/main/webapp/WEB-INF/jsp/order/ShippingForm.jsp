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

<div id="Catalog"><stripes:form
	beanclass="org.mybatis.jpetstore.web.actions.OrderActionBean">

	<table>
		<tr>
			<th colspan=2>Shipping Address</th>
		</tr>

		<tr>
			<td>First name:</td>
			<td><stripes:text name="order.shipToFirstName" /></td>
		</tr>
		<tr>
			<td>Last name:</td>
			<td><stripes:text name="order.shipToLastName" /></td>
		</tr>
		<tr>
			<td>Address 1:</td>
			<td><stripes:text size="40" name="order.shipAddress1" /></td>
		</tr>
		<tr>
			<td>Address 2:</td>
			<td><stripes:text size="40" name="order.shipAddress2" /></td>
		</tr>
		<tr>
			<td>City:</td>
			<td><stripes:text name="order.shipCity" /></td>
		</tr>
		<tr>
			<td>State:</td>
			<td><stripes:text size="4" name="order.shipState" /></td>
		</tr>
		<tr>
			<td>Zip:</td>
			<td><stripes:text size="10" name="order.shipZip" /></td>
		</tr>
		<tr>
			<td>Country:</td>
			<td><stripes:text size="15" name="order.shipCountry" /></td>
		</tr>


	</table>

	<stripes:submit name="newOrder" value="Continue" />

</stripes:form></div>

<%@ include file="../common/IncludeBottom.jsp"%>
