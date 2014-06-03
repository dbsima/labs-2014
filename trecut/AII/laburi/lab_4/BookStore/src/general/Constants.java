package general;

public interface Constants {
    final public static String      APPLICATION_NAME            = "Librarie";
    final public static String[][]  MENU_STRUCTURE              = {
                                                                   {"Editare", "Edituri", "Colectii", "Domenii", "Carti", "Scriitori", "Autori", "Comenzi Aprovizionare", "Detalii Comanda Aprovizionare", "Utilizatori", "Facturi", "Detalii Factura" },
                                                                   {"Ajutor", "Despre"}
                                                                  };
    
    final public static String      DATABASE_CONNECTION         = "jdbc:mysql://localhost:3306/librarie";
    final public static String      DATABASE_NAME               = "librarie";
    final public static String      DATABASE_USER               = "root";
    final public static String      DATABASE_PASSWORD           = "servly";
    
    final public static boolean     DEBUG                       = true;
    
    final public static String      ADD_BUTTON_NAME             = "Adauga";
    final public static String      UPDATE_BUTTON_NAME          = "Modifica";
    final public static String      DELETE_BUTTON_NAME          = "Sterge";
    final public static String      NEW_RECORD_BUTTON_NAME      = "Inregistrare Noua";
    final public static String      SEARCH_BUTTON_NAME          = "Cautare";
    
    final public static double      SCENE_WIDTH_SCALE           = 0.99;
    final public static double      SCENE_HEITH_SCALE           = 0.90;
    final public static int         DEFAULT_SPACING             = 10;
    final public static int         DEFAULT_GAP                 = 5;
    final public static int         DEFAULT_COMBOBOX_WIDTH      = 125;
    final public static int         DEFAULT_TEXTFIELD_WIDTH     = 10;
    
    final public static String      FXML_DOCUMENT_NAME          = "authentication.fxml";
    final public static String      ICON_FILE_NAME              = "icon.png";
    
    final public static String      PRIVILEGED_ROLE             = "administrator";
    final public static String      SUBMIT_BUTTON               = "Acceptare";
    final public static String      CANCEL_BUTTON               = "Renuntare";    
    final public static String      ERROR_USERNAME_PASSWORD     = "Nume Utilizator / Parola incorecte !";
    final public static String      ERROR_ACCESS_NOT_ALLOWED    = "Nu aveti suficiente drepturi pentru a accesa aplicatia !";
    final public static String      ABOUT_TEXT                  = "Librarie v 1.0\n(c)Aplicatii Integrate pentru Intreprinderi 2012\n";
}
