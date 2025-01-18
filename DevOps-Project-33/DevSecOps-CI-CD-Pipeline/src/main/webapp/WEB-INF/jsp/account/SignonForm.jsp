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

<div id="Catalog"><stripes:form
	beanclass="org.mybatis.jpetstore.web.actions.AccountActionBean"
	focus="">

	<p>Please enter your username and password.</p>
	<p>Username:<stripes:text name="username" value="j2ee" /> <br />
	Password:<stripes:password name="password" value="j2ee" /></p>
	<stripes:submit name="signon" value="Login" />

</stripes:form> Need a user name and password? <stripes:link
	beanclass="org.mybatis.jpetstore.web.actions.AccountActionBean"
	event="newAccountForm">Register Now!</stripes:link></div>

<%@ include file="../common/IncludeBottom.jsp"%>

