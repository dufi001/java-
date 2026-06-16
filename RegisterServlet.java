package com.bakery.controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.bakery.config.DBConnection;

/**
 * Servlet implementation class RegisterServlet
 */
@WebServlet("/Register")
public class RegisterServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String fullname = request.getParameter("fullname");
        String phone = request.getParameter("phone");
        String password = request.getParameter("password");

        String query = "INSERT INTO users (fullname, phone, password, role) VALUES (?, ?, ?, 'CUSTOMER')";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            
            ps.setString(1, fullname);
            ps.setString(2, phone);
            ps.setString(3, password);

            int rowsInserted = ps.executeUpdate();
            if (rowsInserted > 0) {
                // Registration successful, send to login page
                response.sendRedirect("login.jsp");
            } else {
                response.sendRedirect("signup.jsp");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("signup.jsp");
        }}}