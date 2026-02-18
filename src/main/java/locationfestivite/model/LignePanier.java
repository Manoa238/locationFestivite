package locationfestivite.model;

public class LignePanier {
    private Type materiel;
    private int quantite;

    public LignePanier(Type materiel, int quantite) {
        this.materiel = materiel;
        this.quantite = quantite;
    }

    // Getters
    public Type getMateriel() { return materiel; }
    public int getQuantite() { return quantite; }
    public void setQuantite(int quantite) { this.quantite = quantite; }
    
    // Calcul du sous-total pour une ligne
    public double getSousTotal() {
        return materiel.getTypeMontant() * quantite;
    }
}