/**
 * FieldCondition represents a basic field condition in a SOQL query.
 */
public inherited sharing class FieldCondition implements Condition {
    private String fieldApiName;
    private Operator operator;
    private Object value;

    private static final Map<Operator, String> symbolByOperator = new Map<Operator, String>{
            Operator.Equals => '=',
            Operator.NotEquals => '!='
    };

    public FieldCondition() {
    }


    /**
    * Creates a new FieldCondition.
    *
    * @param fieldApiName The API name of the field
    * @param operator The operator to use for the condition
    * @param value The value to compare against
    */
    public FieldCondition(String fieldApiName, Operator operator, Object value) {
        if (String.isBlank(fieldApiName) || operator == null) {
            throw new IllegalArgumentException('All parameters must be set.');
        }
        this.fieldApiName = fieldApiName;
        this.operator = operator;
        this.value = value;
    }

    public FieldCondition field(String fieldApiName) {
        this.fieldApiName = fieldApiName;
        return this;
    }

    public FieldCondition operator(Operator operator) {
        this.operator = operator;
        return this;
    }

    public FieldCondition value(String value) {
        this.value = value;
        return this;
    }


    /**
    * Generates the SQL equivalent of the condition.
    *
    * @return The SQL string
    */
    public String toSql() {
        if (String.isBlank(fieldApiName) || operator == null) {
            throw new IllegalArgumentException('All field parameters must be set for FieldCondition.');
        }
        String actualValue = FieldTypeParser.parse(value);
        return fieldApiName + symbolByOperator.get(operator) + actualValue;
    }

    public enum Operator {
        Equals, NotEquals
    }
}