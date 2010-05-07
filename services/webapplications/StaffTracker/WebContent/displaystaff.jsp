<%@page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page import="org.nixos.disnix.example.webservices.*,org.apache.axis2.*" %>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<title>Display staff</title>
	</head>
	<body>
		<%
		String idParameter = request.getParameter("id");
		Staff staff = null;
		
		if(idParameter == null)
		{
			%>
			<p>A staff identifier parameter needs to be specified!</p>
			<%
		}
		else
		{
			StaffTrackerProperties props = StaffTrackerProperties.getInstance();
			
			int id = Integer.parseInt(idParameter);
			StaffConnector staffConnector = new StaffConnector(props.getStaffServiceURL());
			staff = staffConnector.queryStaff(id);
			
			/* Query room information from the room service, so that we know the zip code */
			RoomConnector roomConnector = new RoomConnector(props.getRoomServiceURL());
			Room room = roomConnector.queryRoom(staff.getRoom());
			
			/* Query zip code information from the zip code service, so that we know the street and city */
			ZipcodeConnector zipcodeConnector = new ZipcodeConnector(props.getZipcodeServiceURL());
			Zipcode zipcode = zipcodeConnector.queryZipcode(room.getZipcode());
			
			/* Query the location of the computer by invoking the geolocation service */
			GeolocationConnector geolocationConnector = new GeolocationConnector(props.getGeolocationServiceURL());
			String location = geolocationConnector.getCountry(staff.getIpAddress());
			%>
			<table>
				<tr>
					<th>Id</th>
					<td><%= staff.getId() %></td>
				</tr>
				<tr>
					<th>Name</th>
					<td><%= staff.getName() %></td>
				</tr>
				<tr>
					<th>Last name</th>
					<td><%= staff.getLastName() %></td>
				</tr>
				<tr>
					<th>Room</th>
					<td><%= staff.getRoom() %></td>
				</tr>
				<tr>
					<th>Zip code</th>
					<td><%= room.getZipcode() %></td>
				</tr>
				<tr>
					<th>Street</th>
					<td><%= zipcode.getStreet() %></td>
				</tr>
				<tr>
					<th>City</th>
					<td><%= zipcode.getCity() %></td>
				</tr>
				<tr>
					<th>IP address</th>
					<td><%= staff.getIpAddress() %></td>
				</tr>
				<tr>
					<th>Computer location</th>
					<td><%= location %></td>
				</tr>
			</table>
			<%
		}
		%>
	</body>
</html>
