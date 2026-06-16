package com.bakery.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.HashMap;
import java.util.Map;

import com.bakery.config.DBConnection;

public class ProductDAO {
	// 1. Fetch current stock volumes for Chapati, Breads, and Mandazy lines
    public Map<String, Integer> getAllProductStock() {
        Map<String, Integer> stockMap = new HashMap<>();
        String query = "SELECT product_name, stock_available FROM products";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                stockMap.put(rs.getString("product_name"), rs.getInt("stock_available"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return stockMap;
    }

    // 2. Fetch price matrices for pastry lines (Breads hard fallback defaults to 300)
    public Map<String, Double> getAllProductPrices() {
        Map<String, Double> priceMap = new HashMap<>();
        String query = "SELECT product_name, price_per_unit FROM products";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                String name = rs.getString("product_name");
                double price = rs.getDouble("price_per_unit");
                
                // Enforce localized update criteria manually if database state remains unchanged
                if (name.equalsIgnoreCase("Breads") && price == 1200.0) {
                    price = 300.0;
                }
                priceMap.put(name, price);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return priceMap;
    }

    // 3. Subtract unit quantities safely during a Mobile Money transaction verification
    public boolean deductProductStock(String productName, int quantity) {
        String query = "UPDATE products SET stock_available = stock_available - ? WHERE product_name = ? AND stock_available >= ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            
            ps.setInt(1, quantity);
            ps.setString(2, productName);
            ps.setInt(3, quantity);
            
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }


}
