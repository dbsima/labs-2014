import com.sun.rowset.CachedRowSetImpl;
import com.sun.rowset.FilteredRowSetImpl;
import dataaccess.DataBaseConnection;
import general.Constants;
import general.ReferrencedTable;
import java.io.BufferedReader;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.io.UnsupportedEncodingException;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Arrays;
import javax.sql.RowSet;
import javax.sql.rowset.CachedRowSet;
import javax.sql.rowset.FilteredRowSet;
import javax.sql.rowset.Predicate;

public class BookStore {
    public static void main(String[] args) throws SQLException, FileNotFoundException, UnsupportedEncodingException, IOException, Exception {
        
        // For each table show the number of rows 
        
        for (String tableName : DataBaseConnection.getTableNames())
        {
            System.out.println(tableName + " - " + DataBaseConnection.getTableNumberOfRows(tableName));
        }
        
        
        // Print the list of every book available (in stock) in books.txt
        
        // getTableContent(String tableName, ArrayList<String> attributes, String whereClause, String orderByClause, String groupByClause)
        ArrayList<String> attributes = new ArrayList<>();
        attributes.add("scriitori.nume");
        attributes.add("scriitori.prenume");
        attributes.add("carti.titlu");
        attributes.add("edituri.denumire");
        attributes.add("carti.an_aparitie");
        
        ArrayList<ArrayList<Object>> result = DataBaseConnection.getTableContent("autori, scriitori, carti, edituri", attributes, "carti.id_carte = autori.id_carte AND autori.id_scriitor = scriitori.id_scriitor AND carti.id_editura = edituri.id_editura AND carti.stoc > 0", null, null);
        
        // crete and open the output file
        PrintWriter writer = new PrintWriter("books.txt");
        
        // write the results
        for (ArrayList<Object> bookDetails : result)
            writer.println(bookDetails);
        
        // close the output file
        writer.close();
    
        
        // Insert single row in the table "utilizatori" with data from keyboard
        
        // create the list of attributes
        attributes = new ArrayList<>();
        attributes.add("CNP");
        attributes.add("nume");
        attributes.add("prenume");
        attributes.add("email");
        attributes.add("tip");
        attributes.add("nume_utilizator");
        attributes.add("adresa");
        attributes.add("parola");
        
        // read data from keyboard and put it as value in the right order
        
        BufferedReader buffer = new BufferedReader(new InputStreamReader(System.in));
        String value;
        ArrayList<String> values = new ArrayList<>();
        /*
        for (String attribute: attributes)
        {
            value = buffer.readLine();
            values.add(value);
        }
        
        // insertValuesIntoTable(String tableName, ArrayList<String> attributes, ArrayList<String> values, boolean skipPrimaryKey)
        DataBaseConnection.insertValuesIntoTable("utilizatori", attributes, values, false);
        */
        
        // Modify the orders (stare='plasată') to Aramis (id_editura = 73, 
        // CIF = '247764320') so that the quantities are bigger with 20%
       
        // create the list of attributes
        attributes = new ArrayList<>();
        attributes.add("cantitate");
        
        // compute the formula for the quantity and add it in the values list
        values = new ArrayList<>();
        values.add("cantitate + cantitate / 5");

        // updateRecordsIntoTable(String tableName, ArrayList<String> attributes, ArrayList<String> values, String whereClause)
        DataBaseConnection.updateRecordsIntoTable("comenzi_aprovizionare, detalii_comanda_aprovizionare", attributes, values, "comenzi_aprovizionare.id_comanda_aprovizionare = detalii_comanda_aprovizionare.id_comanda_aprovizionare AND comenzi_aprovizionare.id_editura = 73 AND comenzi_aprovizionare.stare='plasata'");

        // testare mysql: select detalii_comanda_aprovizionare.cantitate, detalii_comanda_aprovizionare.id_comanda_aprovizionare from comenzi_aprovizionare, detalii_comanda_aprovizionare where comenzi_aprovizionare.id_comanda_aprovizionare = detalii_comanda_aprovizionare.id_comanda_aprovizionare AND comenzi_aprovizionare.id_editura = 73 AND comenzi_aprovizionare.stare='plasata';

       
        // Delete all editures that do not have commercialized books
        DataBaseConnection.deleteRecordsFromTable("edituri", null, null, "NOT EXISTS (SELECT NULL FROM carti WHERE carti.id_editura = edituri.id_editura)");
        
        // test attributes and values
        /*
        attributes = new ArrayList<>();
        attributes.add("id_editura");
        attributes.add("denumire");
        
        values = new ArrayList<>();
        values.add("3");
        values.add("'Corint'");
        
        DataBaseConnection.deleteRecordsFromTable("edituri", attributes, values, "NOT EXISTS (SELECT NULL FROM carti c WHERE c.id_editura = edituri.id_editura)");
        */
        
        // 7
        ArrayList<String> parameterTypes = new ArrayList<>();
        ArrayList<String> parameterValues = new ArrayList<>();
        ArrayList<Integer> parameterDataTypes = new ArrayList<>();
        
        //String res = DataBaseConnection.executeProcedure("calculate_bill_value", parameterTypes, parameterValues, parameterDataTypes);
        //System.out.println(res);
        
        
        // testing 9
        /*
        for (ReferrencedTable rt: DataBaseConnection.getReferrencedTables("utilizatori"))
        {
                System.out.println(rt.getParentTable() + " - " + rt.getAttributeName());
        }
        */
        
        
        // Show all the books published by an editure unsing a deconnected RowSet
        CachedRowSetImpl rowSetImpl = new CachedRowSetImpl();
            
        rowSetImpl.setUrl(Constants.DATABASE_CONNECTION);
        rowSetImpl.setUsername(Constants.DATABASE_USERNAME);
        rowSetImpl.setPassword(Constants.DATABASE_PASSWORD);

        rowSetImpl.setCommand("SELECT carti.titlu, carti.pret, edituri.denumire, colectii.denumire, domenii.denumire FROM carti, edituri, colectii, domenii WHERE carti.id_editura = edituri.id_editura AND carti.id_colectie = colectii.id_colectie AND carti.id_domeniu = domenii.id_domeniu GROUP BY carti.id_editura");
        rowSetImpl.execute();
        
        
        while(rowSetImpl.next())
        {
            System.out.println(rowSetImpl.getString(1) + " - " + rowSetImpl.getString(2) + " - " + rowSetImpl.getString(3) + " - " + rowSetImpl.getString(4) + " - " + rowSetImpl.getString(5));
        }
        
        
        
        // Filter the above command to list only the books with prices in (1000, 5000) 
        class PriceFilter implements Predicate {
                @Override
                public boolean evaluate(RowSet rs) {
                    CachedRowSet rowSet = (CachedRowSet) rs;
                    Float pret = null;
                try {
                    pret = new Float(rowSet.getString("pret"));
                    return (pret >= 1000 && pret <= 5000);
                } catch (SQLException ex) {
                    System.out.println();
                }
                    return false;
                }

            @Override
            public boolean evaluate(Object arg0, int arg1) throws SQLException {
                throw new UnsupportedOperationException("Not supported yet.");
            }

            @Override
            public boolean evaluate(Object arg0, String arg1) throws SQLException {
                throw new UnsupportedOperationException("Not supported yet.");
            }
            
        }
        
        rowSetImpl = new CachedRowSetImpl();
            
        rowSetImpl.setUrl(Constants.DATABASE_CONNECTION);
        rowSetImpl.setUsername(Constants.DATABASE_USERNAME);
        rowSetImpl.setPassword(Constants.DATABASE_PASSWORD);

        rowSetImpl.setCommand("SELECT carti.titlu, carti.pret, edituri.denumire, colectii.denumire, domenii.denumire FROM carti, edituri, colectii, domenii WHERE carti.id_editura = edituri.id_editura AND carti.id_colectie = colectii.id_colectie AND carti.id_domeniu = domenii.id_domeniu GROUP BY carti.id_editura");
        rowSetImpl.execute();
        
        FilteredRowSet filteredRowSetImpl = new FilteredRowSetImpl(); 
        filteredRowSetImpl.populate(rowSetImpl);
        filteredRowSetImpl.setFilter(new PriceFilter());

        System.out.println("-------------------------------------------------");
        
        while(filteredRowSetImpl.next())
        {
            System.out.println(filteredRowSetImpl.getString(1) + " - " + filteredRowSetImpl.getString(2) + " - " + filteredRowSetImpl.getString(3) + " - " + filteredRowSetImpl.getString(4) + " - " + filteredRowSetImpl.getString(5));
        }
    }
}

