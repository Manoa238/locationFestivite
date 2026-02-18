package locationfestivite.model;

public class Type {
    private int typeId;
    private String typeNom;
    private String typeDescription;
    private int typeQuantite;
    private double typeMontant;
    private String typeImage;
    private int categorieId;

    // Constructeur vide
    public Type() {}

    // Constructeur complet
    public Type(int typeId, String typeNom, String typeDescription, int typeQuantite, 
                double typeMontant, String typeImage, int categorieId) {
        this.typeId = typeId;
        this.typeNom = typeNom;
        this.typeDescription = typeDescription;
        this.typeQuantite = typeQuantite;
        this.typeMontant = typeMontant;
        this.typeImage = typeImage;
        this.categorieId = categorieId;
    }

    // Getters et Setters
    public int getTypeId() { 
        return typeId; 
    }
    
    public void setTypeId(int typeId) { 
        this.typeId = typeId; 
    }

    public String getTypeNom() { 
        return typeNom; 
    }
    
    public void setTypeNom(String typeNom) { 
        this.typeNom = typeNom; 
    }

    public String getTypeDescription() { 
        return typeDescription; 
    }
    
    public void setTypeDescription(String typeDescription) { 
        this.typeDescription = typeDescription; 
    }

    public int getTypeQuantite() { 
        return typeQuantite; 
    }
    
    public void setTypeQuantite(int typeQuantite) { 
        this.typeQuantite = typeQuantite; 
    }

    public double getTypeMontant() { 
        return typeMontant; 
    }
    
    public void setTypeMontant(double typeMontant) { 
        this.typeMontant = typeMontant; 
    }

    public String getTypeImage() { 
        return typeImage; 
    }
    
    public void setTypeImage(String typeImage) { 
        this.typeImage = typeImage; 
    }

    public int getCategorieId() { 
        return categorieId; 
    }
    
    public void setCategorieId(int categorieId) { 
        this.categorieId = categorieId; 
    }

    // Méthode utilitaire pour savoir si le produit est disponible
    public boolean isDisponible() {
        return typeQuantite > 0;
    }
}