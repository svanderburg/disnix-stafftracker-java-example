package org.nixos.disnix.example.webservices;
import java.sql.*;
import java.util.*;
import javax.naming.*;
import javax.sql.*;

public class ZipcodeService
{
	/** JNDI identifier for the database connection pool */
	private String jndiName;
	
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
