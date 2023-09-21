public inherited sharing class SetCondition implements Condition{
    private String fieldApiName;
    private Operator operator;
    private Boolean multipleMatching = false;
    private Set<String> value;

    private static final Map<Operator, String> symbolByOperator = new Map<Operator, String> {
            Operator.In_s => ' IN ',
            Operator.Includes_s => ' INCLUDES ',
            Operator.Excludes_s => ' EXCLUDES '
    };

    public SetCondition() {}

    public SetCondition(String fieldApiName, Operator operator, Set<String> value) {
        this.fieldApiName = fieldApiName;
        this.operator = operator;
        this.value = value;
    }

    public SetCondition(String fieldApiName, Operator operator, Set<String> value, Boolean multipleMatching) {
        if (String.isBlank(fieldApiName) || operator == null || value.isEmpty()) {
            throw new IllegalArgumentException('All parameters must be set.');
        }
        this.fieldApiName = fieldApiName;
        this.operator = operator;
        this.value = value;
        this.multipleMatching = multipleMatching;
    }

    public SetCondition field(String fieldApiName) {
        this.fieldApiName = fieldApiName;
        return this;
    }

    public SetCondition operator(Operator operator) {
        this.operator = operator;
        return this;
    }

    public SetCondition value(Set<String> value) {
        this.value = value;
        return this;
    }

    public String toSql() {
        String value = this.parseValue();
        if (String.isBlank(fieldApiName) || operator == null || String.isBlank(value) || this.value.isEmpty()) {
            throw new IllegalArgumentException('All field parameters must be set for SetCondition.');
        }

        return this.fieldApiName + symbolByOperator.get(this.operator) + value;
    }

    private String parseValue() {
        String separator = this.multipleMatching ? '\';\'' : '\',\'';
        return '(\'' + String.join(new List<String>(this.value), separator) + '\')';
    }

    public enum Operator{
        In_s, Includes_s, Excludes_s
    }
}