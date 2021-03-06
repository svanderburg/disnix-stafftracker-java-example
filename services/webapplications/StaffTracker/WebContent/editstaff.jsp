<%@page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page import="org.nixos.disnix.example.webservices.*,org.apache.axis2.*" %>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<title>Edit staff</title>
		<link rel="stylesheet" type="text/css" href="style.css">
	</head>
	<body>
		<%
		StaffTrackerProperties props = StaffTrackerProperties.getInstance();
		String idParameter = request.getParameter("id");
		Staff staff = null;
		
		if(idParameter != null)
		{
			int id = Integer.parseInt(idParameter);
			StaffConnector staffConnector = new StaffConnector(props.getStaffServiceURL());
			staff = staffConnector.queryStaff(id);
		}
		%>
		<form action="modifystaff.jsp" method="post">
			<p>
				<input type="hidden" name="action" value="<%= staff == null ? "insert" : "update" %>">
				<%
				if(staff != null)
				{
					%>
					<input type="hidden" name="old_Id" value="<%= idParameter %>">
					<%
				}
				%>
			</p>
			<table>
				<tr>
					<th>Id</th>
					<td><input name="Id" type="text" value="<%= staff != null ? staff.getId() : "" %>"></td>
				</tr>
				<tr>
					<th>Name</th>
					<td><input name="Name" type="text" value="<%= staff != null ? staff.getName() : "" %>"></td>
				</tr>
				<tr>
					<th>Last name</th>
					<td><input name="LastName" type="text" value="<%= staff != null ? staff.getLastName() : "" %>"></td>
				</tr>
				<tr>
					<th>Room</th>
					<td>
						<select name="Room">
							<%
							RoomConnector roomConnector = new RoomConnector(props.getRoomServiceURL());
							String[] roomIdentifier = roomConnector.queryAllRoomIdentifiers();
							
							for(int i = 0; i < roomIdentifier.length; i++)
							{
								%>
								<option value="<%= roomIdentifier[i] %>" <%= (staff != null && staff.getRoom().equals(roomIdentifier[i])) ? "selected" : "" %>><%= roomIdentifier[i] %></option>
								<%
							}
							%>
						</select>
					</td>
				</tr>
				<tr>
					<th>IP address</th>
					<td><input name="ipAddress" type="text" value="<%= staff != null ? staff.getIpAddress() : "" %>"></td>
				</tr>
				<tr>
					<td><input type="submit" value="Submit"></td>
					<td><input type="reset" value="Reset"></td>
				</tr>
			</table>
		</form>
	</body>
</html>
