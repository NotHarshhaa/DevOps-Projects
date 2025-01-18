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
	beanclass="org.mybatis.jpetstore.web.actions.AccountActionBean"
	focus="">

	<h3>User Information</h3>

	<table>
		<tr>
			<td>User ID:</td>
			<td><stripes:text name="username" /></td>
		</tr>
		<tr>
			<td>New password:</td>
			<td><stripes:text name="password" /></td>
		</tr>
		<tr>
			<td>Repeat password:</td>
			<td><stripes:text name="repeatedPassword" /></td>
		</tr>
	</table>

	<%@ include file="IncludeAccountFields.jsp"%>

	<stripes:submit name="newAccount" value="Save Account Information" />

</stripes:form></div>

<%@ include file="../common/IncludeBottom.jsp"%>
