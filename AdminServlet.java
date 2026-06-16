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
import javax.servlet.http.HttpSession;

import com.bakery.config.DBConnection;
import com.bakery.model.User;

/**
 * Servlet implementation class AdminServlet
 */
@WebServlet("/Admin")
public class AdminServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        User currentUser = (User) session.getAttribute("user");
        if (!"ADMIN".equals(currentUser.getRole())) {
            response.sendRedirect("login.jsp");
            return;
        }

        // Handle Customer Deletion Requests via query strings (?action=delete&id=X)
        String action = request.getParameter("action");
        if ("delete".equals(action)) {
            int customerId = Integer.parseInt(request.getParameter("id"));
            String deleteQuery = "DELETE FROM users WHERE id = ? AND role = 'CUSTOMER'";
            try (Connection conn = DBConnection.getConnection();
                 PreparedStatement ps = conn.prepareStatement(deleteQuery)) {
                ps.setInt(1, customerId);
                ps.executeUpdate();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        // Fetch remaining clean profile records for display
        List<User> customerList = new ArrayList<>();
        String fetchUsersQuery = "SELECT id, fullname, phone FROM users WHERE role = 'CUSTOMER'";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(fetchUsersQuery);
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                User u = new User();
                u.setId(rs.getInt("id"));
                u.setFullname(rs.getString("fullname"));
                u.setPhone(rs.getString("phone"));
                customerList.add(u);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        // Send dataset array to admin-dashboard view
        request.setAttribute("customers", customerList);
        request.getRequestDispatcher("admin-dashboard.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Handle customer updates sent from the dashboard editing tools
        String action = request.getParameter("action");
        if ("update".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            String fullname = request.getParameter("fullname");
            String phone = request.getParameter("phone");

            String updateQuery = "UPDATE users SET fullname = ?, phone = ? WHERE id = ?";
            try (Connection conn = DBConnection.getConnection();
                 PreparedStatement ps = conn.prepareStatement(updateQuery)) {
                ps.setString(1, fullname);
                ps.setString(2, phone);
                ps.setInt(3, id);
                ps.executeUpdate();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        response.sendRedirect("Admin");
    }
}
