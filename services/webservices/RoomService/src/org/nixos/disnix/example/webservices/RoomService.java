package org.nixos.disnix.example.webservices;
import java.sql.*;
import java.util.*;
import javax.naming.*;
import javax.sql.*;

/**
 * A web service which provides access to the room database.
 */
public class RoomService
{
	/** JNDI identifier for the database connection pool */
	private String jndiName;
	
	/**
	 * Creates a new RoomService instance
	 * 
	 * @throws Exception If the properties file cannot be opened
	 */
	public RoomService() throws Exception
	{
		/* Read the JNDI name of the database from the properties file */
		Properties props = new Properties();
		props.load(getClass().getResourceAsStream("roomdb.properties"));
		jndiName = props.getProperty("JNDI");
	}
	
	/** 
	 * Fetch the database connection from the application server
	 * by using the JNDI interface
	 * 
	 * @return Connection Database connection from the connection pool
	 */	
	private Connection retrieveConnection() throws Exception
	{					
		InitialContext ctx = new InitialContext();
		DataSource ds = (DataSource)ctx.lookup(jndiName);
		return ds.getConnection();
	}
	
	/**
	 * Queries all possible room identifiers
	 * 
	 * @return An array with room identifiers 
	 * @throws Exception If the rooms cannot be queried
	 */
	public String[] queryAllRoomIdentifiers() throws Exception
	{
		/* Fetch a connection from the connection pool */
		Connection connection = retrieveConnection();
		
		try
		{
			PreparedStatement pstmt = connection.prepareStatement("select Room from room order by Room");
			ResultSet result = pstmt.executeQuery();
			ArrayList<String> roomIdentifierList = new ArrayList<String>();
			
			while(result.next())
				roomIdentifierList.add(result.getString(1));
			
			String[] roomIdentifier = new String[roomIdentifierList.size()];
			roomIdentifierList.toArray(roomIdentifier);
			return roomIdentifier;
		}
		catch(Exception ex)
		{
			throw ex;
		}
		finally
		{
			/* Release the connection to the connection pool */
			connection.close();
		}
	}
	
	/**
	 * Queries the attributes of a given room
	 * 
	 * @param roomKey Identifier of the room to be queried
	 * @return The given room
	 * @throws Exception If the room does not exists or cannot be queried
	 */
	public Room queryRoom(String roomKey) throws Exception
	{
		/* Fetch a connection from the connection pool */
		Connection connection = retrieveConnection();
		
		try
		{
			PreparedStatement pstmt = connection.prepareStatement("select Room, Zipcode from room where Room = ?");
			pstmt.setString(1, roomKey);
			ResultSet result = pstmt.executeQuery();
			
			if(result.next())
			{
				Room room = new Room();
				room.setRoom(result.getString(1));
				room.setZipcode(result.getString(2));
				
				return room;
			}
			else
				throw new Exception("Room not found!");
		}
		catch(Exception ex)
		{
			throw ex;
		}
		finally
		{
			/* Release the connection to the connection pool */
			connection.close();
		}
	}
		
	/**
	 * Inserts a new room into the room database.
	 * 
	 * @param room Room to insert
	 * @return
	 * @throws Exception If the room cannot be inserted
	 */
	public int /*void*/ insertRoom(Room room) throws Exception
	{
		/* Fetch a connection from the connection pool */
		Connection connection = retrieveConnection();
		
		try
		{
			PreparedStatement pstmt = connection.prepareStatement("insert into room values (?, ?)");
			pstmt.setString(1, room.getRoom());
			pstmt.setString(2, room.getZipcode());
			
			pstmt.executeUpdate();
			
			return 0;
		}
		catch(Exception ex)
		{
			throw ex;
		}
		finally
		{
			/* Release the connection to the connection pool */
			connection.close();
		}
	}
	
	/**
	 * Updates a room in the room database.
	 * 
	 * @param room New room attributes
	 * @param roomKey Identifier of the room that should be updated
	 * @return
	 * @throws Exception If the room cannot be updated
	 */
	public int /*void*/ updateRoom(Room room, String roomKey) throws Exception
	{
		/* Fetch a connection from the connection pool */
		Connection connection = retrieveConnection();
		
		try
		{
			PreparedStatement pstmt = connection.prepareStatement(
				"update room set "+
				"Room = ?, "+
				"Zipcode = ? "+
				"where Room = ?"
			);
			pstmt.setString(1, room.getRoom());
			pstmt.setString(2, room.getZipcode());
			pstmt.setString(3, roomKey);
			
			pstmt.executeUpdate();
			
			return 0;
		}
		catch(Exception ex)
		{
			throw ex;
		}
		finally
		{
			/* Release the connection to the connection pool */
			connection.close();
		}
	}
	
	/**
	 * Deletes a room from the room database.
	 * 
	 * @param roomKey Identifier of the room
	 * @return
	 * @throws Exception If the room cannot be deleted
	 */
	public int /*void*/ deleteRoom(String roomKey) throws Exception
	{
		/* Fetch a connection from the connection pool */
		Connection connection = retrieveConnection();
		
		try
		{
			PreparedStatement pstmt = connection.prepareStatement("delete from room where Room = ?");
			pstmt.setString(1, roomKey);
			
			pstmt.executeUpdate();
			
			return 0;
		}
		catch(Exception ex)
		{
			throw ex;
		}
		finally
		{
			/* Release the connection to the connection pool */
			connection.close();
		}
	}
}
