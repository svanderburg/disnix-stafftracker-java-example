<%@page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page import="org.nixos.disnix.example.webservices.*,org.apache.axis2.*" %>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<title>Staff table</title>
		<link rel="stylesheet" type="text/css" href="style.css">
	</head>
	<body>
		<p><a href="editstaff.jsp">Add staff</a></p>
	
		<table>
			<tr>
				<th>Id</th>
				<th>Name</th>
				<th>Last name</th>
				<th>Room</th>
				<th>IP address</th>
			</tr>
			<%
			try
			{
				StaffConnector connector = new StaffConnector(StaffTrackerProperties.getInstance().getStaffServiceURL());
				Staff[] staff = connector.queryAllStaff();
				
				for(int i = 0; i < staff.length; i++)
				{
					%>
					<tr>
						<td><a href="displaystaff.jsp?id=<%= staff[i].getId() %>"><%= staff[i].getId() %></a></td>
						<td><%= staff[i].getName() %></td>
						<td><%= staff[i].getLastName() %></td>
						<td><%= staff[i].getRoom() %></td>
						<td><%= staff[i].getIpAddress() %></td>
						<td><a href="editstaff.jsp?id=<%= staff[i].getId() %>">Edit</a></td>
						<td><a href="modifystaff.jsp?action=delete&amp;id=<%= staff[i].getId() %>">Delete</a></td>
					</tr>
					<%
				}
			}
			catch(Exception ex)
			{
				%>
				<tr><td colspan="7">Error: cannot connect to the Staff service!</td></tr>
				<%
			}
			%>
		</table>
	</body>
</html>
