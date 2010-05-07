package org.nixos.disnix.example.webservices;
import javax.xml.namespace.*;
import org.apache.axis2.*;
import org.apache.axis2.addressing.*;
import org.apache.axis2.client.*;
import org.apache.axis2.rpc.client.*;

public class GeolocationConnector
{
	/** Service client that sends all requests to the Geolocation WebService */
	private RPCServiceClient serviceClient;
	
	/** Namespace of all operation names */
	private static final String NAME_SPACE = "http://webservices.example.disnix.nixos.org";
	
	public GeolocationConnector(String serviceURL) throws AxisFault
	{
		serviceClient = new RPCServiceClient();
		Options options = serviceClient.getOptions();
		EndpointReference targetEPR = new EndpointReference(serviceURL);
		options.setTo(targetEPR);
	}
	
	public String getCountry(String ipAddress) throws AxisFault
	{
		try
		{
			QName operation = new QName(NAME_SPACE, "getCountry");
			Object[] args = { ipAddress };
			Class<?>[] returnTypes = { String.class };
			Object[] response = serviceClient.invokeBlocking(operation, args, returnTypes);
			return (String)response[0];
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
