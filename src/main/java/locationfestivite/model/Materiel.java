package locationfestivite.model;

public class Materiel {
    private Long id;
    private String nom;
    private String description;
    private double prixJournalier;
    private int quantiteStock;
    private boolean disponible;
    private String imageUrl;  

    // Constructeur vide
    public Materiel() {}

    public Materiel(Long id, String nom, String description, double prixJournalier, int quantiteStock, String imageUrl) {
        this.id = id;
        this.nom = nom;
        this.description = description;
        this.prixJournalier = prixJournalier;
        this.quantiteStock = quantiteStock;
        this.disponible = quantiteStock > 0;
        this.imageUrl = imageUrl;
    }

    // Getters & Setters 
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public String getNom() { return nom; }
    public void setNom(String nom) { this.nom = nom; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public double getPrixJournalier() { return prixJournalier; }
    public void setPrixJournalier(double prixJournalier) { this.prixJournalier = prixJournalier; }

    public int getQuantiteStock() { return quantiteStock; }
    public void setQuantiteStock(int quantiteStock) { this.quantiteStock = quantiteStock; }

    public boolean isDisponible() { return disponible; }
    public void setDisponible(boolean disponible) { this.disponible = disponible; }

    public String getImageUrl() { return imageUrl; }
    public void setImageUrl(String imageUrl) { this.imageUrl = imageUrl; }
}