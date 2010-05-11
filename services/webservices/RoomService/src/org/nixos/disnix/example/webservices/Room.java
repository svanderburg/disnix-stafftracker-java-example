package org.nixos.disnix.example.webservices;

/**
 * Represents a room record in the room database
 */
public class Room
{
	/** Room identifier */
	private String room;
	
	/** Associated zipcode of the room */
	private String zipcode;
	
	public Room()
	{		
	}

	public String getRoom()
	{
		return room;
	}

	public void setRoom(String room)
	{
		this.room = room;
	}

	public String getZipcode()
	{
		return zipcode;
	}

	public void setZipcode(String zipcode)
	{
		this.zipcode = zipcode;
	}
}
