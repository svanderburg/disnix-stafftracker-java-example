package org.nixos.disnix.example.webservices;

import javax.xml.namespace.*;
import org.apache.axis2.*;
import org.apache.axis2.addressing.*;
import org.apache.axis2.client.*;
import org.apache.axis2.rpc.client.*;

/**
 * A connector which invokes remote operations of a StaffService
 */
public class StaffConnector
{
	/** Service client that sends all requests to the Staff WebService */
	private RPCServiceClient serviceClient;
	
	/** Namespace of all operation names */
	private static final String NAME_SPACE = "http://webservices.example.disnix.nixos.org";
	
	/**
	 * Creates a new StaffConnector instance
	 * 
	 * @param serviceURL URL of the StaffService
	 * @throws AxisFault If the connection fails
	 */	
	public StaffConnector(String serviceURL) throws AxisFault
	{
		serviceClient = new RPCServiceClient();
		Options options = serviceClient.getOptions();
		EndpointReference targetEPR = new EndpointReference(serviceURL);
		options.setTo(targetEPR);
	}
	
	/**
	 * @see StaffService#queryAllStaff()
	 */
	public Staff[] queryAllStaff() throws AxisFault
	{
		try
		{
			QName operation = new QName(NAME_SPACE, "queryAllStaff");
			Object[] args = {};
			Class<?>[] returnTypes = { Staff[].class };
			Object[] response = serviceClient.invokeBlocking(operation, args, returnTypes);
			return (Staff[])response[0];
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
	
	/**
	 * @see StaffService#queryStaff(int)
	 */
	public Staff queryStaff(int id) throws AxisFault
	{
		try
		{
			QName operation = new QName(NAME_SPACE, "queryStaff");
			Object[] args = { id };
			Class<?>[] returnTypes = { Staff.class };
			Object[] response = serviceClient.invokeBlocking(operation, args, returnTypes);
			return (Staff)response[0];
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
	
	/**
	 * @see StaffService#insertStaff(Staff)
	 */
	public void insertStaff(Staff staff) throws AxisFault
	{
		try
		{
			QName operation = new QName(NAME_SPACE, "insertStaff");
			Object[] args = { staff };
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
	
	/**
	 * @see StaffService#updateStaff(int, Staff)
	 */
	public void updateStaff(int id, Staff staff) throws AxisFault
	{
		try
		{
			QName operation = new QName(NAME_SPACE, "updateStaff");
			Object[] args = { id, staff };
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
	
	/**
	 * @see StaffService#deleteStaff(int)
	 */
	public void deleteStaff(int id) throws AxisFault
	{
		try
		{
			QName operation = new QName(NAME_SPACE, "deleteStaff");
			Object[] args = {id};
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
