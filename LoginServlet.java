package com.bakery.controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.bakery.config.DBConnection;
import com.bakery.model.User;

/**
 * Servlet implementation class LoginServlet
 */
@WebServlet("/Login")
public class LoginServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String phone = request.getParameter("phone");
        String password = request.getParameter("password");

        String query = "SELECT * FROM users WHERE phone = ? AND password = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            
            ps.setString(1, phone);
            ps.setString(2, password);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                // User found, map database row to User object
                User user = new User();
                user.setId(rs.getInt("id"));
                user.setFullname(rs.getString("fullname"));
                user.setPhone(rs.getString("phone"));
                user.setRole(rs.getString("role"));

                // Store user object inside a secure server session
                HttpSession session = request.getSession();
                session.setAttribute("user", user);

                // Check role routing destination
                if ("ADMIN".equals(user.getRole())) {
                    response.sendRedirect("Admin"); // Route to Admin Controller
                } else {
                    response.sendRedirect("marketplace.jsp"); // Route to Customer Interface
                }
            } else {
                // Credentials mismatch, send back message alert
                request.setAttribute("errorMessage", "Invalid username and password. Try again.");
                request.getRequestDispatcher("login.jsp").forward(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("login.jsp");
        }}}