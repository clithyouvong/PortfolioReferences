namespace SNHU.IT700.Application.Models
{
    public class ReportRequestModel
    {
         public string FirstName {get;set;}="";
         public string LastName {get;set;}="";
         public string City {get;set;}="";
         public int StateId {get;set;}=0;
         public int CountryId {get;set;}=0;
         public int GenderId {get;set;}=0;
         public int EthnicityId {get;set;}=0;
         public int HairColorId {get;set;}=0;
         public int EyeColorId {get;set;}=0;
         public string Description {get;set;}="";
         public int Age {get;set;}=0;
         public string Phone1 {get;set;}="";
         public string Phone2 {get;set;}="";
         public string Phone3 {get;set;}="";
         public string Email1 {get;set;}="";
         public string Email2 {get;set;}="";
         public string Email3 {get;set;}="";
         public DateTime DateLost {get;set;} = DateTime.Parse("1900-01-01");
    }
}
