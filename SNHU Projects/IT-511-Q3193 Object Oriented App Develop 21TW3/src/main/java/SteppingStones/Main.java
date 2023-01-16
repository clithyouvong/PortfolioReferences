/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package SteppingStones;

import java.util.Scanner;

/**
 * SNHU IT-511
 * @author Colby Lithyouvong
 * @version 2021.04.25.001
 */
public class Main {
    /**
     * Driver Class, Driver Main
     * @param args 
     */
    public static void main(String[] args) {
        boolean keepGoing = true;
        Scanner menuScnr;

        // Create a Recipe Box
        RecipeBox myRecipeBox = new RecipeBox(); 
        

        do{
            // Print a menu for the user to select one of the four options:
            System.out.println("");
            System.out.println("-------------------------------");
            System.out.println("Main Menu: ");
            System.out.println("1 -> Add Recipe");
            System.out.println("2 -> Edit Recipe");
            System.out.println("3 -> Delete Recipe");
            System.out.println("4 -> Print All Recipe Details");
            System.out.println("5 -> Print All Recipe Names");
            System.out.println("6 -> Quit");
            System.out.println("Please select a menu item:");
            menuScnr = new Scanner(System.in);
            

            if(menuScnr.hasNextInt()){
                int input = menuScnr.nextInt();
                
                switch (input) {
                    // Insert
                    case 1 -> myRecipeBox.AddRecipe();
                    // Update
                    case 2 -> {
                        if(myRecipeBox.GetListOfRecipes().size() > 0){
                            menuScnr = new Scanner(System.in);
                            System.out.println("Which recipe? [Please enter the name of the recipe as shown; not the number..]");
                            myRecipeBox.PrintAllRecipeNames();
                            String selectedRecipeName = menuScnr.nextLine();
                            myRecipeBox.UpdateRecipe(selectedRecipeName); 
                        }
                        else {
                            System.out.println("No Recipes Found");
                        }
                    }
                    // Delete
                    case 3 -> {
                        if(myRecipeBox.GetListOfRecipes().size() > 0){
                            menuScnr = new Scanner(System.in);
                            System.out.println("Which recipe? [Please enter the name of the recipe as shown; not the number..]");
                            myRecipeBox.PrintAllRecipeNames();
                            String selectedRecipeName = menuScnr.nextLine();
                            myRecipeBox.DeleteRecipe(selectedRecipeName); 
                        }
                        else {
                            System.out.println("No Recipes Found");
                        }
                    }
                    // Read Detailed
                    case 4 -> {
                        if(myRecipeBox.GetListOfRecipes().size() > 0){
                            menuScnr = new Scanner(System.in);
                            System.out.println("Which recipe? [Please enter the name of the recipe as shown; not the number..]");
                            myRecipeBox.PrintAllRecipeNames();
                            String selectedRecipeName = menuScnr.nextLine();
                            myRecipeBox.PrintAllRecipeDetails(selectedRecipeName);                            
                        }
                        else {
                            System.out.println("No Recipes Found");
                        }
                    }
                    // Read Summary Names
                    case 5 -> myRecipeBox.PrintAllRecipeNames();
                    // Exit
                    case 6 -> keepGoing = false;
                    default -> System.out.println("Invalid entry. Please try again.");
                }
            }else{
                System.out.println("Invalid entry. Please try again.");
            }
        } while (keepGoing);
    }
}
