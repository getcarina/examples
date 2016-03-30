<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Show All Users</title>
</head>
<body>
<table border=1>
    <thead>
    <tr>
        <th>Name</th>
        <th>ID</th>
        <th>Connect to</th>
        <th>Delete?</th>
    </tr>
    </thead>
    <tbody>
    <c:forEach items="${containers}" var="container">
        <tr>
            <td><c:out value="${container.names().get(0)}" /></td>
            <td><c:out value="${container.id()}" /></td>
            <td><c:out value="${container.ports().get(0).ip()}" />:<c:out value="${container.ports().get(0).publicPort()}" />,
                <c:out value="${container.ports().get(1).ip()}" />:<c:out value="${container.ports().get(1).publicPort()}" />
            </td>
            <td>
                <a href="ContainerController?action=delete&containerId=<c:out value="${container.id()}"/>">DELETE</a>
            </td>
        </tr>
    </c:forEach>
    </tbody>
</table>
<p><a href="ContainerController?action=create">Add Another Instance</a></p>
</body>
