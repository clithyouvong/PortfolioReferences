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
public class LoginController {

    //dependency injection of the service
    private EncryptionService encryptionService;
    private SecretKey secretKey;
    
    public LoginController() {
        encryptionService = new EncryptionService();
        secretKey = encryptionService.GetSecretKey();
    }
    
    //when the user wants to login 
    @GetMapping("/login")
    public String login(HttpServletRequest request, Model model) {   
        String returnPage = "login";

        if(request.getSession().getAttribute("loginAuthorized") == null) {
            model.addAttribute("Login", new Login());
        }
        else {
            //user is already logged in;
            //redirect to dashboard page...
            returnPage = "redirect:/dashboard";
        }         
        
        
        return returnPage;
    }
    
    // when the user hits an error on the login screen
    // invalid u/p combo or unknown user
    @GetMapping("/login/error")
    public String loginerror(HttpServletRequest request, Model model) {
        model.addAttribute("Login", new Login());
        model.addAttribute("error", "<div class='alert alert-warning'>Username or Password Combination is invalid. Please try again.</div>");
        
        request.getSession().invalidate();
        
        return "login";
    }
    
    // when the user attempts to book a flight without first being logged in
    @GetMapping("/login/error2")
    public String loginerror2(HttpServletRequest request, Model model) {
        model.addAttribute("Login", new Login());
        model.addAttribute("error", "<div class='alert alert-warning'>Please login to book your flight.</div>");
        
        request.getSession().invalidate();
        
        return "login";
    }
    
    // when the user wants to login, this is the verification and assignment
    @PostMapping("/login/login")
    public String loginlogin(HttpServletRequest request, Login login, Model model) {
        String returnPage = "redirect:/dashboard";
        boolean isValid = true;

        //takes the parameters sent in and makes it 
        // easier to manipulate by declaration...
        String uParam = login.getUsername().toLowerCase().trim();
        String pParam = login.getPassword().trim();

        
        try {
            JAXBContext jaxbContext = JAXBContext.newInstance(Logins.class);        
            Unmarshaller jaxbUnmarshaller = jaxbContext.createUnmarshaller();

            //give the resource file, we will get the file associated.
            File file = new File("src/main/resources/static/Logins.xml");

            //the unmarshaller will load this file in.
            Logins logins = (Logins) jaxbUnmarshaller.unmarshal( file );

            //loop through this instance and compare user name and password combination..
            for(Login l : logins.getLogins())
            {              
              String u = l.getUsername().toLowerCase();
              String p = l.getPassword();
              String k = l.getKey();
              SecretKey kDecrypted = encryptionService.convertStringToSecretKeyto(k);
              String pDecrypted = encryptionService.decrypt(p, kDecrypted);
              
              //if the user matches
              if(u.equals(uParam)) {
                  //if the password matches the decrypted password
                  if(!pDecrypted.equals(pParam)) {
                      returnPage = "redirect:/login/error";
                      isValid = false;
                  }
                  //if the password was valid
                  // reassign the login obj to this instance of l
                  // so we can send the object through a session variable
                  else {
                     login = l; 
                  }
                  
                  //if we find the user, it means we can break now
                  // no need to keep looping
                  break;
              }
            }  
        } catch (Exception e) {
            System.out.println(e.getMessage());
            e.printStackTrace();
        }
        
        //we found a valid match
        // save the object to session
        if(isValid) {
            try {
                ObjectMapper mapper = new ObjectMapper();  
                String loginSerialized = mapper.writeValueAsString(login);

                request.getSession().setAttribute("loginAuthorized", loginSerialized);
            }catch(Exception e) {
                System.out.println(e.getMessage());
            }
        }
  
        
        return returnPage;
    }
    
    //when the user successfully loggs in
    @GetMapping("/login/success")
    public String loginsuccess(Model model){
        model.addAttribute("Login", new Login());
        model.addAttribute("error", "<div class='alert alert-success'>New Account has been created! Please login.</div>");
        
        return "login";
    }

    //when the user wants to create a login, go to view
    @GetMapping("/create")
    public String create(HttpServletRequest request, Model model) {
        String returnPage = "create";
        
        if(request.getSession().getAttribute("loginAuthorized") == null) {
            model.addAttribute("Login", new Login());
        }
        else {
            //user is already logged in;
            //redirect to dashboard page...
            returnPage = "redirect:/dashboard";
        }
        
        return returnPage;
    }
    
    //when the user hits an error during the sign up process    
    @GetMapping("/create/error")
    public String createError(HttpServletRequest request, Model model) {
        model.addAttribute("error", "<div class='alert alert-warning'>Username already exists. Please try again.</div>");
        

        try {
            //grab session values
            String obj = (String) request.getSession().getAttribute("createerror");

            //map values from json
            ObjectMapper mapper = new ObjectMapper();  
            Login loginObj = mapper.readValue(obj, Login.class);
            model.addAttribute("Login", loginObj);
        } catch (Exception e) {
            System.out.println(e.getMessage());
            e.printStackTrace();
            model.addAttribute("Login", new Login());
        } 
        
        return "create";
    }

    //verifies the login process.
    @PostMapping("/create/verify")
    public String createverify(Login login, Model model, HttpServletRequest request) {
        String returnPage = "redirect:/login/success";
        boolean isExists = false;
        
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
            Logins logins = (Logins) jaxbUnmarshaller.unmarshal( file );
             

            //loop through this instance and compare only on user name (case insensitive)
            for(Login l : logins.getLogins())
            {              
              String u = l.getUsername().toLowerCase();
              
              // if the user exists in the list, the output an error
              //  break out of this loop
              if(u.equals(uParam)) {
                  returnPage = "redirect:/create/error";
                  isExists = true;
                  break;
              }
            }
            
            //if the user doesn't exist, then add that user to the xml file
            if(!isExists) {             
              Marshaller jaxbMarshaller = jaxbContext.createMarshaller();
              jaxbMarshaller.setProperty(Marshaller.JAXB_FORMATTED_OUTPUT, true);              
                   
              //adds a new login to the logins list
              logins.getLogins().add(new Login(
                      uParam, 
                      encryptionService.encrypt(login.getPassword().trim(), secretKey),
                      encryptionService.encrypt(login.getFirstName().trim(), secretKey),
                      encryptionService.encrypt(login.getMiddleName().trim(), secretKey),
                      encryptionService.encrypt(login.getLastName().trim(), secretKey),
                      encryptionService.encrypt(login.getDateOfBirth().trim(), secretKey),
                      encryptionService.encrypt(login.getGender().trim(), secretKey),
                      encryptionService.encrypt(login.getPhone().trim(), secretKey),
                      encryptionService.encrypt(login.getEmail().trim(), secretKey),
                      encryptionService.convertSecretKeyToString(secretKey)
                  )
              );
              
              //Marshal the logins list in console
              //jaxbMarshaller.marshal(logins, System.out);
               
              //Marshal the logins list in file
              jaxbMarshaller.marshal(logins, file);
            }
        } catch (Exception e) {
            System.out.println(e.getMessage());
            e.printStackTrace();
        }
        
        //send back an empty object ready to sign in
        if(isExists) {
            try {
                ObjectMapper mapper = new ObjectMapper();  
                String loginSerialized = mapper.writeValueAsString(login);

                request.getSession().setAttribute("createerror", loginSerialized);
            }catch(Exception e) {
                System.out.println(e.getMessage());
            }
        }
        else {
            model.addAttribute("Login", new Login());
        }
        
        
        return returnPage;
    }
}
