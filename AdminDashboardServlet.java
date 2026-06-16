package com.bakery.controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.bakery.config.DBConnection;
import com.bakery.model.User;

/**
 * Servlet implementation class AdminDashboardServlet
 */
@WebServlet("/AdminDashboard")
public class AdminDashboardServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		List<User> customerList = new ArrayList<>();

        // 1. Fetch only users who are registered as CUSTOMERs
        String query = "SELECT id, fullname, phone FROM users WHERE role = 'CUSTOMER'";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                User user = new User();
                user.setId(rs.getInt("id"));
                user.setFullname(rs.getString("fullname"));
                user.setPhone(rs.getString("phone"));
                customerList.add(user);
            }
            
            // 2. CRITICAL: This attribute name must match your JSP exactly!
            request.setAttribute("activeCustomers", customerList);

        } catch (Exception e) {
            e.printStackTrace();
        }

        // 3. Forward control smoothly over to the visual view layer
        request.getRequestDispatcher("admin-dashboard.jsp").forward(request, response);
    }
}