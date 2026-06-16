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
 * Servlet implementation class AdminCrudServlet
 */
@WebServlet("/AdminCrud")
public class AdminCrudServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	/**
	 * @see HttpServlet#doDelete(HttpServletRequest, HttpServletResponse)
	 */
	protected void doDelete(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String userId = request.getParameter("id");
        response.setContentType("text/plain");

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement("DELETE FROM users WHERE id = ? AND role != 'ADMIN'")) {
            
            ps.setInt(1, Integer.parseInt(userId));
            int rowsAffected = ps.executeUpdate();
            
            if (rowsAffected > 0) {
                response.getWriter().write("delete_success");
            } else {
                response.getWriter().write("error_protected");
            }
        } catch (Exception e) {
            response.getWriter().write("server_error");
        }
    }

    // Core Execution Path for Updating Accounts
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String userId = request.getParameter("id");
        String newName = request.getParameter("fullname");
        String newPhone = request.getParameter("phone");

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement("UPDATE users SET fullname = ?, phone = ? WHERE id = ?")) {
            
            ps.setString(1, newName);
            ps.setString(2, newPhone);
            ps.setInt(3, Integer.parseInt(userId));
            ps.executeUpdate();
            
            response.sendRedirect("admin_dashboard.jsp?status=updated");
        } catch (Exception e) {
            response.sendRedirect("admin_dashboard.jsp?status=error");
            
        }}}
