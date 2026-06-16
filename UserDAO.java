package com.bakery.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import com.bakery.config.DBConnection;
import com.bakery.model.User;

public class UserDAO {
	// 1. Fetch all system users registered under the 'CUSTOMER' role filter
    public List<User> getAllCustomers() {
        List<User> customers = new ArrayList<>();
        String query = "SELECT id, fullname, phone FROM users WHERE role = 'CUSTOMER'";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                User user = new User();
                user.setId(rs.getInt("id"));
                user.setFullname(rs.getString("fullname"));
                user.setPhone(rs.getString("phone"));
                customers.add(user);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return customers;
    }

    // 2. Update dynamic profile traits for a specific customer ID block
    public boolean updateCustomer(int id, String fullname, String phone) {
        String query = "UPDATE users SET fullname = ?, phone = ? WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            
            ps.setString(1, fullname);
            ps.setString(2, phone);
            ps.setInt(3, id);
            
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // 3. Purge a customer profile entirely from the persistent database row
    public boolean deleteCustomer(int id) {
        String query = "DELETE FROM users WHERE id = ? AND role != 'ADMIN'";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

}
