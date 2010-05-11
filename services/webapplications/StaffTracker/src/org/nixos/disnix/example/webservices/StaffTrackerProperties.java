package org.nixos.disnix.example.webservices;
import java.util.*;
import java.io.*;

/**
 * Contains the URLs of the web services that the StaffTracker needs to know.
 */
public class StaffTrackerProperties
{
	/** URL of the GeolocationService */
	private String geolocationServiceURL;
	
	/** URL of the RoomService */
	private String roomServiceURL;
	
	/** URL of the StaffService */
	private String staffServiceURL;
	
	/** URL of the ZipcodeService */
	private String zipcodeServiceURL;
	
	/** The only StaffTrackerProperties instance */
	private static final StaffTrackerProperties instance = new StaffTrackerProperties();
	
	/**
	 * Returns the StaffTrackerProperties singleton instance
	 */
	public static final StaffTrackerProperties getInstance()
	{
		return instance;
	}
	
	/**
	 * Creates a new StaffTrackerProperties interface
	 */
	private StaffTrackerProperties()
	{
		try
		{
			/* Load properties */
			Properties props = new Properties();
			props.load(getClass().getResourceAsStream("stafftracker.properties"));
			
			/* Assign attributes from properties */
			geolocationServiceURL = props.getProperty("geolocationservice.url");
			roomServiceURL = props.getProperty("roomservice.url");
			staffServiceURL = props.getProperty("staffservice.url");
			zipcodeServiceURL = props.getProperty("zipcodeservice.url");
		}
		catch(IOException ex)
		{
			ex.printStackTrace();
		}
	}

	public String getGeolocationServiceURL()
	{
		return geolocationServiceURL;
	}

	public void setGeolocationServiceURL(String geolocationServiceURL)
	{
		this.geolocationServiceURL = geolocationServiceURL;
	}

	public String getRoomServiceURL()
	{
		return roomServiceURL;
	}

	public void setRoomServiceURL(String roomServiceURL)
	{
		this.roomServiceURL = roomServiceURL;
	}

	public String getStaffServiceURL()
	{
		return staffServiceURL;
	}

	public void setStaffServiceURL(String staffServiceURL)
	{
		this.staffServiceURL = staffServiceURL;
	}

	public String getZipcodeServiceURL()
	{
		return zipcodeServiceURL;
	}

	public void setZipcodeServiceURL(String zipcodeServiceURL)
	{
		this.zipcodeServiceURL = zipcodeServiceURL;
	}
}
