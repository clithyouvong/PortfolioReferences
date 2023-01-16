package snhu.it634.q1657.model;

import java.util.ArrayList;
import java.util.List;

import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlRootElement;

/*
Colby Lithyouvong
IT-634-Q1657 Distributed App Development 22TW1
Final Project Part I Submission: Web Application With Annotated Code
*/

@XmlRootElement(name = "logins")
@XmlAccessorType (XmlAccessType.FIELD)
public class Logins {
    @XmlElement(name = "login")
    private List<Login> logins;
    
    public Logins() {
        logins = new ArrayList<Login>();
    }
   
    public List<Login> getLogins() {
      return logins;
    }
   
    public void setEmployees(List<Login> logins) {
      this.logins = logins;
    }

}
