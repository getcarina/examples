<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<html>
<head>
    <title>New Container Details</title>
</head>
<body>
<table border=1>
    <tbody>
        <c:forEach items="${ports.entrySet()}" var="portList">
            <c:forEach items="${portList.getValue()}" var="port">
                <tr>
                    <td>Address</td>
                    <td>
                        <c:out value="${portList.getKey()}" />
                    </td>
                    <td>
                        <c:out value="${port.get(\"HostIp\")}" />:<c:out value="${port.get(\"HostPort\")}" />
                    </td>
                </tr>
            </c:forEach>
        </c:forEach>
        <tr>
            <td>Password</td>
            <td colspan="2">
                <c:out value="${password}" />
            </td>
        </tr>
    </tbody>
</table>
<p><a href="ContainerController?action=list">Back</a></p>
</body>
</html>
