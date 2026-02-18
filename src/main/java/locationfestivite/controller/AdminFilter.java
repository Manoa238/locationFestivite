package locationfestivite.controller;

import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import locationfestivite.model.Utilisateur;
import java.io.IOException;

// Ce filtre protège TOUTES les adresses qui commencent par /admin/
@WebFilter("/admin/*")
public class AdminFilter implements Filter {

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        
        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;
        HttpSession session = req.getSession(false);

        // On récupère l'utilisateur en session
        Utilisateur user = (session != null) ? (Utilisateur) session.getAttribute("utilisateurConnecte") : null;

        // VERIFICATION
        if (user != null && "ADMIN".equals(user.getRole())) {
            // C'est bien l'admin, on le laisse passer
            chain.doFilter(request, response);
        } else {
            // Ce n'est pas l'admin, on le renvoie au login avec un message
            System.out.println("⚠️ Accès refusé à : " + req.getRequestURI());
            res.sendRedirect(req.getContextPath() + "/login");
        }
    }
}