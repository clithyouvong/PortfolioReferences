/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package SteppingStones;

import java.util.ArrayList;
import java.util.Scanner;

/**
 * SNHU IT-511
 * @author Colby Lithyouvong
 * @version 2021.04.25.001
 */
public class Recipe {
    
    private String _recipeName;
    private int _servings;
    private ArrayList<Ingredient> _recipeIngredients;
    private double _totalRecipeCalories;
    
    /**
     * Gets the name of the recipe
     * @return the name of the recipe
     */
    public String GetRecipeName(){
        return _recipeName;
    }
    
    /**
     * Sets the name of the recipe
     * @param recipeName the name of the recipe
     */
    public void SetRecipeName(String recipeName){
        _recipeName = recipeName;
    }
    
    /**
     * Gets the Servings for the recipe
     * @return the Servings for the recipe
     */
    public int GetServings(){
        return _servings;
    }
    
    /** 
     * Sets the Servings for the recipe
     * @param servings the Servings for the recipe
     */
    public void SetServings(int servings){
        _servings = servings;
    }
    
    /**
     * Gets the list of names for the recipe Ingredients
     * @return  the list of names for the recipe Ingredients
     */
    public ArrayList<Ingredient> GetRecipeIngredients(){
        return _recipeIngredients;
    }
    
    /**
     * Sets the list of names for the recipe Ingredients
     * @param recipeIngredients the list of names for the recipe Ingredients
     */
    public void SetRecipeIngredients(ArrayList<Ingredient> recipeIngredients){
        _recipeIngredients = recipeIngredients;
    }
    
    /**
     * Adds the recipe Ingredient to the list of recipes
     * @param recipeIngredient the recipe Ingredient
     */    
    public void AddRecipeIngredient(Ingredient recipeIngredient){
        _recipeIngredients.add(recipeIngredient);
    }
     
    /** 
     * Gets the total recipe calories
     * @return  the total recipe calories
     */
    public double GetTotalRecipeCalories(){
        return _totalRecipeCalories;
    }
    
    /**
     * Sets the total recipe calories
     * @param totalRecipeCalories the total recipe calories
     */
    public void SetTotalRecipeCalories (double totalRecipeCalories){
        _totalRecipeCalories = totalRecipeCalories;
    }
    
    /**
     * Default Constructor - Sets the member variables to their defaults
     */
    public Recipe() {
        this._recipeName = "";
        this._servings = 0;
        this._recipeIngredients = new ArrayList<>();
        this._totalRecipeCalories = 0;
    }
    
    /**
     * Declared Constructor - Sets the member variables to the passed in values
     * @param recipeName the recipe name
     * @param servings the servings for the recipe
     * @param recipeIngredients the recipe ingredients 
     * @param totalRecipeCalories the total recipe calories
     */
    public Recipe(String recipeName, int servings, 
    	ArrayList<Ingredient> recipeIngredients, double totalRecipeCalories) 
    {
        this._recipeName = recipeName;
        this._servings = servings;
        this._recipeIngredients = recipeIngredients;
        this._totalRecipeCalories = totalRecipeCalories;
    }
    
    /**
     * Prints the recipe and the associated ingredients
     */
    public void PrintRecipe() {
        double singleServingCalories = 0.0;
        double totalCost = 0.0;
        
        System.out.println("\nRecipe: " + GetRecipeName());
        System.out.println("Serves: " + GetServings());
        
        System.out.println("Ingredients for receipe: [" + GetRecipeName() + "]:");
        for(int i = 0; i<GetRecipeIngredients().size();i++){
            System.out.print((i+1) + " - ");
            GetRecipeIngredients().get(i).PrintIngredient();
            
            _totalRecipeCalories += GetRecipeIngredients().get(i).GetTotalCalories();
            totalCost += GetRecipeIngredients().get(i).GetCost();
        }
        
        singleServingCalories = (_totalRecipeCalories / (double) _servings);
        
        System.out.println("Each serving has: " + singleServingCalories + " calories");
        System.out.println("Cost of Recipe: $" + totalCost);
        System.out.println("");
    }
    
    /** 
     * Creates a new recipe object and associated ingredients
     * @return recipe object
     */
    public Recipe CreateNewRecipe(){
        Recipe recipe = new Recipe();
        recipe = recipe.RecipePromptName(recipe, false);    
        recipe = RecipePromptServings(recipe, false);
        
        boolean addMoreIngredients = true;
        do {          
            Scanner scnr = new Scanner(System.in); 
            
            System.out.println("\nWould you like to enter an ingredient for ["+recipe.GetRecipeName()+"]: (y or n)");
            String reply = scnr.nextLine().toLowerCase();
           
            switch (reply) {
                case "y" -> {
                    Ingredient ingredient = new Ingredient();
                    ingredient = IngredientPromptNameOfIngredient(ingredient, false);
                    ingredient = IngredientPromptUnitOfMeasurement(ingredient, false);
                    ingredient = IngredientPromptIngredientAmount(ingredient, false);
                    ingredient = IngredientPromptCaloriesPerUnit(ingredient, false);
                    ingredient = IngredientPromptCost(ingredient, false);
                    ingredient = IngredientPromptCalculateTotalCaloriesAndPrint(ingredient);
                    recipe.AddRecipeIngredient(ingredient);
                }
                case "n" -> addMoreIngredients = false;
                default -> System.out.println("Unknown Entry:[" + reply + "] Please Try Again. ");
            }
        } while (addMoreIngredients);
        
        return recipe;
    }
    
    
    /** 
     * Updates this recipe object and associated ingredients
     * @param recipe
     * @return 
     */
    public Recipe UpdateRecipe(Recipe recipe){        
        recipe = recipe.RecipePromptName(recipe, true);        
        recipe = recipe.RecipePromptServings(recipe, true);
        
        boolean keepGoing = true;
        do {
            Scanner scnr = new Scanner(System.in); 
            
            System.out.println("\nIngredients Menu: ");
            System.out.println("1 -> Add new Ingredient");
            System.out.println("2 -> Update Existing Ingredient");
            System.out.println("3 -> Delete Existing Ingredient");
            System.out.println("4 -> Print All Ingredients");
            System.out.println("5 -> Done. Return to main menu");
            System.out.println("Please select a menu item:");
            
            if(scnr.hasNextInt()){
                int input = scnr.nextInt();
                
                switch (input) {
                    // Insert
                    case 1 -> UpdateRecipeNewIngredient();
                    // Updated
                    case 2 -> {
                        var list = this.GetRecipeIngredients();
                        if(list.size() > 0){
                            scnr = new Scanner(System.in);
                            System.out.println("Which Ingredient? [Please enter the name of the recipe as shown; not the number..]");
                            for(var i : list){
                                System.out.println("- [" + i.GetNameOfIngredient() + "]");
                            }
                            String selectedIngredientName = scnr.nextLine();
                            this.UpdateRecipeUpdateIngredient(selectedIngredientName);
                        }
                        else {
                            System.out.println("No Ingredients Found");
                        }
                    }
                    // Delete
                    case 3 -> {
                        var list = this.GetRecipeIngredients();
                        if(list.size() > 0){
                            scnr = new Scanner(System.in);
                            System.out.println("Which Ingredient? [Please enter the name of the recipe as shown; not the number..]");
                            for(var i : list){
                                System.out.println("- [" + i.GetNameOfIngredient() + "]");
                            }
                            String selectedIngredientName = scnr.nextLine();
                            this.UpdateRecipeDeleteIngredient(selectedIngredientName);
                        }
                        else {
                            System.out.println("No Ingredients Found");
                        }
                    }
                    // Read Detailed
                    case 4 -> {
                        var list = this.GetRecipeIngredients();
                        
                        if(list.size() > 0){
                            for(var i : list){
                                i.PrintIngredient();
                            }                        
                        }
                        else {
                            System.out.println("No Ingredients Found");
                        }
                    }
                    // End
                    case 5 -> keepGoing = false;
                    // Invalid
                    default -> System.out.println("Invalid entry. Please try again.");
                }
            }else{
                System.out.println("Invalid entry. Please try again.");
            }
        } while(keepGoing);
        
        return recipe;
    }
    
    /**
     * Adds a new ingredient to this recipe
     */
    private void UpdateRecipeNewIngredient(){
        Ingredient ingredient = new Ingredient();

        ingredient = IngredientPromptNameOfIngredient(ingredient, false);
        ingredient = IngredientPromptUnitOfMeasurement(ingredient, false);
        ingredient = IngredientPromptIngredientAmount(ingredient, false);
        ingredient = IngredientPromptCaloriesPerUnit(ingredient, false);
        ingredient = IngredientPromptCost(ingredient, false);
        ingredient = IngredientPromptCalculateTotalCaloriesAndPrint(ingredient);
        this.AddRecipeIngredient(ingredient);
    }
    
    /**
     * Updates the ingredient of this recipe based on the passed in ingredient name
     * @param selectedIngredientName the ingredient name
     */
    private void UpdateRecipeUpdateIngredient(String selectedIngredientName){
        boolean isFound = false;
        var list = this.GetRecipeIngredients();
        
        for(int i = 0; i<list.size(); i++){
            var currentIngredientName = list.get(i).GetNameOfIngredient();
            
            if(currentIngredientName.equals(selectedIngredientName)){
                Ingredient ingredient = list.get(i);
                
                ingredient = IngredientPromptNameOfIngredient(ingredient, true);
                ingredient = IngredientPromptUnitOfMeasurement(ingredient, true);
                ingredient = IngredientPromptIngredientAmount(ingredient, true);
                ingredient = IngredientPromptCaloriesPerUnit(ingredient, true);
                ingredient = IngredientPromptCost(ingredient, true);
                ingredient = IngredientPromptCalculateTotalCaloriesAndPrint(ingredient);
                list.set(i, ingredient);                
                
                isFound = true;
                break;
            }     
        }
        
        if(!isFound){
            System.out.println("No Ingredient Found with the name:[" + selectedIngredientName + "].");
        }
    }
    
    /**
     * Removes the ingredient of this recipe based on the passed in ingredient name
     * @param selectedIngredientName the ingredient name
     */
    private void UpdateRecipeDeleteIngredient(String selectedIngredientName){
        boolean isFound = false;
        var list = this.GetRecipeIngredients();
        
        for(int i = 0; i<list.size(); i++){
            var currentIngredientName = list.get(i).GetNameOfIngredient();
            
            if(currentIngredientName.equals(selectedIngredientName)){
                System.out.println("Ingredient: "+currentIngredientName+ ", has been removed..");
                list.remove(i);
                isFound = true;
                break;
            }     
        }
        
        if(!isFound){
            System.out.println("No Ingredient Found with the name:[" + selectedIngredientName + "].");
        }
    }
    
    
    /**
     * Prompts Recipe Name
     * @param recipe the Recipe Object
     * @param isUpdateMode T/F if so, show the prompt with CURRENT value;
     * @return the modified recipe object that has been passed in
     */
    private Recipe RecipePromptName(Recipe recipe, boolean isUpdateMode){
        Scanner scnr = new Scanner(System.in);
        System.out.println("Please enter the recipe name: " + (isUpdateMode ? "CURRENT:["+this.GetRecipeName()+"]" : ""));
        recipe.SetRecipeName(scnr.nextLine());
        return recipe;
    }
    
    /**
     * Prompts Servings
     * @param recipe the Recipe Object
     * @param isUpdateMode T/F if so, show the prompt with CURRENT value;
     * @return the modified recipe object that has been passed in
     */
    private Recipe RecipePromptServings(Recipe recipe, boolean isUpdateMode){
        Scanner scnr = new Scanner(System.in);
        boolean isServingsRequired = true;
        while(isServingsRequired){
            System.out.println("\nPlease enter the number of servings: " + (isUpdateMode ? "CURRENT:["+recipe.GetServings()+"]" : ""));
            if(scnr.hasNextInt()){
                recipe.SetServings(scnr.nextInt()); 
                isServingsRequired = false;
            }else {
                System.out.println("-- Invalid Entry, expecting a whole number");
                scnr.next();
            }             
        }
        return recipe;
    }
    
    /**
     * Prompts Name of Ingredient
     * Validation - none
     * @param ingredient the Ingredient Object
     * @param isUpdateMode T/F if so, show the prompt with CURRENT value;
     * @return the modified ingredient object that has been passed in
     */
    private Ingredient IngredientPromptNameOfIngredient(Ingredient ingredient, boolean isUpdateMode){
        Scanner scnr = new Scanner(System.in);
        System.out.println("\n1 - Please enter the name of the ingredient: " + (isUpdateMode ? "CURRENT:["+ingredient.GetNameOfIngredient()+"]" : "")); 
        if(scnr.hasNext()){
           ingredient.SetNameOfIngredient(scnr.nextLine()); 

           System.out.println("1 - You've selected: [" + ingredient.GetNameOfIngredient() + "] as the name of the ingredient");
        }
        return ingredient;
    }
    
    /**
     * Prompts Unit of Measurement
     * Validation - is of the list of acceptable units. where as, 
     *    it will still be accepted 
     *    if not part of collection as it isn't logically breaking.
     * @param ingredient the Ingredient Object
     * @param isUpdateMode T/F if so, show the prompt with CURRENT value;
     * @return the modified ingredient object that has been passed in
     */
    private Ingredient IngredientPromptUnitOfMeasurement(Ingredient ingredient, boolean isUpdateMode){
        Scanner scnr = new Scanner(System.in);
        System.out.println("\n2- Please enter the Unit of Measurement (cups, ounces, tablespoons, teaspoons, pounds, grams, kilograms, liters, milliliters): " + (isUpdateMode ? " CURRENT:["+ingredient.GetUnitMeasurement()+"]" : "")); 
        if(scnr.hasNext()){
            ingredient.SetUnitMeasurement(scnr.nextLine());

            switch(ingredient.GetUnitMeasurement().trim().toLowerCase()){
                case    "cups", "ounces", "tablespoons", 
                        "teasoons", "pounds", "grams", 
                        "kilograms", "liters", "milliliters" 
                        -> System.out.println("2- You've selected the accepted unit measurement: [" + ingredient.GetUnitMeasurement() + "]");
                default -> System.out.println("2- The unit of measurement: [" + ingredient.GetUnitMeasurement() + "] is unknown, but was accepted.");
            }
        }
        return ingredient;
    }
    
    /**
     * Prompts Ingredient Amount
     * Validation - Must enter an ingredient amount that is between 1 and MAX Variable inclusive
     * @param ingredient the Ingredient Object
     * @param isUpdateMode T/F if so, show the prompt with CURRENT value;
     * @return the modified ingredient object that has been passed in
     */
    private Ingredient IngredientPromptIngredientAmount(Ingredient ingredient, boolean isUpdateMode){
        Scanner scnr = new Scanner(System.in);
        boolean isIngredientAmountRequired = true;
        while(isIngredientAmountRequired){
            System.out.println("\n3 - Please enter the number of [" + ingredient.GetUnitMeasurement() + "] we need for ["+ ingredient.GetNameOfIngredient() + "] example:[33.65] max:["+ingredient.GetMaxIngredientAmount()+"]: " + (isUpdateMode ? "CURRENT:["+ingredient.GetIngredientAmount()+"]" : "")); 
            if(scnr.hasNextFloat()){
                ingredient.SetIngredientAmount(scnr.nextFloat());

                if(ingredient.GetIngredientAmount() >= 1.0 && ingredient.GetIngredientAmount() <= ingredient.GetMaxIngredientAmount()){
                    System.out.println("3 - Good job! The number you entered is ["+ingredient.GetIngredientAmount()+"].");

                    isIngredientAmountRequired = false;
                } else {
                     System.out.println("3 - The number entered was not between 1.0 and "+ingredient.GetMaxIngredientAmount()+"!");
                }
            }else {
                System.out.println("3 - Invalid Entry, expecting a decimal number");
                scnr.next();
            }      
        }
        return ingredient;
    }
    
    /**
     * Prompts Number of Calories Per Unit    
     * Validation - Must enter a caloric amount that is between 1 and MAX Variable Inclusive
     * @param ingredient the Ingredient Object
     * @param isUpdateMode T/F if so, show the prompt with CURRENT value;
     * @return the modified ingredient object that has been passed in
     */
    private Ingredient IngredientPromptCaloriesPerUnit(Ingredient ingredient, boolean isUpdateMode){
        Scanner scnr = new Scanner(System.in);
        boolean isNumberCaloriesPerUnitRequired = true;
        while(isNumberCaloriesPerUnitRequired){
            System.out.println("\n4- Please enter the number of calories per [" + ingredient.GetUnitMeasurement() + "] example:[35] max:[" + ingredient.GetMaxCaloriesPerUnit() + "]: " + (isUpdateMode ? " CURRENT:["+ingredient.GetNumberCaloriesPerUnit()+"]" : "")); 
            if(scnr.hasNextInt()){
                ingredient.SetNumberCaloriesPerUnit(scnr.nextInt()); 

                if(ingredient.GetNumberCaloriesPerUnit() >= 1 && ingredient.GetNumberCaloriesPerUnit() <= ingredient.GetMaxCaloriesPerUnit()){
                    System.out.println("4 - Good job! The number you entered is ["+ingredient.GetNumberCaloriesPerUnit()+"].");

                    isNumberCaloriesPerUnitRequired = false;
                } else {
                     System.out.println("4 - The number entered was not between 1 and "+ingredient.GetMaxCaloriesPerUnit()+"!");
                }
            }else {
                System.out.println("4 - Invalid Entry, expecting a whole number");
                scnr.next();
            }             
        }
        return ingredient;
    }
    
    /**
     * Prompts Cost Per Unit
     * Validation - Must enter a cost amount that is numeric
     * @param ingredient the Ingredient Object
     * @param isUpdateMode T/F if so, show the prompt with CURRENT value;
     * @return the modified ingredient object that has been passed in
     */
    private Ingredient IngredientPromptCost(Ingredient ingredient, boolean isUpdateMode){
        Scanner scnr = new Scanner(System.in);
        boolean isCostRequired = true;
        
        while(isCostRequired){
            System.out.println("\n5 - Please enter the cost of [" + ingredient.GetNameOfIngredient()+ "] example:[1.36]: " + (isUpdateMode ? "CURRENT:["+ingredient.GetCost()+"]" : "")); 
            if(scnr.hasNextDouble()){
                ingredient.SetCost(scnr.nextDouble()); 

                System.out.println("5 - Good job! The number you entered is ["+ingredient.GetCost()+"].");

                isCostRequired = false;
            }else {
                System.out.println("5 - Invalid Entry, expecting a number");
                scnr.next();
            }             
        } 
        return ingredient;
    }
    
    /**
     * Prompts Total Calories Calculation, Display to user
     * @param ingredient the Ingredient Object
     * @return the modified ingredient object that has been passed in
     */
    private Ingredient IngredientPromptCalculateTotalCaloriesAndPrint(Ingredient ingredient){
        ingredient.SetTotalCalories(ingredient.GetIngredientAmount() * ingredient.GetNumberCaloriesPerUnit());
        System.out.print("\n6 - Setting Total Calories..."); 
        ingredient.PrintIngredient();
        return ingredient;
    }
}