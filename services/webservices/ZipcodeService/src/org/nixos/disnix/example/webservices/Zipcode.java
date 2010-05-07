package org.nixos.disnix.example.webservices;

public class Zipcode
{
	private String zipcode;

	private String street;

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
