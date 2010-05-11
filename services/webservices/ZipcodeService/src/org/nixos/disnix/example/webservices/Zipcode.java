package org.nixos.disnix.example.webservices;

/**
 * Represents a zipcode record in the zipcode database
 */
public class Zipcode
{
	/** Zipcode identifier */
	private String zipcode;

	/** Associated street */
	private String street;

	/** Associated city */
	private String city;

	public Zipcode()
	{		
	}
	
	public String getZipcode()
	{
		return zipcode;
	}

	public void setZipcode(String zipcode)
	{
		this.zipcode = zipcode;
	}
	
	public String getStreet()
	{
		return street;
	}

	public void setStreet(String street)
	{
		this.street = street;
	}
	
	public String getCity()
	{
		return city;
	}

	public void setCity(String city)
	{
		this.city = city;
	}
}
