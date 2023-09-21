/**
 * SoqlBuilder class is designed for building SOQL queries in a dynamic, programmatic way.
 */
public with sharing class SoqlBuilder {
    private SObjectType sType;
    private Set<String> queriedFields;
    private Condition condition;
    private String orderBy;
    private Integer count;

    public SoqlBuilder() {
        this.queriedFields = new Set<String>();
    }

    public SoqlBuilder selectFields(Set<String> fields) {
        this.validateFields(fields);
        this.queriedFields = fields;
        return this;
    }

    public SoqlBuilder selectFields(List<String> fields) {
        return selectFields(new Set<String>(fields));
    }

    public SoqlBuilder fromSobject(SObjectType name) {
        this.sType = name;
        return this;
    }

    public SoqlBuilder fromSobject(String sobjectName) {
        this.sType = ((SObject) Type.forName(sobjectName).newInstance()).getSObjectType();
        return this;
    }

    public SoqlBuilder whereClause(Condition condition) {
        this.condition = condition;
        return this;
    }

    public SoqlBuilder orderBy(String field) {
        this.orderBy = field;
        return this;
    }

    public SoqlBuilder limitRecords(Integer count) {
        this.count = count;
        return this;
    }

    public String toSql() {
        if (Collections.isEmpty(this.queriedFields) || this.sType == null) {
            throw new IllegalArgumentException('Both fields and SObjectType must be specified.');
        }

        this.validateFieldNames(this.queriedFields, this.sType);
        StringBuilder query = new StringBuilder();
        query.append(SELECT_S)
                .append(String.join(new List<String>(queriedFields), ','))
                .append(FROM_S)
                .append(this.sType.getDescribe().getName());

        if (condition != null) {
            query.append(WHERE_S).append(condition.toSql());
        }
        if (String.isNotBlank(this.orderBy)) {
            query.append(ORDER_BY_S).append(this.orderBy);
        }
        if (this.count != null && this.count > 0) {
            query.append(LIMIT_S).append(String.valueOf(this.count));
        }

        return query.toString();
    }

    private void validateFieldNames(Set<String> fieldNames, SObjectType sType) {
        // Get a map of field names to field tokens (or "describe" results)
        Map<String, SObjectField> fieldMap = sType.getDescribe().fields.getMap();

        // Iterate over the provided field names to validate
        for (String fieldName : fieldNames) {
            if (!fieldMap.containsKey(fieldName)) {
                throw new IllegalArgumentException('Invalid field name: ' + fieldName);
            }
        }
    }

    private void validateFields(Set<String> fields) {
        if (Collections.isEmpty(fields)) {
            throw new IllegalArgumentException('Fields must be specified.');
        }
    }


    private static final String SELECT_S = 'SELECT ';
    private static final String FROM_S = ' FROM ';
    private static final String WHERE_S = ' WHERE ';
    private static final String ORDER_BY_S = ' ORDER BY ';
    private static final String LIMIT_S = ' LIMIT ';
}