import dataaccess.DataBaseConnection;
import general.Constants;
import graphicuserinterface.DataBaseManagementGUI;
import java.util.ArrayList;
import javafx.application.Application;
import javafx.event.ActionEvent;
import javafx.event.Event;
import javafx.event.EventHandler;
import javafx.event.EventType;
import javafx.fxml.FXML;
import javafx.fxml.FXMLLoader;
import javafx.scene.Parent;
import javafx.scene.Scene;
import javafx.scene.control.Button;
import javafx.scene.control.Label;
import javafx.scene.control.PasswordField;
import javafx.scene.control.TextField;
import javafx.scene.image.Image;
import javafx.stage.Stage;

public class BookStore extends Application implements EventHandler {  
    private Stage               applicationStage;
    private Scene               applicationScene;
    
    @FXML private TextField     campTextNumeUtilizator;
    @FXML private PasswordField campTextParola;
    @FXML private Label         etichetaAfisare;    
    
    public BookStore() {
    }  
    
    @Override
    public void start(Stage mainStage) {
        applicationStage = mainStage;
        try {
            applicationScene = new Scene((Parent)FXMLLoader.load(getClass().getResource(Constants.FXML_DOCUMENT_NAME)));
            applicationScene.addEventHandler(EventType.ROOT,(EventHandler<? super Event>)this);
        } catch (Exception exception) {
            System.out.println ("exception : "+exception.getMessage());
        }        
        applicationStage.setTitle(Constants.APPLICATION_NAME);
        applicationStage.getIcons().add(new Image(Constants.ICON_FILE_NAME));
        applicationStage.setScene(applicationScene);
        applicationStage.show();
    }
    
    @FXML protected void handleButonAcceptareAction(ActionEvent event) throws Exception {
               
        String username = campTextNumeUtilizator.getText();
        String password = campTextParola.getText();
        
        ArrayList<String> attributes = new ArrayList<>();
        attributes.add("utilizatori.numeutilizator");
        attributes.add("utilizatori.parola");
        attributes.add("utilizatori.rol");
                
        ArrayList<ArrayList<Object>> result = DataBaseConnection.getTableContent("utilizatori", attributes, "utilizatori.numeutilizator = '" + username + "'", null, null);
        
        if (result == null)
            etichetaAfisare.setText("Inexistent user");
        else 
        {
            ArrayList<Object> userDetails = result.get(0);
            
            if (!userDetails.get(1).equals(password))
                etichetaAfisare.setText("User and password do not match");
            else if (!userDetails.get(2).equals("administrator"))
                etichetaAfisare.setText("User is not an admin");
            else {
                DataBaseManagementGUI dbmGUI = new DataBaseManagementGUI();
                dbmGUI.start();
            }
        }
    }  
    
    @FXML protected void handleButonRenuntareAction(ActionEvent event) {
        System.exit(0);
    } 
    
    @Override
    public void handle(Event event) {
        if (event.getTarget() instanceof Button && ((Button)event.getTarget()).getText().equals(Constants.SUBMIT_BUTTON) && event.getEventType().equals(ActionEvent.ACTION) && !applicationStage.isFocused()) {
           applicationStage.hide(); 
        }
    }
    
    public static void main(String[] args) {
        launch(args);
    }
}