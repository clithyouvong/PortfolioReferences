package SteppingStones;

/**
 * SNHU IT-511
 * @author Colby Lithyouvong
 * @version 2021.04.25.001
 */
public class Ingredient { 
    private String _nameOfIngredient;
    private String _unitMeasurement;
    private Float _ingredientAmount; 
    private Float _MAX_INGREDIENT_AMOUNT = 100.0f;
    private int _numberCaloriesPerUnit;
    private int _MAX_CALORIES_PER_UNIT = 100;
    private double _totalCalories;
    private double _cost;
    
    
    /**
     * Default Constructor - Sets the member variables to their defaults
     */
    public Ingredient(){
        _nameOfIngredient = "";
        _unitMeasurement = "";
        _ingredientAmount = 0.0f;
        _numberCaloriesPerUnit = 0;
        _totalCalories = 0.0;
        _cost = 0.0;
    }
    
    /**
     * Declared Constructor - Sets the member variables to the passed in values
     * @param nameofIngredient the name of the ingredient
     * @param unitMeasurement the unit of measurement
     * @param ingredientAmount the ingredient amount
     * @param numberCaloriesPerUnit the number of calories per unit
     * @param totalCalories the total calories per ingredient
     * @param cost the cost of the ingredient
     */
    public Ingredient(String nameofIngredient, String unitMeasurement, Float ingredientAmount, int numberCaloriesPerUnit, double totalCalories, double cost){
        _nameOfIngredient = nameofIngredient;
        _unitMeasurement = unitMeasurement;
        _ingredientAmount = ingredientAmount;
        _numberCaloriesPerUnit = numberCaloriesPerUnit;
        _totalCalories = totalCalories;
        _cost = cost;
    }
    
    
    /**
     * Gets The name of this ingredient
     * @return The name of this ingredient
     */
    public String GetNameOfIngredient(){
        return _nameOfIngredient;
    }
    
    /**
     * Sets The name of this ingredient
     * @param nameOfIngredient The name of this ingredient
     */
    public void SetNameOfIngredient(String nameOfIngredient){
        _nameOfIngredient = nameOfIngredient;
    }
    
    /**
     * Gets The Unit of measurement for this ingredient
     * @return The Unit of measurement for this ingredient
     */
    public String GetUnitMeasurement(){
        return _unitMeasurement;
    }
    
    /**
     * Sets The Unit of measurement for this ingredient
     * @param unitMeasurement The Unit of measurement for this ingredient
     */
    public void SetUnitMeasurement(String unitMeasurement){
        _unitMeasurement = unitMeasurement;
    }
    
    /**
     * Gets The Amount of this ingredient
     * @return  The Amount of this ingredient
     */
    public Float GetIngredientAmount(){
        return _ingredientAmount;
    }
    
    
    /**
     * Gets the Ingredient Amount's max limit
     * @return the Ingredient Amount's max limit
     */
    public Float GetMaxIngredientAmount(){
        return _MAX_INGREDIENT_AMOUNT;
    }
    
    /**
     * Sets the Ingredient Amount's max limit
     * @param ingredientAmount The Amount of this ingredient
     */
    public void SetIngredientAmount(Float ingredientAmount){
        _ingredientAmount = ingredientAmount;
    }
    
    /**
     * Gets The Number of Calories per Unit
     * @return The Number of Calories per Unit
     */
    public int GetNumberCaloriesPerUnit(){
        return _numberCaloriesPerUnit;
    }
    
    /**
     * Gets the Max Calories per Unit
     * @return the Max Calories per Unit
     */
    public int GetMaxCaloriesPerUnit(){
        return _MAX_CALORIES_PER_UNIT;
    }
    
    /**
     * Set The Number of Calories per Unit
     * @param numberCaloriesPerUnit The Number of Calories per Unit
     */
    public void SetNumberCaloriesPerUnit(int numberCaloriesPerUnit){
        _numberCaloriesPerUnit = numberCaloriesPerUnit;
    }
    
    /**
     * Gets the Total Calories for this ingredient
     * @return  The total calories for this ingredient
     */
    public double GetTotalCalories(){
        return _totalCalories;
    }
    
    /**
     * Set The total calories for this ingredient 
     * @param totalCalories The total calories for this ingredient 
     */
    public void SetTotalCalories(double totalCalories){
        _totalCalories = totalCalories;
    }
    
    /**
     * Gets the cost for this ingredient
     * @return  The cost for this ingredient
     */
    public double GetCost(){
        return _cost;
    }
    
    /**
     * Sets the cost for this ingredient
     * @param cost The cost for this ingredient 
     */
    public void SetCost(double cost){
        _cost = cost;
    }
    
    /**
     * Prints the ingredient out
     */
    public void PrintIngredient(){
        System.out.println( 
            GetNameOfIngredient() + " uses " + 
            GetIngredientAmount() + " " + 
            GetUnitMeasurement() + " and has " + 
            GetTotalCalories() + " calories. Costs: $" + 
            GetCost()); 
    }
    
}
