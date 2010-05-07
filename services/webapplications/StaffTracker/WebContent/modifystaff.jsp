<%@page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page import="org.nixos.disnix.example.webservices.*,org.apache.axis2.*" %>

<%
String action = request.getParameter("action");

if(action != null)
{
	StaffConnector staffConnector = new StaffConnector(StaffTrackerProperties.getInstance().getStaffServiceURL());
	
	if(action.equals("insert"))
	{
		Staff staff = new Staff();
		staff.setId(Integer.parseInt(request.getParameter("Id")));
		staff.setName(request.getParameter("Name"));
		staff.setLastName(request.getParameter("LastName"));
		staff.setRoom(request.getParameter("Room"));
		staff.setIpAddress(request.getParameter("ipAddress"));
		
		staffConnector.insertStaff(staff);
	}
	else if(action.equals("update"))
	{
		Staff staff = new Staff();
		staff.setId(Integer.parseInt(request.getParameter("Id")));
		staff.setName(request.getParameter("Name"));
		staff.setLastName(request.getParameter("LastName"));
		staff.setRoom(request.getParameter("Room"));
		staff.setIpAddress(request.getParameter("ipAddress"));
		
		staffConnector.updateStaff(Integer.parseInt(request.getParameter("old_Id")), staff);
	}
	else if(action.equals("delete"))
	{
		String idParameter = request.getParameter("id");
		int id = Integer.parseInt(idParameter);
		
		staffConnector.deleteStaff(id);
	}
}

response.setStatus(301);
response.setHeader("Location", request.getContextPath()+"/stafftable.jsp");
response.setHeader("Connection", "close");
%>
