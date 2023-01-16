package snhu.it634.q1657.controller;

import java.io.File;

import javax.crypto.SecretKey;
import javax.servlet.http.HttpServletRequest;
import javax.xml.bind.JAXBContext;
import javax.xml.bind.Marshaller;
import javax.xml.bind.Unmarshaller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;

import com.fasterxml.jackson.databind.ObjectMapper;

import snhu.it634.q1657.model.Login;
import snhu.it634.q1657.model.Logins;
import snhu.it634.q1657.service.EncryptionService;

/*
Colby Lithyouvong
IT-634-Q1657 Distributed App Development 22TW1
Final Project Part I Submission: Web Application With Annotated Code
*/

@Controller
public class DashboardController {

    //when the user wants to get to the dashboard screen
    // with no other things loading
    @GetMapping("/dashboard")
    public String dashboard(HttpServletRequest request, Model model) {
        String returnPage = "dashboard";
        try {
            Login l = GetLoginFromSessionAttributes(request);
            l = SetLoginObject(l);
            
            model.addAttribute("loginAuthorized", l);
            
        }catch(Exception e) {
            System.out.println(e.getMessage());
            returnPage = "redirect:/login/error";
        }
      
        return returnPage;
    }
    
    //when the user successfully updates
    // the login information
    @GetMapping("/dashboard/success")
    public String dashboardsuccess(HttpServletRequest request, Model model) {
        String returnPage = "dashboard";
        try {
            Login l = GetLoginFromSessionAttributes(request);
            l = SetLoginObject(l);
            
            model.addAttribute("loginAuthorized", l);
            model.addAttribute("error", "<div class='alert alert-success'>Successfully Updated your information!</div>");
        }catch(Exception e) {
            System.out.println(e.getMessage());
            returnPage = "redirect:/login/error";
        }
      
        return returnPage;
    }

    // when the user hits a 'update failed' exception
    @GetMapping("/dashboard/update/error")
    public String dashboardupdateerror(HttpServletRequest request, Model model) {
        String returnPage = "dashboard";
        try {
            Login l = GetLoginFromSessionAttributes(request);
            l = SetLoginObject(l);
            
            model.addAttribute("loginAuthorized", l);
            model.addAttribute("error", "<div class='alert alert-warning'>An error has occurred. Please try again.</div>");
        }catch(Exception e) {
            System.out.println(e.getMessage());
            returnPage = "redirect:/login/error";
        }
      
        return returnPage;
    }    
    
    // when the user updates the login credentials
    @PostMapping("/dashboard/update")
    public String dashboardupdate(HttpServletRequest request, Login login, Model model) {
        String returnPage = "redirect:/dashboard/success";
        boolean isExists = false;
        Logins logins = new Logins();

        //takes the parameters sent in and makes it 
        // easier to manipulate by declaration...
        String uParam = login.getUsername().toLowerCase().trim();

        try { 
            //Open a JAXB Context with a reference to Logins table
            //creates an instance of that object
            JAXBContext jaxbContext = JAXBContext.newInstance(Logins.class);
            Unmarshaller jaxbUnmarshaller = jaxbContext.createUnmarshaller();
            
            //give the resource file, we will get the file associated.
            File file = new File("src/main/resources/static/Logins.xml");

            //the unmarshaller will load this file in.
            logins = (Logins) jaxbUnmarshaller.unmarshal( file );
             

            //loop through this instance and compare only on user name (case insensitive)
            for(Login l : logins.getLogins())
            {              
              String u = l.getUsername().toLowerCase();
              
              // if the user exists in the list, update it now..
              if(u.equals(uParam)) {
                  l = SetLoginObject(l);

                  ObjectMapper mapper = new ObjectMapper();  
                  String loginSerialized = mapper.writeValueAsString(l);
                  request.getSession().setAttribute("loginAuthorized", loginSerialized);
                  
                  isExists = true;
                  break;
              }
            }
            
            //if the user is found, update it. 
            if(isExists) {             
              Marshaller jaxbMarshaller = jaxbContext.createMarshaller();
              jaxbMarshaller.setProperty(Marshaller.JAXB_FORMATTED_OUTPUT, true);      
               
              //Marshal the logins list in file
              jaxbMarshaller.marshal(logins, file);
            }
            //if user does not exist, break out and present an error page
            else {
                returnPage = "redirect:/dashboard/update/error";
            }
        } catch (Exception e) {
            System.out.println(e.getMessage());
            e.printStackTrace();
        }
        
        return returnPage;
    }

    //grab session values
    //map values from json
    private Login GetLoginFromSessionAttributes(HttpServletRequest request) {
        Login l;
        
        try {
            //grab session values
            String obj = (String) request.getSession().getAttribute("loginAuthorized");
    
            //map values from json
            ObjectMapper mapper = new ObjectMapper();  
            l = mapper.readValue(obj, Login.class);  
        } catch(Exception e) {
            System.out.println(e.getMessage());
            l = new Login();
        }
        
        return l;
    }

    //because the values in the session are 'encrypted' 
    //we want to decrypt them for this 'view' only
    private Login SetLoginObject(Login l) {
        try {
            EncryptionService es = new EncryptionService();
            SecretKey key = es.convertStringToSecretKeyto(l.getKey());
            l.setFirstName(es.decrypt(l.getFirstName(), key));
            l.setMiddleName(es.decrypt(l.getMiddleName(), key));
            l.setLastName(es.decrypt(l.getLastName(), key));
            l.setDateOfBirth(es.decrypt(l.getDateOfBirth(), key));
            l.setGender(es.decrypt(l.getGender(), key));
            l.setPhone(es.decrypt(l.getPhone(), key));
            l.setEmail(es.decrypt(l.getEmail(), key));    
        } catch(Exception e) {
            System.out.println(e.getMessage());
        }

        return l;
    }
}
