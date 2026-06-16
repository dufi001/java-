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

import com.bakery.config.DBConnection;

/**
 * Servlet implementation class CheckPhoneServlet
 */
@WebServlet("/CheckPhone")
public class CheckPhoneServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String phone = request.getParameter("phone");
        response.setContentType("text/plain");

        if (phone == null || phone.trim().isEmpty()) {
            response.getWriter().write("available");
            return;
        }

        String query = "SELECT id FROM users WHERE phone = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            
            ps.setString(1, phone.trim());
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    response.getWriter().write("exists"); // Found a duplicate row!
                } else {
                    response.getWriter().write("available"); // Safe to use
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().write("error");
        }
    }
}