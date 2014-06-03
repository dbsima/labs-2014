package dataaccess;

import general.*;
import java.math.BigDecimal;
import java.sql.*;
import java.util.*;

public class DataBaseConnection {
    public static Connection        dbConnection;
    public static DatabaseMetaData  dbMetaData;
    public static Statement         stmt;

    public DataBaseConnection() { }

    public static void openConnection() throws SQLException {
        dbConnection  = DriverManager.getConnection(general.Constants.DATABASE_CONNECTION, general.Constants.DATABASE_USERNAME, general.Constants.DATABASE_PASSWORD);
        dbMetaData    = dbConnection.getMetaData();
        stmt          = dbConnection.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_UPDATABLE);
    }

    public static void closeConnection() throws SQLException {
        stmt.close();
    }
    
    public static ArrayList<String> getTableNames() throws SQLException {
        openConnection();
        ArrayList<String> result = new ArrayList<>();
        ResultSet RS = dbMetaData.getTables(Constants.DATABASE_NAME, null, null, null);
        while (RS.next()) {
            result.add(RS.getString("TABLE_NAME"));
        }
        closeConnection();
        return result;
    }
    
    public static int getTableNumberOfRows(String tableName) throws SQLException {
        int numberOfRows = -1;
        openConnection();
        
        String query  = "SELECT COUNT(*) FROM " + tableName;
        ResultSet RS = stmt.executeQuery(query);
        
        RS.next();
        numberOfRows = Integer.parseInt(RS.getString(1));
        
        closeConnection();
        return numberOfRows;
    }
    
    public static int getTableNumberOfColumns(String tableName) throws SQLException {
        int result = 0;
        openConnection();
        ResultSet RS = dbMetaData.getColumns(Constants.DATABASE_NAME, null, tableName, null);
        while (RS.next()) 
            result++;
        closeConnection();
        return result;
    }

    public static String getTablePrimaryKey(String tableName) throws SQLException {
        String result = null;
        openConnection();
        ResultSet RS = dbMetaData.getPrimaryKeys(Constants.DATABASE_NAME, null, tableName);
        while (RS.next())
            result += RS.getString("COLUMN_NAME")+" ";
        closeConnection();
        return result != null ? result.trim() : result;
    }    
    
    public static ArrayList<String> getTableAttributes(String tableName) throws SQLException {
        ArrayList<String> result = new ArrayList<>();
        openConnection();
        ResultSet RS = dbMetaData.getColumns(Constants.DATABASE_NAME, null, tableName, null);
        while (RS.next())
            result.add(RS.getString("COLUMN_NAME"));
        closeConnection();
        return result;
    }

    public static ArrayList<ArrayList<Object>> getTableContent(String tableName, ArrayList<String> attributes, String whereClause, String orderByClause, String groupByClause) throws SQLException {
        openConnection();
        String query = "SELECT ";
        int numberOfColumns = -1;
        if (attributes == null) {
            numberOfColumns = getTableNumberOfColumns(tableName);
            query += "*";            
        }
        else {
            numberOfColumns = attributes.size();
            for (String attribute:attributes) {
                query += attribute+", ";
            }
            query = query.substring(0,query.length()-2);            
        }
        query += " FROM "+tableName;
        if (whereClause != null) {
            query += " WHERE "+whereClause;
        }
        if (groupByClause != null) {
            query += " GROUP BY "+groupByClause;
        }
        if (orderByClause != null) {
            query += " ORDER BY "+orderByClause;
        }
        if (general.Constants.DEBUG) {
            System.out.println("query: "+query);
        }
        if (numberOfColumns == -1) {
            return null;
        }      
        ArrayList<ArrayList<Object>> dataBaseContent = new ArrayList<>();
        ResultSet result = stmt.executeQuery(query);  
        int currentRow = 0;
        while (result.next()) {
            dataBaseContent.add(new ArrayList<>());
            for (int currentColumn = 0; currentColumn < numberOfColumns; currentColumn++) {
                dataBaseContent.get(currentRow).add(result.getString(currentColumn+1));
            }
            currentRow++;
        }
        closeConnection();
        return dataBaseContent;
    }

    public static void insertValuesIntoTable(String tableName, ArrayList<String> attributes, ArrayList<String> values, boolean skipPrimaryKey) throws Exception {
        openConnection();
        String query = "INSERT INTO "+tableName+" (";
        if (attributes == null) {
            attributes = getTableAttributes(tableName);
            if (skipPrimaryKey) {
                attributes.remove(0);
            }
        }
        if (attributes.size() != values.size()) {
            throw new Exception ("Attributes size does not match values size !"+attributes.size()+" "+values.size());
        }
        for (String attribute:attributes) {
            query += attribute + ", ";
        }      
        query = query.substring(0,query.length()-2);
        query += ") VALUES (";
        for (String currentValue: values) {
            query += "\'"+currentValue+"\',";
        }
        query = query.substring(0,query.length()-1);
        query += ")";
        if (general.Constants.DEBUG) {
            System.out.println("query: "+query);
        }
        stmt.execute(query);
        closeConnection();
    }

    public static void updateRecordsIntoTable(String tableName, ArrayList<String> attributes, ArrayList<String> values, String whereClause) throws Exception {
        openConnection();
        String query = "UPDATE "+tableName+" SET ";
        if (attributes == null) {
            attributes = getTableAttributes(tableName);
        }
        if (attributes.size() != values.size()) {
            throw new Exception ("Attributes size does not match values size.");
        }
        for (int currentIndex = 0; currentIndex < values.size(); currentIndex++) {
            query += attributes.get(currentIndex)+"="+values.get(currentIndex)+", ";
        }
        query = query.substring(0,query.length()-2);
        query += " WHERE ";
        if (whereClause != null ) {
            query += whereClause;
        } else {
            query += getTablePrimaryKey(tableName)+"=\'"+values.get(0)+"\'";
        }
        if (general.Constants.DEBUG) {
            System.out.println("query: "+query);
        }
        stmt.execute(query);
        closeConnection();
    }

    public static void deleteRecordsFromTable(String tableName, ArrayList<String> attributes, ArrayList<String> values, String whereClause) throws Exception {
        openConnection();
        
        String query = "DELETE FROM " + tableName + " WHERE ";
        
        if (values == null)
        {
            if (whereClause != null) {
                query += whereClause;
            }
            
            if (general.Constants.DEBUG) {
                System.out.println("query: "+query);
            }
        }
        else
        {
            if (attributes.size() != values.size()) {
                throw new Exception ("Attributes size does not match values size.");
            }
            
            int currentIndex = 0;
            for (; currentIndex < values.size()- 1; currentIndex++) {
                query += attributes.get(currentIndex)+"="+values.get(currentIndex)+" AND ";
            }
            query += attributes.get(currentIndex)+"="+values.get(currentIndex);
                    
            if (general.Constants.DEBUG) {
                System.out.println("query: "+query);
            }
        }
        System.out.println(query);    
        stmt.execute(query);
        
        closeConnection();
    }
    
    public static String executeProcedure(String procedureName, ArrayList<String> parameterTypes, ArrayList<String> parameterValues, ArrayList<Integer> parameterDataTypes) throws SQLException {
        String result = new String();
        openConnection();
                
        CallableStatement cs = dbConnection.prepareCall("{? = call " + procedureName + "()}");
        
        Long CNP = new Long("1580802702610");
        cs.setLong(1, CNP);
        cs.registerOutParameter(2, Types.DECIMAL);
                
        cs.executeQuery();
        Long res = cs.getLong(1);
        result = String.valueOf(res);
        
        closeConnection();
        return result;
    }
    
    public static ArrayList<ReferrencedTable> getReferrencedTables(String tableName) throws SQLException {
        ArrayList<ReferrencedTable> result = new ArrayList<>();
        openConnection();
        
        // 
        String query = "SELECT TABLE_NAME, COLUMN_NAME FROM information_schema.KEY_COLUMN_USAGE WHERE referenced_table_name = '" + tableName + "'";
        System.out.println(query);
        ResultSet RS = stmt.executeQuery(query);
        
        while(RS.next()) 
        {
            ReferrencedTable rt = new ReferrencedTable(RS.getString("TABLE_NAME"), RS.getString("COLUMN_NAME"));
            result.add(rt);
        }
        
        closeConnection();
        return result;
    }
    
}
