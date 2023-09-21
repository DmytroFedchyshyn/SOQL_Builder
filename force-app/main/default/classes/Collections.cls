public without sharing class Collections {

    public static Boolean isEmpty(Set<String> objects) {
        return objects == null || objects.isEmpty();
    }

    public static Boolean isEmpty(Set<SObject> objects) {
        return objects == null || objects.isEmpty();
    }
}