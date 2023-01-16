package snhu.it634.q1657.model;

import java.io.Serializable;

import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlRootElement;

/*
Colby Lithyouvong
IT-634-Q1657 Distributed App Development 22TW1
Final Project Part I Submission: Web Application With Annotated Code
*/

@XmlRootElement(name = "login")
@XmlAccessorType (XmlAccessType.FIELD)
public class Login implements Serializable{

    @XmlElement(name = "username")
    private String username;

    @XmlElement(name = "password")
    private String password;
    
    @XmlElement(name = "firstName")
    private String firstName;
    
    @XmlElement(name = "middleName")
    private String middleName;
    
    @XmlElement(name = "lastName")
    private String lastName;
    
    @XmlElement(name = "dateOfBirth")
    private String dateOfBirth;
    
    @XmlElement(name = "gender")
    private String gender;
    
    @XmlElement(name = "phone")
    private String phone;
    
    @XmlElement(name = "email")
    private String email;
    
    @XmlElement(name = "key")
    private String key;
    
    public Login() {
        
    }
    
    public Login(String u, String p) {
        username = u;
        password = p;
        firstName = "";
        middleName = "";
        lastName = "";
        dateOfBirth = "";
        gender = "";
        phone = "";
        email = "";
        key = "";
    }
    
    public Login(String userx, String passx, String firstx, String midx, String lastx, String dobx, String genx, String phonex, String emailx, String secretx) {
        username = userx;
        password = passx;
        firstName = firstx;
        middleName = midx;
        lastName = lastx;
        dateOfBirth = dobx;
        gender = genx;
        phone = phonex;
        email = emailx;
        key = secretx;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getFirstName() {
        return firstName;
    }

    public void setFirstName(String firstName) {
        this.firstName = firstName;
    }

    public String getMiddleName() {
        return middleName;
    }

    public void setMiddleName(String middleName) {
        this.middleName = middleName;
    }

    public String getLastName() {
        return lastName;
    }

    public void setLastName(String lastName) {
        this.lastName = lastName;
    }

    public String getDateOfBirth() {
        return dateOfBirth;
    }

    public void setDateOfBirth(String dateOfBirth) {
        this.dateOfBirth = dateOfBirth;
    }

    public String getGender() {
        return gender;
    }

    public void setGender(String gender) {
        this.gender = gender;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getKey() {
        return key;
    }

    public void setKey(String key) {
        this.key = key;
    }
}
