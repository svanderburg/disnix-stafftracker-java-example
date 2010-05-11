package org.nixos.disnix.example.webservices;

/**
 * Represents a staff record in the staff database
 */
public class Staff
{
	/** Staff ID number */
	private int id;

	/** Name of the staff member */
	private String name;
	
	/** Last name of the staff member */
	private String lastName;
	
	/** Room of the staff member */
	private String room;
	
	/** Staff member's IP address */
	private String ipAddress;
	
	public Staff()
	{	
	}
	
	public int getId()
	{
		return id;
	}

	public void setId(int id)
	{
		this.id = id;
	}

	public String getName()
	{
		return name;
	}

	public void setName(String name)
	{
		this.name = name;
	}

	public String getLastName()
	{
		return lastName;
	}

	public void setLastName(String lastName)
	{
		this.lastName = lastName;
	}

	public String getRoom()
	{
		return room;
	}

	public void setRoom(String room)
	{
		this.room = room;
	}

	public String getIpAddress()
	{
		return ipAddress;
	}

	public void setIpAddress(String ipAddress)
	{
		this.ipAddress = ipAddress;
	}
}
