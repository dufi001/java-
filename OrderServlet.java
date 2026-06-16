package com.bakery.controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.bakery.config.DBConnection;
import com.bakery.model.User;

/**
 * Servlet implementation class OrderServlet
 */
@WebServlet("/Order")
public class OrderServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        int userId = (Integer) session.getAttribute("userId");
        String operator = request.getParameter("operator"); // MTN or AIRTEL
        String totalAmount = request.getParameter("totalAmount");

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement("INSERT INTO orders (user_id, amount, payment_method, status) VALUES (?, ?, ?, 'PAID')")) {
            
            ps.setInt(1, userId);
            ps.setDouble(2, Double.parseDouble(totalAmount));
            ps.setString(3, operator);
            ps.executeUpdate();
            
            // Clean response back to JavaScript payment confirmation handler
            response.getWriter().write("payment_verified");
        } catch (Exception e) {
            response.getWriter().write("payment_failed");
        }}}
