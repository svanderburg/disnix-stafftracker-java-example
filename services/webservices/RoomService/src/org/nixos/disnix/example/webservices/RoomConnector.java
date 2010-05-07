package org.nixos.disnix.example.webservices;
import javax.xml.namespace.*;
import org.apache.axis2.*;
import org.apache.axis2.addressing.*;
import org.apache.axis2.client.*;
import org.apache.axis2.rpc.client.*;

public class RoomConnector
{
	/** Service client that sends all requests to the Staff WebService */
	private RPCServiceClient serviceClient;
	
	/** Namespace of all operation names */
	private static final String NAME_SPACE = "http://webservices.example.disnix.nixos.org";
	
	public RoomConnector(String serviceURL) throws AxisFault
	{
		serviceClient = new RPCServiceClient();
		Options options = serviceClient.getOptions();
		EndpointReference targetEPR = new EndpointReference(serviceURL);
		options.setTo(targetEPR);
	}
	
	public String[] queryAllRoomIdentifiers() throws AxisFault
	{
		try
		{
			QName operation = new QName(NAME_SPACE, "queryAllRoomIdentifiers");
			Object[] args = {};
			Class<?>[] returnTypes = { String[].class };
			Object[] response = serviceClient.invokeBlocking(operation, args, returnTypes);
			return (String[])response[0];
		}
		catch(AxisFault ex)
		{
			throw ex;
		}
		finally
		{
			serviceClient.cleanup();
			serviceClient.cleanupTransport();
		}
	}
	
	public Room queryRoom(String roomKey) throws AxisFault
	{
		try
		{
			QName operation = new QName(NAME_SPACE, "queryRoom");
			Object[] args = { roomKey };
			Class<?>[] returnTypes = { Room.class };
			Object[] response = serviceClient.invokeBlocking(operation, args, returnTypes);
			return (Room)response[0];
		}
		catch(AxisFault ex)
		{
			throw ex;
		}
		finally
		{
			serviceClient.cleanup();
			serviceClient.cleanupTransport();
		}
	}
	
	public void insertRoom(Room room) throws AxisFault
	{
		try
		{
			QName operation = new QName(NAME_SPACE, "insertRoom");
			Object[] args = { room };
			serviceClient.invokeRobust(operation, args);
		}
		catch(AxisFault ex)
		{
			throw ex;
		}
		finally
		{
			serviceClient.cleanup();
			serviceClient.cleanupTransport();
		}
	}
	
	public void updateRoom(Room room, String roomKey) throws AxisFault
	{
		try
		{
			QName operation = new QName(NAME_SPACE, "updateRoom");
			Object[] args = { room, roomKey };
			serviceClient.invokeRobust(operation, args);
		}
		catch(AxisFault ex)
		{
			throw ex;
		}
		finally
		{
			serviceClient.cleanup();
			serviceClient.cleanupTransport();
		}
	}
	
	public void deleteRoom(String roomKey) throws AxisFault
	{
		try
		{
			QName operation = new QName(NAME_SPACE, "deleteRoom");
			Object[] args = { roomKey };
			serviceClient.invokeRobust(operation, args);
		}
		catch(AxisFault ex)
		{
			throw ex;
		}
		finally
		{
			serviceClient.cleanup();
			serviceClient.cleanupTransport();
		}
	}
}
