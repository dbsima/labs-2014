package graphicuserinterface;

import dataaccess.DataBaseConnection;
import entities.Author;
import entities.Bill;
import entities.BillDetail;
import entities.Book;
import entities.Category;
import entities.Collection;
import entities.Entity;
import entities.PublishingHouse;
import entities.SupplyOrder;
import entities.SupplyOrderDetail;
import entities.User;
import entities.Writer;
import general.Constants;
import general.ReferrencedTable;
import general.Utilities;
import java.awt.Dimension;
import java.awt.Toolkit;
import java.sql.SQLException;
import java.util.ArrayList;
import javafx.animation.FadeTransition;
import javafx.animation.ScaleTransition;
import javafx.animation.ParallelTransition;
import javafx.animation.Timeline;
import javafx.collections.FXCollections;
import javafx.collections.ObservableList;
import javafx.event.Event;
import javafx.event.EventHandler;
import javafx.event.EventType;
import javafx.geometry.Insets;
import javafx.scene.Scene;
import javafx.scene.control.Button;
import javafx.scene.control.ComboBox;
import javafx.scene.control.Control;
import javafx.scene.control.Label;
import javafx.scene.control.Menu;
import javafx.scene.control.MenuBar;
import javafx.scene.control.MenuItem;
import javafx.scene.control.TableColumn;
import javafx.scene.control.TableView;
import javafx.scene.control.TextField;
import javafx.scene.control.cell.PropertyValueFactory;
import javafx.scene.effect.DropShadow;
import javafx.scene.image.Image;
import javafx.scene.input.MouseEvent;
import javafx.scene.layout.GridPane;
import javafx.scene.layout.VBox;
import javafx.scene.paint.Color;
import javafx.stage.Stage;
import javafx.util.Duration;

public class DataBaseManagementGUI implements EventHandler {
    private Stage                   applicationStage;
    private Scene                   applicationScene;
    private MenuBar                 applicationMenu;    
    public  VBox                    container;    
    private double                  sceneWidth, sceneHeight;
    
    private String                  tableName;
    
    private TableView<Entity>       tableContent;
    private ArrayList<Label>        attributeLabels;
    private ArrayList<Control>      attributeControls; 
    
    public DataBaseManagementGUI() {
        container = new VBox();
        container.setSpacing(Constants.DEFAULT_SPACING);
        container.setPadding(new Insets(Constants.DEFAULT_SPACING, Constants.DEFAULT_SPACING, Constants.DEFAULT_SPACING, Constants.DEFAULT_SPACING));        
    }
    
    public void start() {
        applicationStage = new Stage();
        applicationStage.setTitle(Constants.APPLICATION_NAME);
        applicationStage.getIcons().add(new Image(Constants.ICON_FILE_NAME));
        Dimension screenDimension = Toolkit.getDefaultToolkit().getScreenSize();
        sceneWidth  = Constants.SCENE_WIDTH_SCALE*screenDimension.width;
        sceneHeight = Constants.SCENE_HEITH_SCALE*screenDimension.height;
        applicationScene = new Scene(new VBox(), sceneWidth, sceneHeight);      
        applicationScene.setFill(Color.AZURE);        
        applicationMenu = new MenuBar();  
        for (int currentIndex1 = 0; currentIndex1 < Constants.MENU_STRUCTURE.length; currentIndex1++) {
            Menu menu = new Menu(Constants.MENU_STRUCTURE[currentIndex1][0]);
            for (int currentIndex2 = 1; currentIndex2 < Constants.MENU_STRUCTURE[currentIndex1].length; currentIndex2++) {
                MenuItem menuItem = new MenuItem(Constants.MENU_STRUCTURE[currentIndex1][currentIndex2]);
                menuItem.addEventHandler(EventType.ROOT, (EventHandler<Event>)this);
                menu.getItems().add(menuItem);
            }
            applicationMenu.getMenus().add(menu);   
        } 
        ((VBox)applicationScene.getRoot()).getChildren().addAll(applicationMenu);
        applicationStage.setScene(applicationScene);
        applicationStage.show();        
    }
    
   
    private Entity getCurrentEntity(ArrayList<Object> values) {
        switch(tableName) {
            case "edituri":
                return new PublishingHouse(values);
            case "colectii":
                return new Collection(values);
            case "domenii":
                return new Category(values);                
            case "carti":
                return new Book(values);
            case "scriitori":
                return new Writer(values);                
            case "autori":
                return new Author(values);
            case "comenzi_aprovizionare":
                return new SupplyOrder(values);
            case "detalii_comanda_aprovizionare":
                return new SupplyOrderDetail(values);
            case "utilizatori":
                return new User(values);
            case "facturi":
                return new Bill(values);                
            case "detalii_factura":
                return new BillDetail(values);
        }
        return null;        
    }

    public void populateTableView(String whereClause) {
        try {
            ArrayList<ArrayList<Object>> values = DataBaseConnection.getTableContent(tableName, null, (whereClause==null || whereClause.isEmpty())?null:whereClause, null, null);
            ObservableList<Entity> data = FXCollections.observableArrayList();
            for (ArrayList<Object> record:values) {
                data.add(getCurrentEntity(record));
            }
            tableContent.setItems(data);
        } catch (Exception exception) {
            System.out.println ("exceptie: "+exception.getMessage());
            exception.printStackTrace();
        }
    }
    
    private void setContent() throws SQLException {
        if (tableName == null || tableName.equals("")) {
            return;
        }
        tableContent        = new TableView<>();
        attributeLabels     = new ArrayList<>();
        attributeControls   = new ArrayList<>();    
        container.getChildren().clear();
        ArrayList<String> attributes = new ArrayList<>();
        for (String entry:DataBaseConnection.getTableNames()) {
            if (tableName.toLowerCase().replaceAll(" ","").equals(entry.toLowerCase().replaceAll("_",""))) {    
                tableName = entry;
                attributes = DataBaseConnection.getTableAttributes(tableName);
                break;
            }
        }
        
        final ArrayList<ReferrencedTable> referrencedTables = DataBaseConnection.getReferrencedTables(tableName);
        tableContent.setEditable(true);
        for (int currentIndex = 0; currentIndex < attributes.size(); currentIndex++) {
            TableColumn column = new TableColumn(attributes.get(currentIndex));
            column.setMinWidth((int)(sceneWidth / attributes.size()));
            column.setCellValueFactory(new PropertyValueFactory<Entity,String>(attributes.get(currentIndex)));
            tableContent.getColumns().addAll(column);
            Label attributeLabel = new Label(attributes.get(currentIndex));
            attributeLabels.add(attributeLabel);
            String foreignKeyParentTable = DataBaseConnection.foreignKeyParentTable(attributes.get(currentIndex), referrencedTables);
            if (foreignKeyParentTable != null) {
                ComboBox attributeComboBox = new ComboBox();
                try {
                    ArrayList<ArrayList<Object>> tableDescription = DataBaseConnection.getTableContent(foreignKeyParentTable, DataBaseConnection.getTableDescription(foreignKeyParentTable), null, null, null);
                    for (ArrayList<Object> entityDescription:tableDescription) {
                        attributeComboBox.getItems().addAll(entityDescription.get(0).toString());
                    }                    
                } catch (Exception exception) {
                    System.out.println ("exceptie: "+exception.getMessage());
                }
                attributeComboBox.setMinWidth(Constants.DEFAULT_COMBOBOX_WIDTH);
                attributeComboBox.setMaxWidth(Constants.DEFAULT_COMBOBOX_WIDTH);
                attributeControls.add(attributeComboBox);
            } else {
                TextField attributeTextField = new TextField();
                attributeTextField.setPromptText(attributes.get(currentIndex));
                attributeTextField.setPrefColumnCount(Constants.DEFAULT_TEXTFIELD_WIDTH);
                if (currentIndex==0) {
                    attributeTextField.setEditable(false);
                    try {
                        attributeTextField.setText((DataBaseConnection.getTableNumberOfRows(tableName)+1)+"");
                    } catch (Exception exception) {
                        System.out.println ("exceptie: "+exception.getMessage());
                    }                
                }
                attributeControls.add(attributeTextField);
            }            
        }
        populateTableView(null);
        tableContent.setOnMouseClicked(new EventHandler<MouseEvent>() { 
          @Override
          public void handle(MouseEvent event) {   
              ArrayList<String> values = ((Entity)tableContent.getSelectionModel().getSelectedItem()).getValues();
              int currentIndex = 0;
              for (String value:values) {
                  if (attributeControls.get(currentIndex) instanceof TextField) {
                    ((TextField)attributeControls.get(currentIndex)).setText(value);
                  } else {
                    String foreignKeyParentTable = DataBaseConnection.foreignKeyParentTable(attributeLabels.get(currentIndex).getText(), referrencedTables);
                    try {
                        ArrayList<ArrayList<Object>> tableDescription = DataBaseConnection.getTableContent(foreignKeyParentTable, DataBaseConnection.getTableDescription(foreignKeyParentTable), DataBaseConnection.getTablePrimaryKey(foreignKeyParentTable) +"="+values.get(currentIndex), null, null);
                        ((ComboBox)attributeControls.get(currentIndex)).setValue(tableDescription.get(0).get(0).toString());
                    } catch (Exception exception) {
                        System.out.println ("exceptie: "+exception.getMessage());
                    }
                  }
                  currentIndex++;
              }
          } 
        });
        container.getChildren().addAll(tableContent);
        
        GridPane grid = new GridPane();
        grid.setPadding(new Insets(Constants.DEFAULT_SPACING, Constants.DEFAULT_SPACING, Constants.DEFAULT_SPACING, Constants.DEFAULT_SPACING));
        grid.setVgap(Constants.DEFAULT_GAP);
        grid.setHgap(Constants.DEFAULT_GAP);        
        
        int currentGridRow = 0, currentGridColumn = 2;
        
        // gridPane for inserting a new element in the table
        for (int i = 0; i < attributeLabels.size(); i++) {
            GridPane.setConstraints(attributeLabels.get(i), 0, i);
            grid.add(attributeLabels.get(i), 0, i);
            
            GridPane.setConstraints(attributeControls.get(i), 0, i);
            grid.add(attributeControls.get(i), 1, i);
        }
        
        final Button addButton = new Button(Constants.ADD_BUTTON_NAME);
        addButton.setMaxWidth(Double.MAX_VALUE);
        addButton.setOnMouseClicked(new EventHandler<MouseEvent>() { 
          @Override
          public void handle(MouseEvent event) { 
              ArrayList<String> values = new ArrayList<>();
              int currentIndex = 0;
              for (Control attributeControl:attributeControls) {
                  if (attributeControl instanceof TextField) {
                      values.add(((TextField)attributeControl).getText());
                  } else {
                      try {
                        String foreignKeyParentTable = DataBaseConnection.foreignKeyParentTable(attributeLabels.get(currentIndex).getText(), referrencedTables);
                        ArrayList<String> foreignKeyParentTablePrimaryKey = new ArrayList<>();
                        ArrayList<ArrayList<Object>> tableDescription = DataBaseConnection.getTableContent(foreignKeyParentTable, foreignKeyParentTablePrimaryKey, DataBaseConnection.getTableDescription(foreignKeyParentTable).get(0)+"=\""+((ComboBox)attributeControl).getValue()+"\"", null, null);
                        values.add(tableDescription.get(0).get(0).toString());
                      } catch (Exception exception) {
                          System.out.println ("exceptie: "+exception.getMessage());
                      }
                  }
                  currentIndex++;
              }
              try {
                    DataBaseConnection.insertValuesIntoTable(tableName, null, values, false);
              } catch (Exception exception) {
                  System.out.println ("exceptie: "+exception.getMessage());
              }
              
              populateTableView(null);
              
              for (Control attributeControl:attributeControls) {
                  if (attributeControl instanceof TextField) 
                    ((TextField)attributeControl).setText("");
                   else 
                    ((ComboBox)attributeControl).setValue("");
              }
              try {
                ((TextField)attributeControls.get(0)).setText((DataBaseConnection.getTablePrimaryKeyMaxValue(tableName)+1)+"");
              } catch (Exception exception) {
                System.out.println ("exceptie: "+exception.getMessage());
              }
          } 
        });
        GridPane.setConstraints(addButton, currentGridColumn, currentGridRow++);
        grid.getChildren().add(addButton);
        
        final Button updateButton = new Button(Constants.UPDATE_BUTTON_NAME);
        updateButton.setMaxWidth(Double.MAX_VALUE);
        updateButton.setOnMouseClicked(new EventHandler<MouseEvent>() { 
          @Override
          public void handle(MouseEvent event) {
              // exercise 3
              ArrayList<String> values = new ArrayList<>();
              ArrayList<String> labels = new ArrayList<>();
              int currentIndex = 0;
              
              for (Label attributeLabel:attributeLabels) {
                    labels.add(attributeLabel.getText());
              }
              
              for (Control attributeControl:attributeControls) {
                    values.add("\'" + ((TextField)attributeControl).getText() + "\'");
              }
                try {
                    DataBaseConnection.updateRecordsIntoTable(tableName, labels, values, attributeLabels.get(0).getText()+"="+((TextField)attributeControls.get(0)).getText());
                } catch (Exception ex) {
                    ex.printStackTrace();
                }   
          } 
        });        
        GridPane.setConstraints(updateButton, currentGridColumn, currentGridRow++);
        grid.getChildren().add(updateButton);        
        final Button deleteButton = new Button(Constants.DELETE_BUTTON_NAME);
        deleteButton.setMaxWidth(Double.MAX_VALUE);
        deleteButton.setOnMouseClicked(new EventHandler<MouseEvent>() { 
          @Override
          public void handle(MouseEvent event) { 
              try {
                    DataBaseConnection.deleteRecordsFromTable(tableName,null,null,attributeLabels.get(0).getText()+"="+((TextField)attributeControls.get(0)).getText());
              } catch (Exception exception) {
                  System.out.println ("exceptie: "+exception.getMessage());
              }
              populateTableView(null);
              for (Control attributeControl:attributeControls) {
                  if (attributeControl instanceof TextField) {
                    ((TextField)attributeControl).setText("");
                  } else {
                    ((ComboBox)attributeControl).setValue("");
                  }
              }
              try {
                ((TextField)attributeControls.get(0)).setText((DataBaseConnection.getTablePrimaryKeyMaxValue(tableName)+1)+"");
              } catch (Exception exception) {
                System.out.println ("exceptie: "+exception.getMessage());
              }
              
              populateTableView(null);
          } 
        });        
        GridPane.setConstraints(deleteButton, currentGridColumn, currentGridRow++);
        grid.getChildren().add(deleteButton);        
        
        final Button newButton = new Button(Constants.NEW_RECORD_BUTTON_NAME);
        newButton.setMaxWidth(Double.MAX_VALUE);
        newButton.setOnMouseClicked(new EventHandler<MouseEvent>() { 
          @Override
          public void handle(MouseEvent event) {   
              // TO DO: exercise 4
              populateTableView(null);
              for (Control attributeControl:attributeControls) {
                  if (attributeControl instanceof TextField) {
                    ((TextField)attributeControl).setText("");
                  } else {
                    ((ComboBox)attributeControl).setValue("");
                  }
              }
              try {
                ((TextField)attributeControls.get(0)).setText((DataBaseConnection.getTablePrimaryKeyMaxValue(tableName)+1)+"");
              } catch (Exception exception) {
                System.out.println ("exceptie: "+exception.getMessage());
              }
              
              
          } 
        });
        GridPane.setConstraints(newButton, currentGridColumn, currentGridRow++);
        grid.getChildren().add(newButton);    

        // TO DO: exercise 6 
        
        final DropShadow shadow = new DropShadow();
        final FadeTransition fadeTransition = new FadeTransition(Duration.millis(1000));
        final ScaleTransition scaleTransition = new ScaleTransition(Duration.millis(1000));
        final ParallelTransition parallelTransition = new ParallelTransition(fadeTransition,scaleTransition);
        
        // TO DO: exercise 7
        
        container.getChildren().addAll(grid);
    }    
    
    @Override
    public void handle(Event event) {           
        if (event.getSource() instanceof MenuItem) {
            String entry = ((MenuItem)event.getSource()).getText();
            if (Utilities.isTableName(entry)) {
                ((VBox)applicationScene.getRoot()).getChildren().clear();
                tableName = ((MenuItem)event.getSource()).getText();
                try {
                    setContent();
                } catch (Exception exception) {
                    System.out.println ("exceptie: "+exception.getMessage());
                }
                ((VBox)applicationScene.getRoot()).getChildren().addAll(applicationMenu,container);
                applicationStage.setScene(applicationScene);
                applicationStage.show();
            } else {
                // TO DO: Exercise 5
                AboutGUI agui =  new AboutGUI();
                agui.start();
            }
        }        
    }    
}