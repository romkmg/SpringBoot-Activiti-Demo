package com.example.myact.entity;

import javax.persistence.*;
import java.io.Serializable;
import java.util.List;

/**
 * 用户组
 * @Author @MG
 * @Date 2018/7/4 11:52
 */
@Entity
@Table(name = "ACT_ID_GROUP")
public class Group implements Serializable {
    private static final long serialVersionUID = 1L;
    private String id;
    private Integer rev;
    private String name;
    private String type;
    private List<User> actIdUsers;

    public Group() {
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

    @Column(name = "REV_")
    public Integer getRev() {
        return this.rev;
    }

    public void setRev(Integer rev) {
        this.rev = rev;
    }

    @Column(name = "NAME_")
    public String getName() {
        return this.name;
    }

    public void setName(String name) {
        this.name = name;
    }

    @Column(name = "TYPE_")
    public String getType() {
        return this.type;
    }

    public void setType(String type) {
        this.type = type;
    }

    @ManyToMany(mappedBy = "actIdGroups")
    public List<User> getActIdUsers() {
        return this.actIdUsers;
    }

    public void setActIdUsers(List<User> actIdUsers) {
        this.actIdUsers = actIdUsers;
    }

    @Override
    public String toString() {
        return "Group{" +
                "id='" + id + '\'' +
                ", rev=" + rev +
                ", name='" + name + '\'' +
                ", type='" + type + '\'' +
                ", actIdUsers=" + actIdUsers +
                '}';
    }
}