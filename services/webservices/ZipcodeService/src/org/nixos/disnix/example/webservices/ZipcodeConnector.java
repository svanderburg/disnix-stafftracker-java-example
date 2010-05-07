package org.nixos.disnix.example.webservices;

import javax.xml.namespace.*;
import org.apache.axis2.*;
import org.apache.axis2.addressing.*;
import org.apache.axis2.client.*;
import org.apache.axis2.rpc.client.*;

public class ZipcodeConnector
{
	/** Service client that sends all requests to the Zipcode WebService */
	private RPCServiceClient serviceClient;
	
	/** Namespace of all operation names */
	private static final String NAME_SPACE = "http://webservices.example.disnix.nixos.org";
	
	public ZipcodeConnector(String serviceURL) throws AxisFault
	{
		serviceClient = new RPCServiceClient();
		Options options = serviceClient.getOptions();
		EndpointReference targetEPR = new EndpointReference(serviceURL);
		options.setTo(targetEPR);
	}
	
	public Zipcode queryZipcode(String zipcode) throws AxisFault
	{
		QName operation = new QName(NAME_SPACE, "queryZipcode");
		Object[] args = { zipcode };
		Class<?>[] returnTypes = { Zipcode.class };
		Object[] response = serviceClient.invokeBlocking(operation, args, returnTypes);
		return (Zipcode)response[0];
	}
	
	public void insertZipcode(Zipcode zipcode) throws AxisFault
	{
		QName operation = new QName(NAME_SPACE, "insertZipcode");
		Object[] args = { zipcode };
		serviceClient.invokeRobust(operation, args);
	}
	
	public void updateZipcode(String zipcodeKey, Zipcode zipcode) throws AxisFault
	{
		QName operation = new QName(NAME_SPACE, "updateZipcode");
		Object[] args = { zipcodeKey, zipcode };
		serviceClient.invokeRobust(operation, args);
	}
	
	public void deleteZipcode(String zipcodeKey) throws AxisFault
	{
		QName operation = new QName(NAME_SPACE, "deleteZipcode");
		Object[] args = { zipcodeKey };
		serviceClient.invokeRobust(operation, args);
	}
}
