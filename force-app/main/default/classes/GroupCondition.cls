/**
 * GroupCondition class is used for creating complex conditions that can be either 'AND' or 'OR'.
 * It can group multiple `Condition` objects together to form composite conditions.
 * Implements the `ISqlCallable` interface to provide an SOQL representation.
 */
public virtual inherited sharing class GroupCondition implements Condition {

    private final Map<GroupType, String> operatorByGroupType = new Map<GroupCondition.GroupType, String>{
            GroupType.AND_C => ' AND ',
            GroupType.OR_C => ' OR '
    };

    private List<Condition> conditions = new List<Condition>();
    private GroupType type;

    public GroupCondition(GroupType type) {
        this.type = type;
    }

    public GroupCondition(Condition condition, GroupType type) {
        if (condition == null) {
            throw new IllegalArgumentException('Condition cannot be null.');
        }
        this.conditions.add(condition);
        this.type = type;
    }

    public GroupCondition(List<Condition> conditions, GroupType type) {
        if (conditions == null || conditions.isEmpty()) {
            throw new IllegalArgumentException('At least one condition must be added.');
        }
        this.conditions.addAll(conditions);
        this.type = type;
    }

    public void add(Condition condition) {
        this.conditions.add(condition);
    }

    public String toSql() {
        if (conditions.isEmpty()) {
            return '';
        }

        List<String> parsedConditions = new List<String>();
        for (Condition condition : conditions) {
            parsedConditions.add(condition.toSql());
        }

        return '(' + String.join(parsedConditions, operatorByGroupType.get(this.type)) + ')';
    }

    public enum GroupType {
        AND_C, OR_C
    }
}