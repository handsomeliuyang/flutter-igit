class Tradeline {
    final String id;
    final String name;

    Tradeline(this.id, this.name);

    @override
    bool operator ==(Object other) =>
        identical(this, other) ||
            other is Tradeline &&
                runtimeType == other.runtimeType &&
                id == other.id &&
                name == other.name;

    @override
    int get hashCode =>
        id.hashCode ^
        name.hashCode;

    @override
    String toString() {
        return 'Tradeline{id: $id, name: $name}';
    }

    static Tradeline fromJson(Map<String, dynamic> map) {
        return Tradeline(map['id'], map['name']);
    }
}