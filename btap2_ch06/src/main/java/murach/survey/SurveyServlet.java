package murach.survey;

import java.io.IOException;
import java.time.Year;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import murach.business.User;

@WebServlet("/survey")
public class SurveyServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        // get parameters
        String firstName    = request.getParameter("firstName");
        String lastName     = request.getParameter("lastName");
        String email        = request.getParameter("email");
        String heardFrom    = request.getParameter("heardFrom");
        String wantsUpdates = request.getParameter("wantsUpdates"); // checkbox -> null hoặc "Yes"
        String contactVia   = request.getParameter("contactVia");

        // defaults
        if (heardFrom == null || heardFrom.isBlank()) heardFrom = "NA";
        wantsUpdates = (wantsUpdates == null) ? "No" : "Yes";

        // fill bean
        User user = new User();
        user.setFirstName(firstName);
        user.setLastName(lastName);
        user.setEmail(email);
        user.setHeardFrom(heardFrom);
        user.setWantsUpdates(wantsUpdates);
        user.setContactVia(contactVia);

        // push to JSP
        request.setAttribute("user", user);
        request.setAttribute("currentYear", Year.now().getValue());

        request.getServletContext()
               .getRequestDispatcher("/survey.jsp")
               .forward(request, response);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // mở form khi truy cập bằng GET
        response.sendRedirect(request.getContextPath() + "/");
    }
}
