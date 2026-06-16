package com.bakery.model;

public class User {
	private int id;
    private String fullname;
    private String phone;
    private String password;
    private String role; // Standard value will be 'CUSTOMER' or 'ADMIN'

    // Empty constructor required for Java Beans
    public User() {}

    // Constructor to quickly build a user profile (useful during registration)
    public User(String fullname, String phone, String password, String role) {
        this.fullname = fullname;
        this.phone = phone;
        this.password = password;
        this.role = role;
    }

    // Getters and Setters
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getFullname() {
        return fullname;
    }

    public void setFullname(String fullname) {
        this.fullname = fullname;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getRole() {
        return role;
    }

    public void setRole(String role) {
        this.role = role;
    }

}
