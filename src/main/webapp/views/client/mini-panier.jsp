<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<style>
    /* LE TIROIR LATÉRAL (DRAWER) */
    .cart-drawer {
        position: fixed; top: 0; right: 0; width: 380px; height: 100vh;
        background: white; z-index: 3000;
        box-shadow: -10px 0 50px rgba(0,0,0,0.15);
        display: flex; flex-direction: column;
        transform: translateX(100%); /* Caché par défaut */
        transition: 0.5s cubic-bezier(0.77, 0, 0.175, 1);
    }
    
    .cart-drawer.open { transform: translateX(0); }

    .cart-header {
        padding: 30px 25px;
        background: linear-gradient(135deg, #FF512F 0%, #DD2476 100%);
        color: white; display: flex; justify-content: space-between; align-items: center;
    }

    .cart-content { flex: 1; overflow-y: auto; padding: 25px; background: #fff; }

    .cart-item {
        display: flex; gap: 15px; margin-bottom: 20px; padding-bottom: 15px;
        border-bottom: 1px solid #f0f0f0; align-items: center;
    }
    .cart-item img { width: 70px; height: 70px; border-radius: 12px; object-fit: cover; border: 1px solid #eee; }
    .cart-item-info { flex: 1; }
    .cart-item-info h4 { margin: 0; font-size: 15px; color: #333; font-weight: 700; }
    .cart-item-info .price-calc { margin: 5px 0 0; font-size: 14px; color: #DD2476; font-weight: 800; }

    .cart-footer { padding: 25px; border-top: 1px solid #eee; background: #fdfdfd; }
    .total-row { display: flex; justify-content: space-between; font-size: 18px; font-weight: 900; margin-bottom: 20px; color: #222; }

    /* BOUTON DE VALIDATION */
    .btn-checkout {
        display: block; width: 100%; padding: 18px; text-align: center;
        background: linear-gradient(135deg, #FF512F 0%, #DD2476 100%);
        color: white; text-decoration: none; border: none; border-radius: 50px; 
        font-weight: bold; font-size: 14px; cursor: pointer;
        box-shadow: 0 10px 20px rgba(221, 36, 118, 0.3); transition: 0.3s;
        text-transform: uppercase; letter-spacing: 1px;
    }
    .btn-checkout:hover { transform: translateY(-2px); box-shadow: 0 12px 25px rgba(221, 36, 118, 0.4); }

    /* BOUTON FLOTTANT ROND */
    .cart-toggle {
        position: fixed; right: 30px; bottom: 30px; 
        background: #DD2476; color: white; border: none;
        width: 65px; height: 65px; border-radius: 50%;
        display: flex; align-items: center; justify-content: center;
        cursor: pointer; z-index: 2500; font-size: 26px;
        box-shadow: 0 10px 30px rgba(221, 36, 118, 0.4); transition: 0.3s;
    }
    .cart-badge {
        position: absolute; top: -5px; right: -5px;
        background: #FF512F; border: 3px solid white;
        color: white; font-size: 11px; font-weight: bold;
        width: 24px; height: 24px; border-radius: 50%;
        display: flex; align-items: center; justify-content: center;
    }
</style>

<!-- Structure du Tiroir (Side Drawer) -->
<div id="sideCart" class="cart-drawer ${not empty panier ? 'open' : ''}">
    <div class="cart-header">
        <h3 style="margin:0; font-size: 18px; letter-spacing: 1px;">MA SÉLECTION 🛒</h3>
        <span onclick="toggleCart()" style="cursor:pointer; font-size:30px; line-height:0.5;">&times;</span>
    </div>

    <%-- Affichage du récapitulatif des dates --%>
    <c:if test="${not empty sessionScope.dateDebut}">
        <div style="background:#FFF0F5; padding:12px; text-align:center; color:#DD2476; font-size:12px; font-weight:bold; border-bottom: 1px solid #fce4ec;">
            📅 Du ${sessionScope.dateDebut} au ${sessionScope.dateFin}
        </div>
    </c:if>

    <div class="cart-content">
        <c:choose>
            <c:when test="${empty panier}">
                <div style="text-align:center; margin-top:100px; color:#bbb;">
                    <div style="font-size:60px; margin-bottom:10px;">🧺</div>
                    <p style="font-weight: 600;">Votre panier est vide</p>
                </div>
            </c:when>
            <c:otherwise>
                <c:set var="totalJour" value="0" />
                <c:forEach items="${panier}" var="item">
                    <div class="cart-item">
                        <img src="${pageContext.request.contextPath}/${item.materiel.typeImage}">
                        <div class="cart-item-info">
                            <h4>${item.materiel.typeNom}</h4>
                            <div class="price-calc">
                                <fmt:formatNumber value="${item.materiel.typeMontant}" pattern="###0"/> Ar 
                                <span style="color:#999; font-weight:400; font-size:12px;">x ${item.quantite} = </span>
                                <fmt:formatNumber value="${item.sousTotal}" pattern="###0"/> Ar
                            </div>
                        </div>
                        <a href="${pageContext.request.contextPath}/panier?action=remove&id=${item.materiel.typeId}" 
                           style="text-decoration:none; color:#FF512F; font-size:22px; font-weight:bold;">&times;</a>
                    </div>
                    <c:set var="totalJour" value="${totalJour + item.sousTotal}" />
                </c:forEach>
            </c:otherwise>
        </c:choose>
    </div>

    <%-- Footer du panier avec bouton de validation final --%>
    <c:if test="${not empty panier}">
        <div class="cart-footer">
            <div class="total-row">
                <span style="font-size:15px; color:#999; font-weight:normal;">Total / jour :</span>
                <span><fmt:formatNumber value="${totalJour}" pattern="###0"/> Ar</span>
            </div>
            
            <%-- FORMULAIRE DE VALIDATION VERS CHECKOUTSERVLET --%>
            <form action="${pageContext.request.contextPath}/checkout" method="post">
                <button type="submit" class="btn-checkout">
                    VALIDER LA RÉSERVATION
                </button>
            </form>
        </div>
    </c:if>
</div>

<!-- Bouton flottant pour ouvrir/fermer manuellement -->
<button class="cart-toggle" onclick="toggleCart()">
    🛒
    <c:if test="${not empty panier}">
        <span class="cart-badge">${panier.size()}</span>
    </c:if>
</button>

<script>
    function toggleCart() {
        document.getElementById('sideCart').classList.toggle('open');
    }
</script>