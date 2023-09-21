@IsTest
private class GroupConditionTest {

    @IsTest
    static void testGroupCondition_And() {
        GroupCondition groupCondition = new GroupCondition(GroupCondition.GroupType.AND_C);
        groupCondition.add(new FieldCondition('Name', FieldCondition.Operator.Equals, 'John'));
        groupCondition.add(new FieldCondition('Age', FieldCondition.Operator.Equals, 30));
        String sql = groupCondition.toSql();

        Assert.areEqual('(Name=\'John\' AND Age=30)', sql);
    }

    @IsTest
    static void testGroupCondition_Or() {
        GroupCondition groupCondition = new GroupCondition(GroupCondition.GroupType.OR_C);
        groupCondition.add(new FieldCondition('Name', FieldCondition.Operator.Equals, 'John'));
        groupCondition.add(new FieldCondition('Name', FieldCondition.Operator.Equals, 'Jane'));
        String sql = groupCondition.toSql();

        Assert.areEqual('(Name=\'John\' OR Name=\'Jane\')', sql);
    }

    @IsTest
    static void testGroupCondition_Empty() {
        GroupCondition groupCondition = new GroupCondition(GroupCondition.GroupType.AND_C);
        String sql = groupCondition.toSql();

        Assert.areEqual('', sql);
    }

    @IsTest
    static void testGroupCondition_WithListConstructor() {
        List<Condition> conditions = new List<Condition>{
                new FieldCondition('Name', FieldCondition.Operator.Equals, 'John'),
                new FieldCondition('Age', FieldCondition.Operator.Equals, 30)
        };

        GroupCondition groupCondition = new GroupCondition(conditions, GroupCondition.GroupType.AND_C);
        String sql = groupCondition.toSql();

        Assert.areEqual('(Name=\'John\' AND Age=30)', sql);
    }

    @IsTest
    static void testInvalidGroupCondition_NullList() {
        Boolean exceptionThrown = false;
        Condition condition = null;
        try {
            new GroupCondition(condition, GroupCondition.GroupType.AND_C);
        } catch (IllegalArgumentException e) {
            exceptionThrown = true;
        }
        Assert.isTrue(exceptionThrown, 'Expected IllegalArgumentException to be thrown');
    }

    @IsTest
    static void testInvalidGroupCondition_EmptyList() {
        Boolean exceptionThrown = false;
        try {
            new GroupCondition(new List<Condition>(), GroupCondition.GroupType.AND_C);
        } catch (IllegalArgumentException e) {
            exceptionThrown = true;
        }
        Assert.isTrue(exceptionThrown, 'Expected IllegalArgumentException to be thrown');
    }

}
