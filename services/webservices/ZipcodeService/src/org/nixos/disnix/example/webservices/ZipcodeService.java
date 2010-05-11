package org.nixos.disnix.example.webservices;
import java.sql.*;
import java.util.*;
import javax.naming.*;
import javax.sql.*;

/**
 * A web service which provides access to the zipcode database.
 */
public class ZipcodeService
{
	/** JNDI identifier for the database connection pool */
	private String jndiName;
	
	/**
	 * Creates a new ZipcodeService instance
	 * 
	 * @throws Exception If the properties file cannot be opened
	 */
	public ZipcodeService() throws Exception
	{
		/* Read the JNDI name of the database from the properties file */
		Properties props = new Properties();
		props.load(getClass().getResourceAsStream("zipcodedb.properties"));
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
	 * Queries a zipcode from the zipcode database
	 * 
	 * @param zipcode Zipcode identifier
	 * @return The zipcode and associated street and city
	 * @throws Exception If the zipcode cannot be found
	 */
	public Zipcode queryZipcode(String zipcode) throws Exception
	{
		/* Fetch a connection from the connection pool */
		Connection connection = retrieveConnection();
		
		try
		{
			Zipcode ret = null;
			PreparedStatement pstmt = connection.prepareStatement("select Zipcode, Street, City from zipcode where Zipcode = ?");
			pstmt.setString(1, zipcode);
			
			ResultSet result = pstmt.executeQuery();		
			if(result.next())
			{
				ret = new Zipcode();
				ret.setZipcode(result.getString(1));
				ret.setStreet(result.getString(2));
				ret.setCity(result.getString(3));
			}
			
			return ret;
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
	 * Inserts a zipcode into the zipcode database.
	 * 
	 * @param zipcode Zipcode to insert
	 * @return
	 * @throws Exception If the zipcode cannot be inserted
	 */
	public int /*void*/ insertZipcode(Zipcode zipcode) throws Exception
	{
		/* Fetch a connection from the connection pool */
		Connection connection = retrieveConnection();
		
		try
		{
			PreparedStatement pstmt = connection.prepareStatement("insert into zipcode values (?, ?, ?)");
			pstmt.setString(1, zipcode.getZipcode());
			pstmt.setString(2, zipcode.getStreet());
			pstmt.setString(3, zipcode.getCity());
			
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
	 * Updates a zipcode in the zipcode database.
	 * 
	 * @param zipcodeKey Identifier of the zipcode to update
	 * @param zipcode The new zipcode attributes
	 * @return
	 * @throws Exception If the zipcode cannot be updated
	 */
	public int /*void*/ updateZipcode(String zipcodeKey, Zipcode zipcode) throws Exception
	{
		/* Fetch a connection from the connection pool */
		Connection connection = retrieveConnection();
		
		try
		{
			PreparedStatement pstmt = connection.prepareStatement(
				"update zipcode set "+
				"Zipcode = ?, "+
				"Street = ?, "+
				"City = ? "+
				"where Zipcode = ?"
			);
			pstmt.setString(1, zipcode.getZipcode());
			pstmt.setString(2, zipcode.getStreet());
			pstmt.setString(3, zipcode.getCity());
			pstmt.setString(4, zipcodeKey);
			
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
	 * Deletes a zipcode from the zipcode database.
	 * 
	 * @param zipcodeKey Identifier of the zipcode
	 * @return
	 * @throws Exception If the zipcode cannot be deleted
	 */
	public int /*void*/ deleteZipcode(String zipcodeKey) throws Exception
	{
		/* Fetch a connection from the connection pool */
		Connection connection = retrieveConnection();
		
		try
		{
			PreparedStatement pstmt = connection.prepareStatement("delete from zipcode where Zipcode = ?");
			pstmt.setString(1, zipcodeKey);
			
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
