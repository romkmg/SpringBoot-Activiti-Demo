package com.example.myact.entity;

import javax.persistence.*;
import java.io.Serializable;
import java.util.List;

/**
 * 用户
 * @Author @MG
 * @Date 2018/7/4 11:52
 */
@Entity
@Table(name = "ACT_ID_USER")
public class User implements Serializable {
    private static final long serialVersionUID = 1L;
    private String id;
    private String email;
    private String firstName;
    private String lastName;
    private String password;
    private List<Group> actIdGroups;

    public User() {
    }

    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    @Column(name = "ID_")
    public String getId() {
        return this.id;
    }

    public void setId(String id) {
        this.id = id;
    }

    @Column(name = "FIRST_")
    public String getFirstName() {
        return firstName;
    }

    public void setFirstName(String s) {
        this.firstName = s;
    }

    @Column(name = "LAST_")
    public void setLastName(String s) {
        this.lastName = s;
    }

    public String getLastName() {
        return lastName;
    }

    @Column(name = "EMAIL_")
    public String getEmail() {
        return this.email;
    }

    public void setEmail(String email) {
        this.email = email;
    }


    @Column(name = "PWD_")
    public String getPassword() {
        return this.password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    @ManyToMany
    @JoinTable(name = "ACT_ID_MEMBERSHIP", joinColumns = {@JoinColumn(name = "USER_ID_")}, inverseJoinColumns = {@JoinColumn(name = "GROUP_ID_")})
    public List<Group> getActIdGroups() {
        return this.actIdGroups;
    }

    public void setActIdGroups(List<Group> actIdGroups) {
        this.actIdGroups = actIdGroups;
    }

    @Override
    public String toString() {
        return "User{" +
                "id='" + id + '\'' +
                ", email='" + email + '\'' +
                ", firstName='" + firstName + '\'' +
                ", lastName='" + lastName + '\'' +
                ", password='" + password + '\'' +
                ", actIdGroups=" + actIdGroups +
                '}';
    }
}
