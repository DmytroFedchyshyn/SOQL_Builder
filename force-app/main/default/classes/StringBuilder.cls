public without sharing class StringBuilder {

    private List<String> pieces = new List<String>();

    public StringBuilder append(String piece) {
        this.pieces.add(piece);
        return this; // allows for method chaining
    }

    public override String toString() {
        return String.join(this.pieces, '');
    }
}