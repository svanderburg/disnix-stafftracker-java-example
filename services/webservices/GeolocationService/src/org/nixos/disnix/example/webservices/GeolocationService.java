package org.nixos.disnix.example.webservices;
import java.io.*;
import org.apache.axis2.*;
import org.apache.axis2.context.*;
import org.apache.axis2.service.*;
import com.maxmind.geoip.*;

/**
 * A web service which returns the country of origin of a specific IP address.
 */
public class GeolocationService implements Lifecycle
{
	/** GeoIP lookup service */
	private LookupService lookup;
	
	/**
	 * @see Lifecycle#init(ServiceContext)
	 */
	@Override
	public void init(ServiceContext context) throws AxisFault
	{
		try
		{
			/* Initialize the GeoIP lookup service */
			File file = new File(getClass().getResource("/GeoIP.dat").getFile());
			lookup = new LookupService(file);
		}
		catch(Exception ex)
		{
			ex.printStackTrace();
			throw new AxisFault(ex.toString());
		}
	}
		
	/**
	 * @see Lifecycle#destroy(ServiceContext)
	 */
	@Override
	public void destroy(ServiceContext context)
	{
		try
		{
			/* Close the lookup service */			
			lookup.close();
		}
		catch(Exception ex)
		{
			ex.printStackTrace();
		}
	}
	
	/**
	 * Returns the country of origin from a given IP address.
	 * 
	 * @param ipAddress IP address of a host
	 * @return Country of origin
	 */
	public String getCountry(String ipAddress)
	{
		Country country = lookup.getCountry(ipAddress);
		return country.getName();
	}
}
