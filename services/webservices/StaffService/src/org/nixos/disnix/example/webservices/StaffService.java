package org.nixos.disnix.example.webservices;
import java.sql.*;
import java.util.*;
import javax.naming.*;
import javax.sql.*;

public class StaffService
{
	/** JNDI identifier for the database connection pool */
	private String jndiName;
	
	public StaffService() throws Exception
	{
		/* Read the JNDI name of the database from the properties file */
		Properties props = new Properties();
		props.load(getClass().getResourceAsStream("staffdb.properties"));
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
	
	public Staff[] queryAllStaff() throws Exception
	{
		/* Fetch a connection from the connection pool */
		Connection connection = retrieveConnection();
		
		try
		{
			PreparedStatement pstmt = connection.prepareStatement("select STAFF_ID, Name, LastName, Room, ipAddress from staff order by STAFF_ID");
			ResultSet result = pstmt.executeQuery();
			ArrayList<Staff> list = new ArrayList<Staff>();
			
			while(result.next())
			{
				Staff staff = new Staff();
				staff.setId(result.getInt(1));
				staff.setName(result.getString(2));
				staff.setLastName(result.getString(3));
				staff.setRoom(result.getString(4));
				staff.setIpAddress(result.getString(5));
				
				list.add(staff);
			}
			
			Staff[] array = new Staff[list.size()];
			list.toArray(array);
			
			return array;
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
	
	public Staff queryStaff(int id) throws Exception
	{
		/* Fetch a connection from the connection pool */
		Connection connection = retrieveConnection();
		
		try
		{
			PreparedStatement pstmt = connection.prepareStatement("select STAFF_ID, Name, LastName, Room, ipAddress from staff where STAFF_ID = ?");
			pstmt.setInt(1, id);
			ResultSet result = pstmt.executeQuery();
			
			if(result.next())
			{
				Staff staff = new Staff();
				staff.setId(result.getInt(1));
				staff.setName(result.getString(2));
				staff.setLastName(result.getString(3));
				staff.setRoom(result.getString(4));
				staff.setIpAddress(result.getString(5));
				
				return staff;
			}
			else
				throw new Exception("Staff not found!");
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
	
	public int /*void*/ insertStaff(Staff staff) throws Exception
	{
		/* Fetch a connection from the connection pool */
		Connection connection = retrieveConnection();
		
		try
		{
			PreparedStatement pstmt = connection.prepareStatement("insert into staff values (?, ?, ?, ?, ?)");
			pstmt.setInt(1, staff.getId());
			pstmt.setString(2, staff.getName());
			pstmt.setString(3, staff.getLastName());
			pstmt.setString(4, staff.getRoom());
			pstmt.setString(5, staff.getIpAddress());
			
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
	
	public int /*void*/ updateStaff(int id, Staff staff) throws Exception
	{
		/* Fetch a connection from the connection pool */
		Connection connection = retrieveConnection();
		
		try
		{
			PreparedStatement pstmt = connection.prepareStatement(
					"update staff set "+
					"STAFF_ID = ?, "+
					"Name = ?, "+
					"LastName = ?, "+
					"Room = ?, "+
					"ipAddress = ? "+
					"where STAFF_ID = ?"
			);
			pstmt.setInt(1, staff.getId());
			pstmt.setString(2, staff.getName());
			pstmt.setString(3, staff.getLastName());
			pstmt.setString(4, staff.getRoom());
			pstmt.setString(5, staff.getIpAddress());
			pstmt.setInt(6, id);
			
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
	
	public int /*void*/ deleteStaff(int id) throws Exception
	{
		/* Fetch a connection from the connection pool */
		Connection connection = retrieveConnection();
		
		try
		{
			PreparedStatement pstmt = connection.prepareStatement("delete from staff where STAFF_ID = ?");
			pstmt.setInt(1, id);
			
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
