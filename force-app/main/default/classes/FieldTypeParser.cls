public without sharing class FieldTypeParser {
        /**
         * Parses the object based on its actual type.
         *
         * @param fieldValue The field value to be parsed
         * @return The parsed value as a string ready for SOQL query
         */
        public static String parse(Object fieldValue) {
            if (fieldValue == null) {
                return 'null';
            }

            if (fieldValue instanceof String) {
                return '\'' + String.escapeSingleQuotes((String) fieldValue) + '\'';
            }

            if (fieldValue instanceof Date) {
                return ((Date) fieldValue).format();
            }

            if (fieldValue instanceof Datetime) {
                return ((Datetime) fieldValue).format();
            }

            if (fieldValue instanceof Boolean) {
                return ((Boolean) fieldValue) ? 'TRUE' : 'FALSE';
            }

            if (fieldValue instanceof Decimal || fieldValue instanceof Integer || fieldValue instanceof Double) {
                return String.valueOf(fieldValue);
            }

            throw new IllegalArgumentException('Unsupported field type: ' + fieldValue);
        }
}