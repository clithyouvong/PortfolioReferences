/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package SteppingStones;

import java.util.ArrayList;

/**
 * SNHU IT-511
 * @author Colby Lithyouvong
 * @version 2021.04.25.001
 */
public class RecipeBox {
    private ArrayList<Recipe> _listOfRecipes;
    
    /**
     * Gets the List of Recipe(s)
     * @return List of Recipe(s)
     */
    public ArrayList<Recipe> GetListOfRecipes(){
        return _listOfRecipes;
    }
    
    /**
     * Sets the List of Recipe(s)
     * @param listOfRecipes List of Recipe(s)
     */
    public void SetListOfRecipes(ArrayList<Recipe> listOfRecipes){
        _listOfRecipes = listOfRecipes;
    }

    /**
     * Default Constructor - Sets the member variables to their defaults
     */
    public RecipeBox(){
        _listOfRecipes = new ArrayList<>();
    }
    
    /**
     * Declared Constructor - Sets the member variables to the passed in values
     * @param listOfRecipes the list of recipes
     */
    public RecipeBox(ArrayList<Recipe> listOfRecipes){
        _listOfRecipes = listOfRecipes;
    }
    
    /**
     * Prints all the recipe details
     * @param selectedRecipe Prints all the recipe details of the passed in recipe name
     */
    public void PrintAllRecipeDetails(String selectedRecipe){
        boolean isFound = false;
        
        for(int i = 0; i<GetListOfRecipes().size(); i++){
            if(GetListOfRecipes().get(i).GetRecipeName().equals(selectedRecipe)){
                GetListOfRecipes().get(i).PrintRecipe();
                isFound = true;
                break;
            }     
        }
        
        if(!isFound){
            System.out.println("No Recipe Found with the name:[" + selectedRecipe + "].");
        }
    }
    
    /**
     * Prints all the recipe names
     * Prints all the recipe names from the instance's List of Recipes
     */
    public void PrintAllRecipeNames(){
        System.out.println("Recipes: ");
        
        if (GetListOfRecipes().size() > 0){
           for(int i=0; i<GetListOfRecipes().size(); i++){
               System.out.println((i + 1) + ": " + GetListOfRecipes().get(i).GetRecipeName());
           }      
        }
        else {
            System.out.println("No Recipes Found");
        }
    }
    
    /**
     * creates a default instance of Recipe and calls the AddNewRecipe() method
     */
    public void AddRecipe(){
        var list = GetListOfRecipes();
        list.add(new Recipe().CreateNewRecipe());
        
        try{
            SetListOfRecipes( list );
        }catch(Exception e){
            System.out.println("Error: " + e.getMessage());
        }
    }
    
    /**
     * Deletes the recipe from the collection by recipe name
     * @param selectedRecipe  the selected recipe name
     */
    public void DeleteRecipe(String selectedRecipe){
        boolean isFound = false;
        var list = GetListOfRecipes();
        
        for(int i = 0; i<list.size(); i++){
            var currentRecipeName = list.get(i).GetRecipeName();
            
            if(currentRecipeName.equals(selectedRecipe)){
                System.out.println("Recipe: "+currentRecipeName+ ", has been removed..");
                list.remove(i);
                isFound = true;
                break;
            }     
        }
        
        if(!isFound){
            System.out.println("No Recipe Found with the name:[" + selectedRecipe + "].");
        }
        
    }
    
    /**
     * Updates Recipe from the collection by recipe name
     * @param selectedRecipe the selected recipe name
     */
    public void UpdateRecipe(String selectedRecipe){
        boolean isFound = false;
        var list = GetListOfRecipes();
        
        for(int i = 0; i<list.size(); i++){
            var currentRecipeName = list.get(i).GetRecipeName();
            
            if(currentRecipeName.equals(selectedRecipe)){
                var recipe = list.get(i);
                recipe = recipe.UpdateRecipe(recipe);
                list.set(i, recipe);
                
                System.out.println("Recipe: "+currentRecipeName+ ", has been updated..");
                isFound = true;
                break;
            }     
        }
        
        if(!isFound){
            System.out.println("No Recipe Found with the name:[" + selectedRecipe + "].");
        }
        
    }
}
