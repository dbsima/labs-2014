package graphicuserinterface;

import general.Constants;
import java.awt.Dimension;
import javafx.geometry.Insets;
import java.awt.Toolkit;
import javafx.scene.input.MouseEvent;
import java.util.ResourceBundle.Control;
import javafx.event.Event;
import javafx.event.EventHandler;
import javafx.event.EventType;
import javafx.scene.Group;
import javafx.scene.Scene;
import javafx.scene.control.Button;
import javafx.scene.control.Label;
import javafx.scene.image.Image;
import javafx.scene.layout.GridPane;
import javafx.scene.layout.VBox;
import javafx.scene.paint.Color;
import javafx.stage.Stage;

public class AboutGUI implements EventHandler {

    private Stage                   applicationStage;
    private Scene                   applicationScene;    
    private Label                   label;
    private Button                  button;
    
    private double                  sceneWidth, sceneHeight;
    
    public AboutGUI() {       
    }
    
    public void start() {
        applicationStage = new Stage();
        applicationStage.setTitle(Constants.ABOUT_TEXT);
        
        button = new Button("Inchide");
        button.setMaxWidth(Double.MAX_VALUE);
        
        Dimension screenDimension = Toolkit.getDefaultToolkit().getScreenSize();
        sceneWidth  = Constants.SCENE_WIDTH_SCALE*screenDimension.width/2;
        sceneHeight = Constants.SCENE_HEITH_SCALE*screenDimension.height/2;
        
        Group group = new Group(Constants.ABOUT_TEXT, button);
        
        applicationScene = new Scene(group, sceneWidth, sceneHeight);      
        applicationScene.setFill(Color.AZURE);
        
        applicationStage.setScene(applicationScene);
        applicationStage.show(); 
    }
    
    @Override
    public void handle(Event event) {     
        // TO DO: Exercise 5
        
        button.setOnMouseClicked(new EventHandler<MouseEvent>() { 
          @Override
          public void handle(MouseEvent event) {
              applicationStage.close();
          } 
        });
    }     
}